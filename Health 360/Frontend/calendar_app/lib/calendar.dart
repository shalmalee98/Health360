// Importing the required packages and the files

import 'dart:convert';
import 'package:Health_Guardian/environment.dart';
import 'package:Health_Guardian/task_page.dart';
import 'package:intl/intl.dart';
import 'package:Health_Guardian/main.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:Health_Guardian/widgetpane.dart';
import 'Constants/urlConstant.dart';
import 'calendar_list.dart';
import 'package:http/http.dart' as http;

import 'loginpage.dart';



void main() {
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: CalendarApp()));
}

//The CalendarApp class is the main widget that extends StatefulWidget

class CalendarApp extends StatefulWidget {
  const CalendarApp({super.key});

  @override
  State<CalendarApp> createState() => _CalendarAppState();
}

class _CalendarAppState extends State<CalendarApp> {

  //_isLoading that is set to true by default indicating that the app is in the loading state until the getDates() method is called to fetch the dates from API
  bool _isloading = true;
  //The _CalendarAppState class also contains a list of DateTime object dateList
  List<DateTime>? dateList;
  @override

  //The initState() method is called once when the widget is first created it calls the getDates() function
  void initState() {
    super.initState();
    getDates();
    print("function call");

    //print(apiList);
  }

  CalendarFormat format = CalendarFormat.month;

  DateTime today = DateTime.now();

  final titleController = TextEditingController();
  final descpController = TextEditingController();

  // This function is called when a day is selected on the calendar

  void _onDaySelected(DateTime day, DateTime focusedDay) {
    // update the state with the selected day
    setState(() {
      today = day;
    });
  }

  // The build() method returns a Scaffold widget that contains the UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isloading
          ?  Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  // Set the background image
                  image: AssetImage("images/Background.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : content(),

      bottomNavigationBar: WidgetPane(initialSelectedIndex:1),
    );
  }

  // The content of the widget that will be displayed on the screen

  Widget content() {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            // Add the container with a background image
            image: AssetImage("images/Background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [

            Padding(padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/22.05,  MediaQuery.of(context).size.height/14.05,  MediaQuery.of(context).size.width/22.05, 0)),

            // Add a column of widgets to the container

            Row(
              children: [
                IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TaskPage()))),
                Padding(padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/41.1,  MediaQuery.of(context).size.height/28.1,  MediaQuery.of(context).size.width/41.1,  MediaQuery.of(context).size.height/20)),
                Text(
                  "Health 360",// The text to display
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize:  MediaQuery.of(context).size.width/22.05),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/14.7, 0, MediaQuery.of(context).size.width/14.7,MediaQuery.of(context).size.height/56.2)),
            Text("Selected Date: " + today.toString().split(" ")[0], style:TextStyle(fontWeight: FontWeight.bold, fontSize:  MediaQuery.of(context).size.width/27),),
            Padding(padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width/14.7, 0, MediaQuery.of(context).size.width/14.7,MediaQuery.of(context).size.height/56.2)),

            Expanded(
              child: SingleChildScrollView(

                // Add a single child scroll view widget to the expanded widget
                child: Container(

                  child: TableCalendar(
                    // Add a table calendar widget to the container
                    headerStyle: HeaderStyle(
                      // The style of the table calendar header
                      formatButtonVisible: true,
                      // Keep the title to centre
                      titleCentered: true,
                      formatButtonShowsNext: false,
                      formatButtonDecoration: BoxDecoration(
                        color: Color.fromRGBO(65, 171, 101, 0.6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    availableGestures: AvailableGestures.all,
                    selectedDayPredicate: (day) => isSameDay(day, today),
                    focusedDay: today,
                    firstDay: DateTime(1990),
                    lastDay: DateTime(2050),
                    onDaySelected: _onDaySelected,
                    onFormatChanged: (CalendarFormat _format) {
                      setState(() {
                        format = _format;
                      });
                    },
                    calendarFormat: format,
                    startingDayOfWeek: StartingDayOfWeek.sunday, //Set the start of the week for calendar display
                    calendarStyle: const CalendarStyle(
                      markersAlignment: Alignment.bottomCenter,
                    ),
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, day, events) {
                        //if (dateList != null) {
                        for (DateTime uDate in dateList!) {
                          if (day.toString().split(" ")[0] ==
                              uDate.toString().split(" ")[0]) {
                            return Container(
                              width: MediaQuery.of(context).size.width/36.75,
                              height: MediaQuery.of(context).size.height/70.25,
                              margin: const EdgeInsets.all(4.0),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(65, 171, 101, 1),
                                  borderRadius: BorderRadius.circular(5.0)),
                              child: Text(
                                '',
                                style: const TextStyle(
                                    color: Color.fromRGBO(65, 171, 101, 1)),
                              ),
                            );
                          }
                        }
                        // } else {}
                        return null;
                      },
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom:  MediaQuery.of(context).size.height/22),
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyApp(today.toString().split(" ")[0])));
                },
                label: Text('Show Tasks'), // Text to display
                backgroundColor: Colors.yellow[800],
              ),
            ),
          ],


        ));
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
  Future<void> getDates() async {

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
      print(Data.length);
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

      dateList = dates.toSet().toList();
    } else {
      print("Something went wrong");
    }
    if (dateList != null){
      setState(() {
        _isloading = false;
      });
    }else{setState(() {
      _isloading = true;
    });}
  }
}
