// Importing the required packages and the files

import 'package:Health_Guardian/environment.dart';
import 'package:Health_Guardian/task_page.dart';
import 'package:Health_Guardian/widgetpane.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:Health_Guardian/ResultPage.dart';
import 'Constants/urlConstant.dart';
import 'GetSampleApi.dart';
import 'loginpage.dart';

Map taskName ={"PHQ-8": "Patient Health Questionnaire",
  "sleep_questionnaire": "Sleep Questionnaire",
  "GAD-7": "General Anxiety Disorder",
  "AUDIT": "Alcohol Use Disorder",
  "parkinsons": "Parkinsons Disease",
  "alzheimer": "Alzheimers Disease",
  "diabetes": "Diabetes",

};

Map taskColor ={"PHQ-8": Color.fromRGBO(244, 172, 69, 0.6),
  "sleep_questionnaire": Color.fromRGBO(171, 147, 127, 0.6),
  "GAD-7": Color.fromRGBO(85,107,47, 0.6),
  "AUDIT": Color.fromRGBO(188, 115, 93,0.6),
  "parkinsons": Color.fromRGBO(65, 171, 101, 0.6),
  "alzheimer": Color.fromRGBO(63, 94, 139, 0.6),
  "diabetes": Color.fromRGBO(6, 94, 139,0.6),
};

String phqRequestPath = 'Json/phqRequestDynamicCalendar.json';
String sqRequestPath = 'Json/sqRequestDynamicCalendar.json';
Map cal_data = {};

//// Maintaining this color pallete throughout the application
final List<Color> cardColors = [
  Color.fromRGBO(65, 171, 101, 0.6),
  Color.fromRGBO(63, 94, 139, 0.6),
  Color.fromRGBO(244, 172, 69, 0.6),
  Color.fromRGBO(171, 147, 127, 0.6),
];
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
//class MyAppResults is a stateless widget that initializes the app
class MyAppResults extends StatelessWidget {
  //var date;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     // navigatorKey: navigatorKey,
      title: 'Results!',
      theme: ThemeData(primarySwatch: primaryBlack),
      home: MyResultPage(),
    );
  }
}

//class MyResultPage is a stateful widget that builds the UI

class MyResultPage extends StatefulWidget {
  @override
  State<MyResultPage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyResultPage> {
  bool _isloading = false;
  bool isParkinson=false;
  List<GetSampleApi>? apiList;

//In the initState() method  the API data is fetched using the getApiData() function at the beginning of the page load
  @override
  void initState() {
    super.initState();
    getApiData();
    getDates();
  }

  // Setting the dropdown value as task in the two dropdown options date and task
  String _selectedOption = "Task";
  bool test = false;
  String taskappend = "";

  @override
  Widget build(BuildContext context) {
    // Scaffold is a widget that provides a basic structure for material design app

    return Scaffold(
      body: _isloading
      // If _isloading is true, show a loading indicator
          ? Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/Background.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )

      // Otherwise, show the main content

          : SafeArea(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/Background.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    Padding(padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/22.05,  MediaQuery.of(context).size.height/84.3,  MediaQuery.of(context).size.width/22.05, 0)),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TaskPage())),
                        ),
                        Padding(padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/41.1,  MediaQuery.of(context).size.height/28.1,  MediaQuery.of(context).size.width/41.1,  MediaQuery.of(context).size.height/56.2)),
                        Text(
                          "Health 360",  // Text to display
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width/22.05),
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.fromLTRB(18, MediaQuery.of(context).size.height/28.1, 0, 10)),
                    Row(
                      children: [
                        Padding(
                          padding:  EdgeInsets.only(),
                          child: Text(
                            "Sort By ", // Text to display
                            textAlign: TextAlign.right,
                            style: TextStyle( fontWeight: FontWeight.bold, fontSize: MediaQuery.of(context).size.width/18),
                          ),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width/41.1),
                        DropdownButton<String>(
                          value: _selectedOption,
                          items: [

                            // DropdownMenuItem for sorting by Date

                            DropdownMenuItem(
                              child: Text('Date'),
                              value: 'Date',
                            ),
                            DropdownMenuItem(

                              // DropdownMenuItem for sorting by Task

                              child: Text('Task'),
                              value: 'Task',                          ),
                          ],
                          onChanged: (value) {
                            Future.delayed(Duration.zero,(){
                              setState(() {
                                _selectedOption = value!;
                               // print(value);
                                if(value == "Date") {
                                  test = true;

                                }
                                else {
                                  test = false;

                                  // handle selected option change here
                                }
                              });
                            });
                          },
                        ),
                      ],
                    ),

                    // If apiList is not empty, show the list of items
                    apiList != null && apiList!.isNotEmpty ? getList() : Container(),

                  ],
                ),
              ),
            ),

      // Widget for a bottom navigation bar

      bottomNavigationBar: WidgetPane(initialSelectedIndex: 2),
    );
  }


