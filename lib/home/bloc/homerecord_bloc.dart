import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:practica2_audd/utils/secrets.dart';
import 'package:record/record.dart';
import 'package:http/http.dart' as http;

part 'homerecord_event.dart';
part 'homerecord_state.dart';

class HomerecordBloc extends Bloc<HomerecordEvent, HomerecordState> {
  HomerecordBloc() : super(HomerecordInitial()) {
    on<HomerecordEvent>(_searchSong);
  }

  void _searchSong(HomerecordEvent event, Emitter emit) async {
    print("Will attempt to search for song");
    final tmpPath = await _obtainTempPath();
    print("Temp path: $tmpPath");

    final filePath = await doRecording(tmpPath, emit);
    print("File path: $filePath");
    File file = File(filePath!);
    print("File: $file");

    String fileString = await fileConvert(file);

    var json = await _recieveResponse(fileString);

    print(json);

    if (json == null || json["result"] == null) {
      emit(HomerecordFailureState());
    } else {
      final String songName = json['result']['title'];
      print("Song name: $songName");
      final String artistName = json['result']['artist'];
      print("Artist name: $artistName");
      final String albumName = json['result']['album'];
      print("Album name: $albumName");
      final String releaseDate = json['result']['release_date'];
      print("Release date: $releaseDate");
      final String appleLink = json['result']['apple_music']['url'];
      print("Apple link: $appleLink");
      final String spotifyLink =
          json['result']['spotify']['external_urls']['spotify'];
      print("Spotify link: $spotifyLink");
      final String albumCover =
          json['result']['spotify']['album']['images'][0]['url'];
      print("Album cover: $albumCover");
      final String listenLink = json['result']['song_link'];
      print("Listen link: $listenLink");

      emit(HomerecordSuccessState(
        songName: songName,
        artistName: artistName,
        albumName: albumName,
        releaseDate: releaseDate,
        appleLink: appleLink,
        spotifyLink: spotifyLink,
        albumCover: albumCover,
        listenLink: listenLink,
      ));
    }
  }

  Future<String?> doRecording(String tmpPath, Emitter<dynamic> emit) async {
    final Record _record = Record();
    try {
      //get permission
      bool permission = await _record.hasPermission();
      if (permission) {
        //start recording
        emit(HomerecordListeningState());
        await _record.start(
          path: '${tmpPath}/test.m4a',
          encoder: AudioEncoder.AAC, // by default
          bitRate: 128000, // by default
          samplingRate: 44100, // by default
        );
        //wait for 5 seconds
        await Future.delayed(Duration(seconds: 7));
        //stop recording
        return await _record.stop();
        //send to server

      } else {
        emit(HomerecordFailureState());
        print("Permission denied");
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<String> _obtainTempPath() async {
    Directory tempDir = await getTemporaryDirectory();
    return tempDir.path;
  }

  Future _recieveResponse(String file) async {
    emit(HomerecordFinishedState());
    print("Will start sending");
    http.Response response = await http.post(
      Uri.parse('https://api.audd.io/'),
      headers: {'Content-Type': 'multipart/form-data'},
      body: jsonEncode(
        <String, dynamic>{
          'api_token': AUDD_API_KEY,
          'return': 'apple_music,spotify',
          'audio': file,
          'method': 'recognize',
        },
      ),
    );
    if (response.statusCode == 200) {
      print("Success");
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load json');
    }
  }
}

Future<String> fileConvert(File file) async {
  List<int> fileBytes = await file.readAsBytes();
  print("File bytes: $fileBytes");
  String base64String = base64Encode(fileBytes);
  print("Base64 string: $base64String");
  return base64String;
}
