import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/public/flutter_sound_player.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:intl/intl.dart';

//class ResultPageApp is a stateless widget that returns a MaterialApp widget
class ResultPageApp extends StatelessWidget {
  ResultPageApp(this.data, this.hid);
  final Map data;
  final String hid;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Calendar data!',
      //theme: ThemeData(primarySwatch: primaryBlack),
      home: ResultPage(data, hid), //ResultPage widget is the home
    );
  }
}

//ResultPage is a stateful widget that takes in data and hid as its parameters
class ResultPage extends StatefulWidget {
  ResultPage(this.data, this.hid);

  final Map data;
  final String hid;

  @override
  State<ResultPage> createState() => _ResultPageState(data, hid);
}

class _ResultPageState extends State<ResultPage> with TickerProviderStateMixin {
  _ResultPageState(this.data, this.hid);
  final Map data;
  final String hid;
  final player = FlutterSoundPlayer();
  Timer? _timer;
  int _timerValue = 0;
  TextEditingController _timerController = TextEditingController();
  AnimationController? _animationController;
  Animation<double>? _animation;
  bool _isPlaying = false;
  bool _isTimerActive = false;

  @override
  void initState() {
    super.initState();
    player.openAudioSession();
  }

  @override
  void dispose() {
    player.closeAudioSession();
    super.dispose();
  }

//the build method returns a Scaffold widget with a background color and a Container widget as its child
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          // Add padding
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/Background.jpg"), fit: BoxFit.fill),
          ),

          //If hid is equal to "sleep_questionnaire_task" call buildResultPage function with data, hid, and context as parameters else call buildresultPage2 function
          child: (() {
            switch (hid) {
              case "parkinsons":
                return buildResultPage3(data, hid, context);
              case "sleep_questionnaire":
                return buildResultPage(data, hid, context);
              case "PHQ-8":
                return buildResultPage2(data, hid, context);
              case "GAD-7":
                return buildResultPage4(data, hid, context);
              case "AUDIT":
                return buildResultPage5(data, hid, context);
              case "diabetes":
                return buildResultPage6(data, hid, context);
              case "alzheimer":
                return buildResultPage7(data, hid, context);
            }
          })(),
        ),
      ),
    );
  }

