import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
//import 'package:flutter_dotenv/flutter_dotenv.dart';
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
    //await dotenv.load(fileName: ".env");
    //print("Dotenv loaded");
    final filePath = await doRecording(tmpPath, emit);
    print("File path: $filePath");
    File file = File(filePath!);
    print("File: $file");

    String fileString = await fileConvert(file);

    var response = await _recieveResponse(fileString);

    print(response);
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
