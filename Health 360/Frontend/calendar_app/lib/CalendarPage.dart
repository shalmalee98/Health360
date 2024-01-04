// Importing the required packages and the files

import 'package:Health_Guardian/widgetpane.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:Health_Guardian/Calendar.dart';

// Defining calendarpage class as stateful widget

class CalendarPage extends StatefulWidget {
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

//state of the widget CalendarPage
class _CalendarPageState extends State<CalendarPage> {
  DateTime daySelected = DateTime.now();
  DateTime dayHighlighted = DateTime.now();
  CalendarFormat format = CalendarFormat.month;

//build method to create the widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //This helps to built base layout of the application,inbuilt in flutter sdk
      //appBar property,AppBar ->widget
      appBar: AppBar(
        title: const Text('IBM Health Calendar'),
        centerTitle: true,
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
          child: Column(children: <Widget>[
        Container(
          child: Text(
              'Days on which tests were taken are marked by green on the calendar'),
          padding: EdgeInsets.fromLTRB(10, 20, 20, 20),
        ),
        Container(
          child: CalendarApp(),
        ),
        Container(
          child: Center(),
        ),
        /* Container(
            child: apiCall(),
          ),*/
      ])),
      bottomNavigationBar: WidgetPane(
        initialSelectedIndex: 2,
      ),
    );
  }
}