//onPressed: () => Navigator.of(context).pop(),),

  Widget buildResultPage(Map data, String hid, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width / 41.1,
                MediaQuery.of(context).size.height / 28.1,
                MediaQuery.of(context).size.width / 41.1,
                0)),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width / 41.1,
                    MediaQuery.of(context).size.height / 28.1,
                    MediaQuery.of(context).size.width / 41.1,
                    MediaQuery.of(context).size.height / 20)),
            Text(
              "Health 360",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width / 22.05),
            ),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .17),
        Text(
          "DIAGNOSIS: " + data["classification"],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 20),
        SfRadialGauge(
          enableLoadingAnimation: true,
          animationDuration: 2000,
          axes: <RadialAxis>[
            RadialAxis(
              minimum: 0,
              maximum: 6,
              showLabels: true,
              showTicks: true,
              axisLineStyle: AxisLineStyle(
                thickness: 0.2,
                cornerStyle: CornerStyle.bothCurve,
                color: Color.fromARGB(30, 0, 169, 181),
                thicknessUnit: GaugeSizeUnit.factor,
              ),
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  positionFactor: 0.6,
                  angle: 90,
                  widget: Text(
                    'SCORE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                GaugeAnnotation(
                  positionFactor: 0.8,
                  angle: 90,
                  widget: Text(
                    data["score"].toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
              ],
              ranges: <GaugeRange>[
                GaugeRange(
                  startValue: 0,
                  endValue: 1,
                  color: Colors.green.withOpacity(0.6),
                  startWidth: 30,
                  endWidth: 30,
                ),
                GaugeRange(
                  startValue: 1,
                  endValue: 2,
                  color: Colors.yellow.withOpacity(0.6),
                  startWidth: 30,
                  endWidth: 30,
                ),
                GaugeRange(
                  startValue: 2,
                  endValue: 3,
                  color: Colors.orange.withOpacity(0.6),
                  startWidth: 30,
                  endWidth: 30,
                ),
                GaugeRange(
                  startValue: 3,
                  endValue: 4,
                  color: Colors.red.withOpacity(0.6),
                  startWidth: 30,
                  endWidth: 30,
                ),
                GaugeRange(
                  startValue: 4,
                  endValue: 5,
                  color: Colors.blue[800],
                  startWidth: 30,
                  endWidth: 30,
                ),
                GaugeRange(
                  startValue: 5,
                  endValue: 6,
                  color: Colors.black.withOpacity(0.9),
                  startWidth: 30,
                  endWidth: 30,
                ),
              ],
              pointers: <GaugePointer>[
                NeedlePointer(
                  value: data["score"],
                  enableAnimation: true,
                  animationDuration: 2000,
                ),
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget buildResultPage2(Map data, String hid, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Padding(padding: EdgeInsets.fromLTRB(20,25, 20, 0)),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
        ),

        Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            Padding(padding: EdgeInsets.fromLTRB(10, 30, 10, 15)),
            Text(
              "Health 360",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .17),
        Text(
          "DIAGNOSIS: " + data["classification"],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 20),
        SfRadialGauge(
          enableLoadingAnimation: true,
          animationDuration: 2000,
          axes: <RadialAxis>[
            RadialAxis(
              minimum: 0,
              maximum: 24,
              showLabels: true,
              showTicks: true,
              axisLineStyle: AxisLineStyle(
                thickness: 0.2,
                cornerStyle: CornerStyle.bothCurve,
                color: Color.fromARGB(30, 0, 169, 181),
                thicknessUnit: GaugeSizeUnit.factor,
              ),
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  positionFactor: 0.6,
                  angle: 90,
                  widget: Text(
                    'SCORE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                GaugeAnnotation(
                  positionFactor: 0.8,
                  angle: 90,
                  widget: Text(
                    data["score"].toString().split(".")[0],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
              ],
              ranges: <GaugeRange>[
                GaugeRange(
                  startValue: 0,
                  endValue: 4,
                  color: Colors.green.withOpacity(0.6),
                  startWidth: 30,
                  endWidth: 30,
                ),
                GaugeRange(
                  startValue: 4,
                  endValue: 9,
                  color: Colors.yellow.withOpacity(0.6),
                  startWidth: 30,
                  endWidth: 30,
                ),
                GaugeRange(
                  startValue: 9,
                  endValue: 14,
                  color: Colors.orange.withOpacity(0.6),
                  startWidth: 30,
                  endWidth: 30,
                ),
                GaugeRange(
                  startValue: 14,
                  endValue: 19,
                  color: Colors.red.withOpacity(0.6),
                  startWidth: 30,
                  endWidth: 30,
                ),
                GaugeRange(
                  startValue: 19,
                  endValue: 24,
                  color: Colors.black.withOpacity(0.9),
                  startWidth: 30,
                  endWidth: 30,
                ),
              ],
              pointers: <GaugePointer>[
                NeedlePointer(
                  value: data["score"],
                  enableAnimation: true,
                  animationDuration: 2000,
                ),
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget buildResultPage3(Map data, String hid, BuildContext context) {
    final isPlaying = player.isPlaying;
    final iconPlay =
        isPlaying ? Icons.play_circle_fill_outlined : Icons.play_circle;
    final primaryPlay = isPlaying ? Colors.red.withOpacity(0.8) : Colors.transparent;
    final onPrimaryPlay = isPlaying ? Colors.white : Colors.black;
    final textPlay = isPlaying ? 'PLAYING' : 'PLAY';

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
            padding: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width / 41.1,
                MediaQuery.of(context).size.height / 28.1,
                MediaQuery.of(context).size.width / 41.1,
                0)),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Padding(
                padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width / 41.1,
                    MediaQuery.of(context).size.height / 28.1,
                    MediaQuery.of(context).size.width / 41.1,
                    MediaQuery.of(context).size.height / 20)),
            Text(
              "Health 360",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MediaQuery.of(context).size.width / 22.05),
            ),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .17),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: _isPlaying
                      ? Colors.blue.withOpacity(_animation!.value)
                      : null,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  formatDuration(Duration(seconds: _timerValue)),
                  style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 25),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: primaryPlay,
                  onPrimary: onPrimaryPlay,
                ),
                onPressed:()async {
                        // Disable onPressed if _isPlaying is true
                        playAudio(data["parkinsonAudioApiUrl"].toString());
                      },
                icon: Icon(iconPlay,size: 28),
                label: FittedBox(fit: BoxFit.scaleDown, child: Text(textPlay,style:TextStyle(fontSize: 20,),)),
              ),
            ],
          ),
        ),
        SizedBox(height: 30),
        Text(
          "DIAGNOSIS: " + data["classification"],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  Widget buildResultPage4(Map data, String hid, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Padding(padding: EdgeInsets.fromLTRB(20,25, 20, 0)),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
        ),

        Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            Padding(padding: EdgeInsets.fromLTRB(10, 30, 10, 15)),
            Text(
              "Health 360",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .17),
        Text(
          "DIAGNOSIS: " + data["classification"],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 20),
        SfRadialGauge(
          enableLoadingAnimation: true,
          animationDuration: 2000,
          axes: <RadialAxis>[
            RadialAxis(
              minimum: 0,
              maximum: 21,
              showLabels: true,
              showTicks: true,
              axisLineStyle: AxisLineStyle(
                thickness: 0.2,
                cornerStyle: CornerStyle.bothCurve,
                color: Color.fromARGB(30, 0, 169, 181),
                thicknessUnit: GaugeSizeUnit.factor,
              ),
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  positionFactor: 0.6,
                  angle: 90,
                  widget: Text(
                    'SCORE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                GaugeAnnotation(
                  positionFactor: 0.8,
                  angle: 90,
                  widget: Text(
                    data["score"].toString().split(".")[0],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
              ],
              ranges: <GaugeRange>[
                GaugeRange(
                  startValue: 0,
                  endValue: 5,
                  color: Colors.green.withOpacity(0.6),
                  startWidth: 30,
                  endWidth: 30,
                ),
                GaugeRange(
                  startValue: 5,
                  endValue: 10,
                  color: Colors.yellow.withOpacity(0.6),
                  startWidth: 30,
                  endWidth: 30,
                ),
                GaugeRange(
                  startValue: 10,
                  endValue: 15,
                  color: Colors.orange.withOpacity(0.6),
                  startWidth: 30,
                  endWidth: 30,
                ),
                GaugeRange(
                  startValue: 15,
                  endValue: 21,
                  color: Colors.red.withOpacity(0.6),
                  startWidth: 30,
                  endWidth: 30,
                )
              ],
              pointers: <GaugePointer>[
                NeedlePointer(
                  value: data["score"],
                  enableAnimation: true,
                  animationDuration: 2000,
                ),
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget buildResultPage5(Map data, String hid, BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Padding(padding: EdgeInsets.fromLTRB(20,25, 20, 0)),
        Padding(
          padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
        ),

        Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            Padding(padding: EdgeInsets.fromLTRB(10, 30, 10, 15)),
            Text(
              "Health 360",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .17),
        Text(
          "DIAGNOSIS: " + data["classification"],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 20),
        SfRadialGauge(
          enableLoadingAnimation: true,
          animationDuration: 2000,
          axes: <RadialAxis>[
            RadialAxis(
              minimum: 0,
              maximum: 24,
              showLabels: true,
              showTicks: true,
              axisLineStyle: AxisLineStyle(
                thickness: 0.2,
                cornerStyle: CornerStyle.bothCurve,
                color: Color.fromARGB(30, 0, 169, 181),
                thicknessUnit: GaugeSizeUnit.factor,
              ),
              annotations: <GaugeAnnotation>[
                GaugeAnnotation(
                  positionFactor: 0.6,
                  angle: 90,
                  widget: Text(
                    'SCORE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                GaugeAnnotation(
                  positionFactor: 0.8,
                  angle: 90,
                  widget: Text(
                    data["score"].toString().split(".")[0],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
              ],
              ranges: <GaugeRange>[
                GaugeRange(
                  startValue: 0,
                  endValue: 4,
                  color: Colors.green.withOpacity(0.6),
                  startWidth: 30,
                  endWidth: 30,
                ),
                GaugeRange(
                  startValue: 4,
                  endValue: 9,
                  color: Colors.yellow.withOpacity(0.6),
                  startWidth: 30,
                  endWidth: 30,
                ),
                GaugeRange(
                  startValue: 9,
                  endValue: 14,
                  color: Colors.orange.withOpacity(0.6),
                  startWidth: 30,
                  endWidth: 30,
                ),
                GaugeRange(
                  startValue: 14,
                  endValue: 19,
                  color: Colors.red.withOpacity(0.6),
                  startWidth: 30,
                  endWidth: 30,
                ),
                GaugeRange(
                  startValue: 19,
                  endValue: 24,
                  color: Colors.black.withOpacity(0.9),
                  startWidth: 30,
                  endWidth: 30,
                ),
              ],
              pointers: <GaugePointer>[
                NeedlePointer(
                  value: data["score"],
                  enableAnimation: true,
                  animationDuration: 2000,
                ),
              ],
            )
          ],
        ),
      ],
    );
  }

  Future<void> playAudio(String audioUrl) async {
    final response = await http.get(Uri.parse(audioUrl));

    try {
      if (response.statusCode == 200) {
        // Get the temporary directory for storing the audio file
        final tempDir = await getTemporaryDirectory();
        final tempFilePath = "${tempDir.path}/audio.wav";

        // Save the response data to the temporary file
        final audioFile = File(tempFilePath);
        await audioFile.writeAsBytes(response.bodyBytes);

        _animationController = AnimationController(
          vsync: this,
          // duration: Duration(milliseconds: 500), // Adjust the duration as needed
        );

        _animation = CurvedAnimation(
          parent: _animationController!,
          curve: Curves.easeInOut,
        );

        // Start the timer
        _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
          setState(() {
            _timerValue = timer.tick;
            _timerController.text = '$_timerValue seconds';
          });
        });

        // Play the saved audio file using flutter_sound_lite
        await player.startPlayer(
          fromURI: tempFilePath,
          whenFinished: () {
            // Cancel the timer when playback completes
            _timer?.cancel();
            _timerValue = 0;
            _animationController?.dispose();
            _isPlaying = false;
            setState(() {
              _isPlaying = true;
            }); // Update the UI when playback finishes
          },
        );

      } else {
        throw Exception('Failed to load audio');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


Widget buildResultPage6(Map data, String hid, BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Padding(padding: EdgeInsets.fromLTRB(MediaQuery
          .of(context)
          .size
          .width / 41.1, MediaQuery
          .of(context)
          .size
          .height / 28.1, MediaQuery
          .of(context)
          .size
          .width / 41.1, 0)),
      Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),),
          Padding(padding: EdgeInsets.fromLTRB(MediaQuery
              .of(context)
              .size
              .width / 41.1, MediaQuery
              .of(context)
              .size
              .height / 28.1, MediaQuery
              .of(context)
              .size
              .width / 41.1, MediaQuery
              .of(context)
              .size
              .height / 20)),
          Text(
            "Health 360",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery
                .of(context)
                .size
                .width / 22.05),
          ),
        ],
      ),
      SizedBox(height: MediaQuery
          .of(context)
          .size
          .height * .17),
      Text(
        "DIAGNOSIS: " + data["classification"],
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      SizedBox(height: 20),
      SfRadialGauge(
        enableLoadingAnimation: true,
        animationDuration: 2000,
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 2,
            showLabels: true,
            showTicks: true,
            axisLineStyle: AxisLineStyle(
              thickness: 0.2,
              cornerStyle: CornerStyle.bothCurve,
              color: Color.fromARGB(30, 0, 169, 181),
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                positionFactor: 0.6,
                angle: 90,
                widget: Text(
                  'SCORE',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              GaugeAnnotation(
                positionFactor: 0.8,
                angle: 90,
                widget: Text(
                  data["score"].toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
            ],
            ranges: <GaugeRange>[
              GaugeRange(
                startValue: 0,
                endValue: 0.666,
                color: Colors.green.withOpacity(0.6),
                startWidth: 30,
                endWidth: 30,
              ),
              GaugeRange(
                startValue: 0.666,
                endValue: 1.333,
                color: Colors.yellow.withOpacity(0.6),
                startWidth: 30,
                endWidth: 30,
              ),
              GaugeRange(
                startValue: 1.333,
                endValue: 2,
                color: Colors.red.withOpacity(0.6),
                startWidth: 30,
                endWidth: 30,
              ),
            ],
            pointers: <GaugePointer>[
              NeedlePointer(
                value: data["score"],
                enableAnimation: true,
                animationDuration: 2000,
              ),
            ],
          )
        ],
      ),
    ],
  );
}

Widget buildResultPage7(Map data, String hid, BuildContext context) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Padding(padding: EdgeInsets.fromLTRB(MediaQuery
          .of(context)
          .size
          .width / 41.1, MediaQuery
          .of(context)
          .size
          .height / 28.1, MediaQuery
          .of(context)
          .size
          .width / 41.1, 0)),
      Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),),
          Padding(padding: EdgeInsets.fromLTRB(MediaQuery
              .of(context)
              .size
              .width / 41.1, MediaQuery
              .of(context)
              .size
              .height / 28.1, MediaQuery
              .of(context)
              .size
              .width / 41.1, MediaQuery
              .of(context)
              .size
              .height / 20)),
          Text(
            "Health 360",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: MediaQuery
                .of(context)
                .size
                .width / 22.05),
          ),
        ],
      ),
      SizedBox(height: MediaQuery
          .of(context)
          .size
          .height * .17),
      Text(
        "DIAGNOSIS: " + data["classification"],
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      SizedBox(height: 20),
      SfRadialGauge(
        enableLoadingAnimation: true,
        animationDuration: 2000,
        axes: <RadialAxis>[
          RadialAxis(
            minimum: 0,
            maximum: 1,
            showLabels: true,
            showTicks: true,
            axisLineStyle: AxisLineStyle(
              thickness: 0.2,
              cornerStyle: CornerStyle.bothCurve,
              color: Color.fromARGB(30, 0, 169, 181),
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                positionFactor: 0.6,
                angle: 90,
                widget: Text(
                  'SCORE',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              GaugeAnnotation(
                positionFactor: 0.8,
                angle: 90,
                widget: Text(
                  data["score"].toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
            ],
            ranges: <GaugeRange>[
              GaugeRange(
                startValue: 0,
                endValue: 0.5,
                color: Colors.green.withOpacity(0.6),
                startWidth: 30,
                endWidth: 30,
              ),
              GaugeRange(
                startValue: 0.5,
                endValue: 1,
                color: Colors.red.withOpacity(0.6),
                startWidth: 30,
                endWidth: 30,
              ),
            ],
            pointers: <GaugePointer>[
              NeedlePointer(
                value: data["score"],
                enableAnimation: true,
                animationDuration: 2000,
              ),
            ],
          )
        ],
      ),
    ],
  );
}

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    //final milliseconds = duration.inMilliseconds % 1000;

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}


