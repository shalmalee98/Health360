// Importing the required packages and the files

import 'package:Health_Guardian/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:developer';
import 'package:Health_Guardian/ResultPage.dart';
import 'Calendar.dart';
import 'Constants/urlConstant.dart';
import 'GetSampleApi.dart';
import 'PHQ8Questinairre.dart';
import 'SleepQuestionnaire.dart';
import 'apiCall.dart';
import 'loginpage.dart';
//import 'package:lib/GetSampleApi.dart';

String phqRequestPath = 'Json/phqRequestDynamicCalendar.json';
String sqRequestPath = 'Json/sqRequestDynamicCalendar.json';

//final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Maintaining this color pallete throughout the application

Map taskColor = {
  "PHQ-8": Color.fromRGBO(244, 172, 69, 0.6),
  "sleep_questionnaire": Color.fromRGBO(171, 147, 127, 0.6),
  "GAD-7": Color.fromRGBO(85, 107, 47, 0.6),
  "AUDIT": Color.fromRGBO(188, 115, 93, 0.6),
  "parkinsons": Color.fromRGBO(65, 171, 101, 0.6),
  "alzheimer": Color.fromRGBO(63, 94, 139, 0.6),
  "diabetes": Color.fromRGBO(6, 94, 139, 0.6),
};

const MaterialColor primaryBlack = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    50: Color(0xFF000000),
    100: Color(0xFF000000),
    200: Color(0xFF000000),
    300: Color(0xFF000000),
    400: Color(0xFF000000),
    500: Color(_blackPrimaryValue),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);

const int _blackPrimaryValue = 0xFF000000;

// Defining two classes, MyApp and MyHomePage

class MyApp extends StatelessWidget {
  // MyApp is a StatelessWidget that creates a MaterialApp widget, which is the root widget of the app

  MyApp(this.date);
  final String date;

  @override
  Widget build(BuildContext context) {
    // MaterialApp widget defines the title of the app and its theme, and it also specifies the home screen of the app which is MyHomePage StatefulWidget
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // navigatorKey: navigatorKey,
      title: 'Calendar data!',
      theme: ThemeData(primarySwatch: primaryBlack),
      home: MyHomePage(date),
    );
  }
}

//MyHomePage is a StatefulWidget that displays the results of a health questionnaire for a particular date

class MyHomePage extends StatefulWidget {
  MyHomePage(this.date);
  final String date;
  //const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState(date);
}

//  MyHomePageState has a state that keeps track of whether the data is loading or not, the date for which the results are being shown, and a list of health questionnaire results (GetSampleApi objects)

class _MyHomePageState extends State<MyHomePage> {
  bool _isloading = false;
  bool isParkinson = false;
  _MyHomePageState(this.date);

  final String date;

  List<GetSampleApi>? apiList;

  //The initState() method is called when the widget is first created, and it sets the state variables and retrieves the data for the given date

  @override
  void initState() {
    super.initState();
    getApiData(date);
    getDates();
    print("function call");

    //print(apiList);
  }