// Get the list using the api call
  Widget getList() {
    return Expanded(
      child: GroupedListView<dynamic, String>(
        //key: ValueKey(apiList!.length),
        elements: apiList!, // list of elements to display
        groupBy: (dynamic element) => test ? "${element.date_created.split(' ')[0]} - ${element.hid.toString().toUpperCase().replaceAll(RegExp(r'[^\w\s-]+'), '').replaceAll('_', ' ')}":"${element.hid.toString().toUpperCase().replaceAll(RegExp(r'[^\w\s-]+'), '').replaceAll('_', ' ').replaceAll('-', '')}",
        groupSeparatorBuilder: (String groupByValue) => test?Padding(
          padding: const EdgeInsets.all(1.0),

        ):Padding(
      padding: const EdgeInsets.all(4.0),
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
                _isloading = true; // set loading state to true
              });
              print("ELEMENT HID");
              print("${element.hid}");
              print("${element.task_hid}");
              taskappend = test ? "${element.date_created}" : "${element.hid}";
              //print("This is task append"+ taskappend);
              if ("${element.hid}" == "PHQ-8" || "${element.hid}" == "sleep_questionnaire"||"${element.hid}" == "AUDIT"||"${element.hid}" == "GAD-7") { // if element is PHQ-8
                cal_data["score"]=double.parse(element.task_score);
                cal_data["classification"]=element.classification;

             // print(isParkinson);
              //   String dataendpoint =
              //       "https://hg-production-taskmanager-ssc.ortmd733nb9.us-east.codeengine.appdomain.cloud/api/v1/datasets/" +
              //           element.task_uid!;
              //   Map data = {"data_endpoint": dataendpoint};
              //   makePostCalendarCall(setEnvironment.apiBaseUrlPHQ,
              //       phq_unencoded_post, jsonEncode(data));
              //   Future.delayed(Duration(seconds: 10), () {
              //     //makeGetApiCallPHQCalendar(setEnvironment.apiBaseUrlPHQ, id);
              //    // print("ID " + id.toString());
              //   });
              // } else if ("${element.hid}" == "sleep_questionnaire_task") {
              //   // String dataendpoint =
              //   //     "https://hg-production-taskmanager-ssc.ortmd733nb9.us-east.codeengine.appdomain.cloud/api/v1/datasets/" +
              //   //         element.task_uid!;
              //   // Map data = {"data_endpoint": dataendpoint};
              //   // makePostCalendarCall(setEnvironment.apiBaseUrlSleepQ,
              //   //     sleepq_unencoded_post, jsonEncode(data));
              //   Future.delayed(Duration(seconds: 10), () {
              //     // makeGetApiCallSleepQCalendar(
              //     //     setEnvironment.apiBaseUrlSleepQ, id);
              //     makeGetApiCallSleepQCalendar(
              //         setEnvironment.apiBaseUrlSleepQ,  element.task_hid!);
              //   });
               } else if("${element.hid}" == "parkinsons") {
                cal_data["parkinsonAudioApiUrl"] = "https://app-xftewtdwlq-uc.a.run.app/get_audio/file/${element.task_hid}.wav";
                cal_data["score"] =element.task_score;
                cal_data["classification"]=element.classification;

              }else if("${element.hid}" == "diabetes")
              {
                cal_data["score"]=double.parse(element.task_score);
                cal_data["classification"]=element.classification;
              }
              else if("${element.hid}" == "alzheimer" )
              {
                cal_data["score"]=double.parse(element.task_score);
                cal_data["classification"]=element.classification;
              }
              Future.delayed(Duration(seconds: 1), () {
                print("CAL DATA" + cal_data.toString());
                print("HID:" + "${element.hid}");
                if (cal_data.isEmpty) {
                  setState(() {
                    _isloading = false;
                  });// if data is empty, show error dialog
                  _showResultErrorDialog();
                } else {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                      builder: (context) => ResultPage(cal_data, "${element.hid}"),
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
                      color:taskColor[element.hid],
                    ),
                    child: SafeArea(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                            children: [
                              SizedBox(height: 5),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 5, 0, 15),
                                  child: RichText(
                                    text: TextSpan(
                                      children:[
                                      TextSpan(
                                        text: "${taskName[element.hid]}" + "\nTest taken on : ${element.date_created}  ",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                        TextSpan(
                                          text: "\nTime stamp : ${element.time_created.replaceAll('-', '')}  \nScore: ",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),

                                        TextSpan(
                                          text: "${element.task_score}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                        ),
                          ),
                          if(isParkinson)
                              IconButton(
                            icon: Icon(Icons.play_arrow),
                            onPressed: () {
                              // Implement play button functionality
                            },
                          )
                              ],

                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        order: GroupedListOrder.DESC, // Sort the list by ascending order
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
    'Bearer '+bearerToken
  };

  // Function to get the dates from API which has tasks
  void getDates() async {

    // Make GET request to API with headers
    http.Response response = await http.get(
      Uri.parse(setEnvironment.calendarUrl+"/${user}"),
      headers: headers,
    );
    // If response is successful, parse and process data
    if (response.statusCode == 200) {
      print("Success");
      final Data = jsonDecode(response.body);
      print("=======================");
      print(Data);
      final List<DateTime> dates = [];

      // Loop through list of tasks and add tasks with created date matching current date to a new list
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

  // Function to retrieve all previous tasks and tests taken by the user from an API

  Future<void> getApiData() async {
    // Set headers for API request
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'User-Agent': 'PostmanRuntime/7.31.1',
      'Accept': '*/*',
      'Accept-Encoding': 'gzip, deflate, br',
      'Connection': 'keep-alive',
    };

    // Make GET request to API with headers

    var response = await http.get(
      Uri.parse(setEnvironment.calendarUrl+"/${user}"),
      headers: headers,
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    // If response is successful, parse and process data

    if (response.statusCode == 200) {
      print("Success");
      final Data = jsonDecode(response.body);

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
        currentDatetasks.add(item);
      }
      taskjson = jsonEncode(currentDatetasks);
      List<String> listitems = [];
      for (var item in task_names) {
        listitems.add(item['hid']);
        print(item['hid']);
        print(item['uid']);
        // var itemHid=item['hid'];
        // var itemUid=item['uid'];
      }
// Convert currentDatetasks list to JSON and then to a list of GetSampleApi objects
      apiList = jsonDecode(taskjson)
          .map((item) => GetSampleApi.fromJson(item))
          .toList()
          .cast<GetSampleApi>();

      setState(() {});
      // Update state to trigger UI rebuild

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
