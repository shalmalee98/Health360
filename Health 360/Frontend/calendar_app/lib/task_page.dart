import 'dart:math';

import 'package:Health_Guardian/ALSQuestionnaire.dart';
import 'package:Health_Guardian/BradykinesiaQuestionnaire.dart';
import 'package:Health_Guardian/MotorSymptomQuestionnaire.dart';
import 'package:Health_Guardian/Parkinsons.dart';
import 'package:Health_Guardian/loginpage.dart';
import 'package:flutter/material.dart';
import 'AlzheimerQuestionnaire.dart';
import 'PHQ8Questinairre.dart';
import 'GAD7Questionnaire.dart';
import 'AUDITQuestionnaire.dart';
import 'DiabetesQuestionnaire.dart';
import 'package:Health_Guardian/SleepQuestionnaire.dart';
import 'package:Health_Guardian/widgetpane.dart';
import 'dart:async';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'notification.dart';

int _selectedIndex = 0; // index for widget pane to show the current page
double wdt = 360.0;
double ht = 700.0;

class TaskPage extends StatefulWidget {
  // final String user;
  //
  // TaskPage({this.user= "User01"});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  // final NotificationHelper notificationHelper =
  //     NotificationHelper(FlutterLocalNotificationsPlugin());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  // final String user;

  // Timer _timer = Timer(Duration.zero, () {});

  bool _isVisible = false;
  bool _isVisBrad = true;
  bool _isVisSleep = true;
  bool _isVisPHQ = true;
  bool _isVisPsy = true;
  bool _isVisGAD = true;
  bool _isVisAUDIT = true;
  bool _isVisPar = true;
  bool _isVisDiab = true;

  bool _isVisMSA = true;
  bool _isVisALS = true;

  // _TaskPageState({required this.user});
  bool _drawerShow = false;

  @override
  void initState() {
    super.initState();

    _startTimer();
  }

  void _startTimer() {
    int count = 0;
    // _timer = Timer.periodic(Duration(seconds: 20), (timer) {
    //   var now = DateTime.now();
    //   var startTime = DateTime(now.year, now.month, now.day, 6, 0,
    //       0); // Replace with your start time
    //   var endTime = DateTime(
    //       now.year, now.month, now.day, 17, 0, 0); // Replace with your end time
    //   if (now.isBefore(startTime) || now.isAfter(endTime)) {
    //     _setVisible(false);
    //
    //     // print('inside if');
    //   } else {
    //     _setVisible(true);
    //     // print('inside else');
    //
    //     // if (count == 0) {
    //     //   notificationHelper.showNotification(
    //     //       'Health Guardian', 'Two New Tasks are available ');
    //     //   count = count + 1;
    //     // }
    //   }
    // });

    // if (_isVisible) {
    //   //notificationHelper.showNotification('Health Guardian', 'Two New Tasks are available ');
    // }
  }

  void _setVisible(bool isVisible) {
    if (mounted) {
      // check if the widget is still mounted
      setState(() {
        _isVisible = isVisible;
      });
    }
  }

  @override
  void dispose() {
    // _timer?.cancel(); // cancel the timer on dispose
    super.dispose();
  }