  // The build() method of MyHomePage returns a Scaffold widget that contains a SafeArea widget

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The body of the Scaffold widget is either a Container widget with a CircularProgressIndicator
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
          : SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/Background.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width / 41.1,
                          MediaQuery.of(context).size.height / 28.1,
                          MediaQuery.of(context).size.width / 41.1,
                          0),
                    ),
                    Row(
                      children: [
                        IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CalendarApp(),
                                ))),
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
                              fontSize:
                                  MediaQuery.of(context).size.width / 22.05),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 30, 0, 0),
                      child: Row(
                        children: [
                          Icon(Icons.list_alt_outlined, color: Colors.black),
                          SizedBox(width: 10),
                          Text("Results for " + date,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 23)),
                        ],
                      ),
                    ),
                    if (apiList != null) getList()
                  ],
                ),
              ),
            ),

      // The SafeArea widget ensures that the content is displayed in a safe area of the screen and is not obscured by notches or any other things
    );
  }

  // The list of results is created using the GroupedListView widget, which groups the results by their type and displays them, we are making a call to the API to fetch the results

  Widget getList() {
    return Expanded(
      child: GroupedListView<dynamic, String>(
        elements: apiList!,
        groupBy: (dynamic element) => element.hid
            .toString()
            .toUpperCase()
            .replaceAll(RegExp(r'[^\w\s-]+'), '')
            .replaceAll('_', ' '),
        groupSeparatorBuilder: (String groupByValue) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            groupByValue,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        itemBuilder: (BuildContext tcontext, dynamic element) {
          isParkinson = "${element.hid}" == "parkinsons";
          return GestureDetector(
            onTap: () async {
              setState(() {
                _isloading = true;
              });
              // print("${element.task_hid}");
              if ("${element.hid}" == "PHQ-8" ||
                  "${element.hid}" == "sleep_questionnaire" ||
                  "${element.hid}" == "AUDIT" ||
                  "${element.hid}" == "GAD-7") {
                // if element is PHQ-8
                cal_data["score"] = double.parse(element.task_score);
                cal_data["classification"] = element.classification;
              } else if ("${element.hid}" == "parkinsons") {
                cal_data["parkinsonAudioApiUrl"] =
                    "https://app-xftewtdwlq-uc.a.run.app/get_audio/file/${element.task_hid}.wav";
                cal_data["score"] = element.task_score;
                cal_data["classification"] = element.classification;
              } else if ("${element.hid}" == "diabetes") {
                cal_data["score"] = double.parse(element.task_score);
                cal_data["classification"] = element.classification;
              } else if ("${element.hid}" == "alzheimer") {
                cal_data["score"] = double.parse(element.task_score);
                cal_data["classification"] = element.classification;
              }
              Future.delayed(Duration(seconds: 5), () {
                print("CAL DATA" + cal_data.toString());
                print("HID:" + "${element.hid}");
                if (cal_data.isEmpty == true) {
                  setState(() {
                    _isloading = false;
                  });
                  _showResultErrorDialog();
                } else {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          ResultPage(cal_data, "${element.hid}"),
                    ),
                  );
                }
                setState(() {
                  _isloading = false;
                });
              });
            },
            child: SafeArea(
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: SafeArea(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: taskColor[element.hid],
                    ),
                    child: SafeArea(
                      child: Column(
                        children: [
                          SizedBox(height: 5),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(5, 0, 0, 10),
                              child: SafeArea(
                                child: Row(children: [
                                  Text(
                                    "${element.hid} - " +
                                        "Test taken at: ${element.time_created.replaceAll('-', '')}",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          7.2),
                                  if (isParkinson)
                                    IconButton(
                                      icon: Icon(Icons.play_arrow),
                                      onPressed: () {
                                        // Implement play button functionality
                                      },
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
            ),
          );
        },
        order: GroupedListOrder.ASC,
      ),
    );
  }

  // Set headers for API request
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'User-Agent': 'PostmanRuntime/7.31.1',
    'Accept': '*/*',
    'Accept-Encoding': 'gzip, deflate, br',
    'Connection': 'keep-alive',
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjg2NTkzNjE2LCJpYXQiOjE2Nzg4MTc2MTYsImp0aSI6ImI5YzM1MDNjMTk1YTQ0NmU5MjVmNWU3N2JiMWZlZWNlIiwidXNlcl9pZCI6MTEyfQ.r6dMDcY9HkB7zUrCo3m2u3-Bou72kPWiXEVGjbkJoDE'
  };

  // Function to get the dates from API which has tasks

  void getDates() async {
    // Make GET request to API with headers
    http.Response response = await http.get(
      Uri.parse(setEnvironment.calendarUrl + "/${user}"),
      headers: headers,
    );
// If response is successful process data
    if (response.statusCode == 200) {
      print("Success");
      final Data = jsonDecode(response.body);
      print("=======================");
      //print(Data);
      final List<DateTime> dates = [];
      for (var i = 0; i < Data.length; i++) {
        String strCreatedDate = Data[i]['created'];
        DateFormat format = DateFormat("yyyy-MM-dd");
        DateTime myDate = format.parse(strCreatedDate);
        //DateTime myDate = DateTime.parse(strCreatedDate);

        dates.add(myDate);

        print(myDate);
      }
    } else {
      print("Something went wrong");
    }
  }

  Future<void> getApiData(String currentDate) async {
    // Set headers for API request
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'User-Agent': 'PostmanRuntime/7.31.1',
      'Accept': '*/*',
      'Accept-Encoding': 'gzip, deflate, br',
      'Connection': 'keep-alive',
      'Authorization': 'Bearer ' + bearerToken
    };
    // Make GET request to API with headers
    var response = await http.get(
      Uri.parse(setEnvironment.calendarUrl + "/${user}"),
      headers: headers,
    );
    //http.Response response = await http.post(url);
    //print(response);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    // If response is successful, parse and process data
    if (response.statusCode == 200) {
      print("Success");
      // Parse JSON data from response
      final Data = jsonDecode(response.body);

      //Map<String, dynamic> task_Data = Data[0]['task_snapshot'];

      // Static date
      DateTime currentdate = DateTime.parse(currentDate);

      List<dynamic> task_names = Data;
      var taskjson = jsonEncode(task_names);
      print(task_names.length);
      int total_tasks = task_names.length;

      List<dynamic> currentDatetasks = [];
      // Loop through list of tasks and add tasks with created date matching current date to a new list
      for (var item in task_names) {
        var date = item['created'];
        DateFormat format = DateFormat("yyyy-MM-dd");
        DateTime dateTime2 = format.parse(date);
        if (dateTime2 == currentdate) {
          print(dateTime2);
          //print("Equal");
          currentDatetasks.add(item);
        }
      }
      taskjson = jsonEncode(currentDatetasks);
      List<String> listitems = [];
      for (var item in task_names) {
        listitems.add(item['hid']);
        //print(item['hid']);
        //print(item['uid']);
        // var itemHid=item['hid'];
        // var itemUid=item['uid'];
      }
      // Convert currentDatetasks list to JSON and then to a list of GetSampleApi objects
      apiList = jsonDecode(taskjson)
          .map((item) => GetSampleApi.fromJson(item))
          .toList()
          .cast<GetSampleApi>();
      // Update state to trigger UI rebuild
      setState(() {});
    } else {
      print("Something went wrong");
    }
  }

  // Error dialog box with a title and a message to display error when there is an error retrieving data

  void _showResultErrorDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // Build the error dialog content
          return const AlertDialog(
            // The title of the dialog box
            title: Text("Error:"),
            content: Text(
              // The message to be displayed in the dialog box
              "There was an error retrieving the data.\n"
              "Click outside the box to return.",
              textAlign: TextAlign.center,
            ),
          );
        });
  }
}
