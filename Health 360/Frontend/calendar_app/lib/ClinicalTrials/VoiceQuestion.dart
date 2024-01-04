import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';

class VoiceQuestion extends StatefulWidget {
  final Function(String?) onVoiceQuestioned;
  final String question;
  final int index;
  final String questionImage;

  VoiceQuestion(
      {required this.question,
      required this.questionImage,
      required this.onVoiceQuestioned,
      required this.index});

  @override
  _VoiceQuestionState createState() => _VoiceQuestionState();
}

class _VoiceQuestionState extends State<VoiceQuestion>
    with TickerProviderStateMixin {
  late FlutterSoundRecorder _audioRecorder;
  late FlutterSoundPlayer _audioPlayer;
  String? filePath;
  bool isRecording = false;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioRecorder = FlutterSoundRecorder();
    _audioPlayer = FlutterSoundPlayer();
    initializeAudio();
  }

  Future<void> initializeAudio() async {
    await _audioRecorder.openAudioSession();
    await _audioPlayer.openAudioSession();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.questionImage.length > 0) {
      return Container(
        margin: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${widget.index + 1}. ${widget.question}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 8.0),
              child: Image.network(
                widget.questionImage,
                height: null,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Align _recordWidget to the center
              children: [
                _recordWidget(),
              ],
            ),
          ],
        ),
      );
    }
    return Container(
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${widget.index + 1}. ${widget.question}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.center, // Align _recordWidget to the center
            children: [
              _recordWidget(),
            ],
          ),
        ],
      ),
    );
  }

  _recordWidget() {
    final isRecording = _audioRecorder.isRecording;
    final icon = isRecording ? Icons.stop : Icons.mic_outlined;
    final text = isRecording ? 'STOP' : 'START';
    final primary = isRecording ? Colors.red.withOpacity(0.8) : Colors.white;
    final onPrimary = isRecording ? Colors.white : Colors.black;
    final isPlaying = _audioPlayer.isPlaying;
    final iconPlay = isPlaying ? Icons.stop : Icons.play_circle;
    final textPlay = isPlaying ? 'STOP' : 'PLAY';
    final primaryPlay = isPlaying ? Colors.red.withOpacity(0.8) : Colors.white;
    final onPrimaryPlay = isPlaying ? Colors.white : Colors.black;
    final iconPrimaryPlay =
        isPlaying ? Color.fromRGBO(65, 171, 101, 0.8) : Colors.white;

    final AnimationController _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    final Animation<Color?> _colorAnimation = ColorTween(
      begin: (isRecording ? primary : (isPlaying ? iconPrimaryPlay : primary)),
      end: primary.withOpacity(0.7),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (isRecording) {
      _animationController.repeat(reverse: true);
    } else {
      _animationController.reset();
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isRecording
                ? Icons.settings_voice_outlined
                : (isPlaying ? Icons.play_circle_fill_outlined : Icons.stop),
            size: 60,
            color: _colorAnimation.value,
          ),
          SizedBox(height: 10),
          Text(
            isRecording
                ? "Recording"
                : (isPlaying ? "Playing" : "Record Audio"),
            style: TextStyle(
                color: Colors.black,
                fontSize: isRecording ? 10 : (isPlaying ? 10 : 12)),
          ),
          SizedBox(height: 10),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.7,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color.fromRGBO(171, 147, 127, 0.8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: primary,
                    onPrimary: onPrimary,
                  ),
                  onPressed: () async {
                    await _toggleRecord();
                    setState(() {});
                  },
                  icon: Icon(icon),
                  label: Text(
                    text,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: primaryPlay,
                    onPrimary: onPrimaryPlay,
                  ),
                  onPressed: () async {
                    await _togglePlay();
                    setState(() {});
                  },
                  icon: Icon(iconPlay),
                  label: Text(
                    textPlay,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleRecord() async {
    if (_audioRecorder.isRecording) {
      await _audioRecorder.stopRecorder();
      _uploadAudioToFirebase();
    } else {
      final directory = await getApplicationDocumentsDirectory();
      final random = Random();
      final sixDigitCode =
          random.nextInt(900000) + 100000; // Generates a random 6-digit code
      final filePath = '${directory.path}/audio_$sixDigitCode.wav';
      //final filePath = '${directory.path}/audio.wav';
      await _audioRecorder.startRecorder(
        toFile: filePath,
        codec: Codec.pcm16WAV,
      );
      setState(() {
        this.filePath = filePath;
      });
    }
  }

  Future<void> _togglePlay() async {
    if (_audioPlayer.isPlaying) {
      await _audioPlayer.stopPlayer();
    } else {
      await _audioPlayer.startPlayer(
        fromURI: filePath!,
        codec: Codec.pcm16WAV,
        whenFinished: () => setState(() {}),
      );
    }
  }

  Future<void> _uploadAudioToFirebase() async {
    try {
      if (filePath == null || filePath!.isEmpty) {
        print('Error: Audio file path is null or empty');
        return;
      }

      final storage = FirebaseStorage.instance;
      final Reference audioRef = storage.ref().child('audio/${filePath!}');
      final audioFile = File(filePath!);
      await audioRef.putFile(audioFile);
      final audioURL = await audioRef.getDownloadURL();
      widget.onVoiceQuestioned(audioURL);
    } catch (e) {
      print('Error uploading audio: $e');
    }
  }

  @override
  void dispose() {
    _audioRecorder.closeAudioSession();
    _audioPlayer.closeAudioSession();
  }
}