  void _onButtonPressed(BuildContext context, String label) {
    // Define your navigation logic here.
    // For now, we'll navigate to a dummy page with the label.
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => DummyPage(label: label),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // taking the height and width of the device
    wdt = MediaQuery.of(context).size.width;
    ht = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,

          //setting up the background

          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/Background.jpg"), fit: BoxFit.cover),
          ),
          child: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
                  ),
                  Row(
                    children: [
                      Padding(padding: EdgeInsets.fromLTRB(10, 30, 10, 0)),
                      Text(
                        "Health 360",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: wdt / 21),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.47,
                      ),
                      GestureDetector(
                        child: Container(
                          width: wdt / 12,
                          height: ht / 24,
                          child: Icon(
                            Icons.perm_identity_outlined,
                            color: Colors.grey[200],
                          ),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(63, 94, 139, 0.6),
                              shape: BoxShape.circle),
                        ),
                        onTap: () {
                          _scaffoldKey.currentState!.openDrawer();
                        },
                      )
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(wdt / 13.8)),
                  Row(children: [
                    Padding(padding: EdgeInsets.all(wdt / 27.6)),
                    Container(
                      height: ht / 10.5,
                      width: wdt / 2.74,
                      //color: Colors.red,
                      child: Text(
                        "Hello,\n" + user,
                        style: TextStyle(fontSize: wdt / 11.8),
                      ),
                    )
                  ]),
                  Padding(padding: EdgeInsets.all(wdt / 82.2)),
                  Row(
                    children: [
                      Padding(padding: EdgeInsets.fromLTRB(15, 0, 15, 5)),
                      Container(
                          height: ht / 33.8,
                          width: wdt * 0.85,
                          //color: Colors.red,
                          child: Text(
                            "The following are the available tasks: ",
                            style: TextStyle(fontSize: wdt / 20.5),
                          ))
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(wdt / 82.2)),

                  //creating the search bar

                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(
                            wdt / 8.22, ht / 168.6, wdt / 41.1, ht / 168.6)),
                    Expanded(
                        child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: wdt / 205.5, vertical: ht / 421.5),
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(),
                        ),
                      ),
                      onChanged: (search) {
                        //search logic
                        if (search != null) {
                          if ('bradykinesia assessment'
                              .startsWith(search.toLowerCase())) {
                            setState(() {
                              _isVisBrad = true;
                            });
                          } else {
                            setState(() {
                              _isVisBrad = false;
                            });
                          }
                          if ('sleep questionnaire (sq)'
                              .startsWith(search.toLowerCase())) {
                            setState(() {
                              _isVisSleep = true;
                            });
                          } else {
                            setState(() {
                              _isVisSleep = false;
                            });
                          }
                          if ('patient health questionnaire (phq-8)'
                              .startsWith(search.toLowerCase())) {
                            setState(() {
                              _isVisPHQ = true;
                            });
                          } else {
                            _isVisPHQ = false;
                          }
                          if ("psyche alzheimer's"
                              .startsWith(search.toLowerCase())) {
                            setState(() {
                              _isVisPsy = true;
                            });
                          } else {
                            _isVisPsy = false;
                          }
                          if ('generalized anxiety disorder (GAD-7)'
                              .startsWith(search.toLowerCase())) {
                            setState(() {
                              _isVisGAD = true;
                            });
                          } else {
                            _isVisGAD = false;
                          }
                          if ('alcohol use disorders identification test (AUDIT-C)'
                              .startsWith(search.toLowerCase())) {
                            setState(() {
                              _isVisAUDIT = true;
                            });
                          } else {
                            _isVisAUDIT = false;
                          }
                          if ("parkinsons assessment"
                              .startsWith(search.toLowerCase())) {
                            setState(() {
                              _isVisPar = true;
                            });
                          } else {
                            _isVisPar = false;
                          }
                          if ("diabetes detection"
                              .startsWith(search.toLowerCase())) {
                            setState(() {
                              _isVisDiab = true;
                            });
                          } else {
                            _isVisDiab = false;
                          }
                          if ("motor symptom assessment"
                              .startsWith(search.toLowerCase())) {
                            setState(() {
                              _isVisMSA = false;
                            });
                          } else {
                            _isVisMSA = false;
                          }
                          if ("amyotrophic lateral sclerosis(als)"
                              .startsWith(search.toLowerCase())) {
                            setState(() {
                              _isVisALS = false;
                            });
                          } else {
                            _isVisALS = false;
                          }
                        } else {
                          _isVisPsy = true;
                          _isVisPHQ = true;
                          _isVisSleep = true;
                          _isVisAUDIT = true;
                          _isVisBrad = true;
                          _isVisGAD = true;
                          _isVisMSA = true;
                          _isVisALS = true;
                        }
                      },
                    )),
                    Padding(padding: EdgeInsets.all(wdt / 10.3)),
                  ]),

                  Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: wdt / 84.3, horizontal: ht / 82.2)),
                  Expanded(
                    child: SingleChildScrollView(
                      //creating the button for tasks

                      child: Container(
                        child: Column(children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                wdt / 9, ht / 84.3, wdt / 9, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // setting up the visibility for the tasks
                                Visibility(
                                  visible: _isVisPHQ, // hide the row
                                  maintainSize: false,
                                  maintainAnimation: false,
                                  maintainState: false,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        0, 0, wdt / 22.05, ht / 84.3),
                                    child: SizedBox(
                                      width: wdt / 2.74,
                                      height: ht / 5.62,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      PHQ8Screen()));
                                        },
                                        child: Text(
                                            "Patient Health Questionnaire (PHQ-8)",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: wdt / 23)),
                                        style: ElevatedButton.styleFrom(
                                            primary: Color.fromRGBO(
                                                244, 172, 69, 0.6),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25))),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: _isVisPar,
                                  maintainSize: false,
                                  maintainAnimation: false,
                                  maintainState: false,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(0, 0, 0, ht / 84.3),
                                    child: SizedBox(
                                      width: wdt / 2.74,
                                      height: ht / 5.62,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ParkinsonsScreen()));
                                        },
                                        child: Text("Parkinsons Assessment",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: wdt / 23)),
                                        style: ElevatedButton.styleFrom(
                                            primary: Color.fromRGBO(
                                                65, 171, 101, 0.6),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25))),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                wdt / 9, ht / 84.3, wdt / 9, 0),
                            child: Row(
                              children: [
                                Visibility(
                                  visible: _isVisSleep, // hide the row
                                  maintainSize: false,
                                  maintainAnimation: false,
                                  maintainState: false,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        0, 0, wdt / 22.05, ht / 84.3),
                                    child: SizedBox(
                                      width: wdt / 2.74,
                                      height: ht / 5.62,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SLeepQ()));
                                        },
                                        child: Text("Sleep Questionaire (SQ)",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: wdt / 23)),
                                        style: ElevatedButton.styleFrom(
                                            primary: Color.fromRGBO(
                                                171, 147, 127, 0.6),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25))),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: _isVisPsy, // hide the row
                                  maintainSize: false,
                                  maintainAnimation: false,
                                  maintainState: false,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(0, 0, 0, ht / 84.3),
                                    child: SizedBox(
                                      width: wdt / 2.74,
                                      height: ht / 5.62,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AlzheimerDetectionScreen()));
                                        },
                                        child: Text("PsychE Alzheimer's",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: wdt / 23)),
                                        style: ElevatedButton.styleFrom(
                                            primary: Color.fromRGBO(
                                                63, 94, 139, 0.6),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25))),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                wdt / 9, ht / 84.3, wdt / 9, 0),
                            child: Row(
                              children: [
                                Visibility(
                                  visible: _isVisGAD, // hide the row
                                  maintainSize: false,
                                  maintainAnimation: false,
                                  maintainState: false,
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        0, 0, wdt / 22.05, ht / 84.3),
                                    child: SizedBox(
                                      width: wdt / 2.74,
                                      height: ht / 5.62,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      GAD7Screen()));
                                        },
                                        child: Text(
                                            "Generalized Anxiety Disorder (GAD-7)",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: wdt / 23)),
                                        style: ElevatedButton.styleFrom(
                                            primary: Color.fromRGBO(
                                                85, 107, 47, 0.6),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25))),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: _isVisAUDIT, // hide the row
                                  maintainSize: false,
                                  maintainAnimation: false,
                                  maintainState: false,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(0, 0, 0, ht / 84.3),
                                    child: SizedBox(
                                      width: wdt / 2.74,
                                      height: ht / 5.62,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AUDITScreen()));
                                        },
                                        child: Text(
                                            "Alcohol Use Disorders Identification Test (AUDIT-C)",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: wdt / 23)),
                                        style: ElevatedButton.styleFrom(
                                            primary: Color.fromRGBO(
                                                188, 115, 93, 0.6),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25))),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                wdt / 9, ht / 84.3, wdt / 9, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // setting up the visibility for the tasks

                                Visibility(
                                  visible: _isVisDiab, // hide the row
                                  maintainSize: false,
                                  maintainAnimation: false,
                                  maintainState: false,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(0, 0, 0, ht / 84.3),
                                    child: SizedBox(
                                      width: wdt / 2.74,
                                      height: ht / 5.62,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DiabetesScreen()));
                                        },
                                        child: Text("Diabetes Detection",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: wdt / 23)),
                                        style: ElevatedButton.styleFrom(
                                            primary:
                                                Color.fromRGBO(6, 94, 139, 0.6),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25))),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: WidgetPane(initialSelectedIndex: 0),
      //setting up the side drawer
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text('Profile'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            //adding a logout button
            ListTile(
              title: Text('Log Out'),
              onTap: () {
                // Handle drawer item tap
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()),
                    (Route<dynamic> route) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DummyPage extends StatelessWidget {
  final String label;

  DummyPage({required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(label),
      ),
      body: Center(
        child: Text('This is $label'),
      ),
    );
  }
}
