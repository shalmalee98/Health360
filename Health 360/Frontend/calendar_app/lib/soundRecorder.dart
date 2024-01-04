import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:flutter_sound_lite/public/flutter_sound_player.dart';
import 'package:flutter_sound_lite/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'Parkinsons.dart';

String base64AudioData = '';

class soundRecorder {
  FlutterSoundRecorder? _audioRecorder;

  // recorder initialization
  bool recorderIntialised = false;

  //to check of recorder is recording
  bool get isRecordingStatus => _audioRecorder!.isRecording;
  Stream<RecordingDisposition>? _recordingStream;

  Future<void> init() async {
    _audioRecorder = FlutterSoundRecorder();

    final permissionStatus = await Permission.microphone.request();
    if (permissionStatus != PermissionStatus.granted) {
      throw RecordingPermissionException(" Microphone permission not granted");
    }
    final statusStorage = await Permission.storage.status;
    if (!statusStorage.isGranted) {
      await Permission.storage.request();
    }
    await _audioRecorder!.openAudioSession();
    directoryPath = await _directoryPath();
    completePath = await _completePath(directoryPath);
    _createDirectory();
    _createFile();
    recorderIntialised = true;
  }

  //To start recording
  Future _record(String completePath) async {
    if (!recorderIntialised) return;
    print("Path where the file will be : " + completePath);
    await _audioRecorder!.startRecorder(
      toFile: completePath,
      numChannels: 1,
      sampleRate: 44100,
    );
  }

  Future _stopRecorder() async {
    if (!recorderIntialised) return;
    final filePath = await _audioRecorder?.stopRecorder();
    //final file = File(filePath! as List<Object>);
    File f = File(completePath);
    print("The created file : $f");
    // print('Recorded path: $pathToaudio');
  }

  //To start or stop by one click
  Future toggleRecord(String path) async {
    if (!recorderIntialised) return;
    if (_audioRecorder!.isStopped) {
      await _record(path);
    } else if (_audioRecorder!.isRecording) {
      await _stopRecorder();
    }
    ;
  }

  Future<void> dispose() async {
    if (!recorderIntialised) return;
    await _audioRecorder!.closeAudioSession();
    _audioRecorder = null;
    recorderIntialised = false;
  }

  String completePath = "";
  String directoryPath = "";

  Future<String> _completePath(String directory) async {
    var fileName = _fileName();
    return "$directory$fileName";
  }

  Future<String> _directoryPath() async {
    var directory = await getApplicationDocumentsDirectory();
    var directoryPath = directory.path;
    return "$directoryPath/records/";
  }

  String _fileName() {
    return "record.wav";
  }

  Future _createFile() async {
    File(completePath).create(recursive: true).then((File file) async {
      //write to file
      Uint8List bytes = await file.readAsBytes();
      file.writeAsBytes(bytes);
      print("FILE CREATED AT : " + file.path);
    });
  }

  void _createDirectory() async {
    bool isDirectoryCreated = await Directory(directoryPath).exists();
    if (!isDirectoryCreated) {
      Directory(directoryPath).create().then((Directory directory) {
        print("DIRECTORY CREATED AT : " + directory.path);
      });
    }
  }
}

class soundPlayer {
  FlutterSoundPlayer? _audioPlayer;
  // recorder initialization
  bool playerIntialised = false;

  //to check of recorder is recording
  bool get isPlayingStatus => _audioPlayer!.isPlaying;

  Future<void> init() async {
    _audioPlayer = FlutterSoundPlayer();

    await _audioPlayer!.openAudioSession();
    playerIntialised = true;
  }

  //To start playing
  Future _play(VoidCallback whenFin) async {
    if (!playerIntialised) return;
    await _audioPlayer!.startPlayer(
        fromURI:
            "/data/user/0/com.example.Health_Guardian/app_flutter/records/record.wav",
        whenFinished: whenFin);
    print("============================================");
    print(pathToaudio);
    print("============================================");
  }

  Future _stopPlayer() async {
    await _audioPlayer?.stopPlayer();
  }

  //To start or stop by one click
  Future togglePlay({required VoidCallback whenFin}) async {
    if (!playerIntialised) return;
    if (_audioPlayer!.isStopped) {
      await _play(whenFin);
    } else if (_audioPlayer!.isPlaying) {
      await _stopPlayer();
    }
    ;
  }

  Future<void> dispose() async {
    if (!playerIntialised) return;
    await _audioPlayer!.closeAudioSession();
    _audioPlayer = null;
    playerIntialised = false;
  }
}

Future<void> saveFileToStorage() async {
  // Get the directory where the file will be saved
  Directory directory = await getApplicationDocumentsDirectory();
  String filePath =
      directory.path + '/my_file.txt'; // Replace with your desired file name

  // Create the file
  File file = File(filePath);

  // Write content to the file
  await file.writeAsString('Hello, world!'); // Replace with your content

  print('File saved at: $filePath');
}
