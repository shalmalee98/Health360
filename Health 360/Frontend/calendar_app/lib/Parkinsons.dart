import 'package:flutter/scheduler.dart';

import 'package:flutter/widgets.dart';
import 'package:Health_Guardian/environment.dart';
import 'package:Health_Guardian/soundRecorder.dart';
import 'package:flutter/material.dart';
import 'package:Health_Guardian/apiCall.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'Constants/urlConstant.dart';
import 'GetSampleApi.dart';
import 'task_page.dart';
import 'package:http/http.dart' as http;

String phqRequestPath = 'Json/phqRequest.json';

String jsonString = '''
{
  "data_endpoint": "https://hg-production-taskmanager-ssc.ortmd733nb9.us-east.codeengine.appdomain.cloud/api/v1/datasets/0d78cf90-02b8-42f1-a15e-80687f4880d5"
}
''';

final pathToaudio = 'audio';

String filePath = '/data/user/0/com.example.Health_Guardian/cache/audio';

class ParkinsonsScreen extends StatefulWidget {
  @override
  State<ParkinsonsScreen> createState() => _ParkinsonsScreenState();
}

class _ParkinsonsScreenState extends State<ParkinsonsScreen>
    with TickerProviderStateMixin {
  bool _isloading = false;
  final record = soundRecorder();
  final player = soundPlayer();
  List<GetSampleApi>? apiList;

  @override
  void initState() {
    super.initState();

    record.init();
    player.init();
  }

  String _selectedOption = "Task";
  bool test = false;
  String taskappend = "";

  @override
  void dispose() {
    record.dispose();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isloading
          ? Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/Background.jpg"),
                  fit: BoxFit.cover,
                ),
              ),

              // CircularProgressIndicator in the center if the data is loading

              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/Background.jpg"),
                    fit: BoxFit.fill),
              ),
              child: Column(children: [
                Padding(padding: EdgeInsets.fromLTRB(20, 60, 20, 0)),
                Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TaskPage()))),
                    Padding(padding: EdgeInsets.fromLTRB(10, 30, 10, 15)),
                    Text(
                      "Health 360",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
                SafeArea(
                    child: Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "Parkinsons Assessment",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: MediaQuery.of(context).size.width / 18.4,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
                SafeArea(child: _recordWidget())
              ])),
    );
  }

  _recordWidget() {
    final isRecording = record.isRecordingStatus;
    final icon = isRecording ? Icons.stop : Icons.mic_outlined;
    final text = isRecording ? 'STOP' : 'START';
    final primary = isRecording ? Colors.red.withOpacity(0.8) : Colors.white;
    final onPrimary = isRecording ? Colors.white : Colors.black;
    final isPlaying = player.isPlayingStatus;
    final iconPlay = isPlaying ? Icons.stop : Icons.play_circle;
    final textPlay = isPlaying ? 'STOP PLAYING' : 'PLAY';
    final primaryPlay = isPlaying ? Colors.red.withOpacity(0.8) : Colors.white;
    final onPrimaryPlay = isPlaying ? Colors.white : Colors.black;
    final iconprimaryPlay =
        isPlaying ? Color.fromRGBO(65, 171, 101, 0.8) : Colors.white;

    // final IconData iconImage = isRecording
    //     ? Icons.mic_outlined // Show microphone icon while recording
    //     : (isPlaying ? Icons.play_arrow : Icons.stop); // Show play icon while playing

    final AnimationController _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    final Animation<Color?> _colorAnimation = ColorTween(
      begin: (isRecording ? primary : (isPlaying ? iconprimaryPlay : primary)),
      end: primary.withOpacity(0.7), // Adjust the opacity for glowing effect
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
          // Glowing microphone icon or stop icon based on recording and playing states
          Icon(
            isRecording
                ? Icons.settings_voice_outlined
                : (isPlaying ? Icons.play_circle_fill_outlined : Icons.stop),
            size: 80,
            color: _colorAnimation.value,
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 42.3),
          Text(
            isRecording
                ? "Recording"
                : (isPlaying ? "Playing" : "Record Audio"),
            style: TextStyle(
              color: Colors.black,
              fontSize: isRecording
                  ? 25.55
                  : (isPlaying
                      ? 25.55
                      : MediaQuery.of(context).size.width / 15),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 42.3),
          Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width * 0.93,
            padding: EdgeInsets.all(MediaQuery.of(context).size.height / 26),
            decoration: BoxDecoration(
              color: Color.fromRGBO(171, 147, 127, 0.8),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(children: [
              Expanded(
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      //minimumSize: Size(100, 10),
                      primary: primary,
                      onPrimary: onPrimary,
                    ),
                    onPressed: () async {
                      final isRecording = await record.toggleRecord("");
                      setState(() {});
                    },
                    icon: Icon(icon),
                    label: FittedBox(fit: BoxFit.scaleDown, child: Text(text))),
              ),
              Expanded(
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      // minimumSize: Size(100,10),
                      primary: primaryPlay,
                      onPrimary: onPrimaryPlay,
                    ),
                    onPressed: () async {
                      final isPlaying = await player.togglePlay(
                          whenFin: () => setState(() {}));
                      setState(() {});
                    },
                    icon: Icon(iconPlay),
                    label: FittedBox(
                        fit: BoxFit.scaleDown, child: Text(textPlay))),
              )
            ]),
          ),
          SizedBox(height: MediaQuery.of(context).size.height / 42.3),
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                alignment: Alignment.center,
                minimumSize: Size(110, 50),
                primary: Color.fromRGBO(65, 171, 101, 0.8),
              ),
              onPressed: isRecording || isRecording
                  ? null // Disable button when not recording
                  : () async {
                      // Assuming you have the Base64 audio data available as a String named base64AudioData
                      _showDialog(context);
                      postParkinson(
                          setEnvironment.apiBaseUrlPAR, par_unencoded_post);
                    },
              icon: Icon(Icons.restart_alt),
              label: FittedBox(fit: BoxFit.scaleDown, child: Text("ANALYSE"))),
          SizedBox(height: MediaQuery.of(context).size.height / 42.3),
        ],
      ),
    );
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Text('Your results will be ready in 5 minutes!'),
          content: Text('Kindly check the results page for diagnosis.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
