import 'package:Health_Guardian/ResultPage.dart';
import 'package:Health_Guardian/task_page.dart';
import 'package:flutter/material.dart';
import 'package:Health_Guardian/main.dart';
import 'package:Health_Guardian/Calendar.dart';
import 'package:Health_Guardian/SleepQuestionnaire.dart';
import 'package:Health_Guardian/Analytics.dart';
import 'package:Health_Guardian/mainPageResults.dart';
import 'package:Health_Guardian/ClinicalTrailsPage.dart';

class WidgetPane extends StatefulWidget {
  final int initialSelectedIndex;

  const WidgetPane({Key? key, required this.initialSelectedIndex})
      : super(key: key);

  @override
  State<WidgetPane> createState() => _WidgetPaneState();
}

class _WidgetPaneState extends State<WidgetPane> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    TaskPage(),
    CalendarApp(),
    MyAppResults(),
    AnalyticsPage(),
    ClinicalTrailsPage()
  ];

  void initState() {
    super.initState();
    _selectedIndex = widget.initialSelectedIndex;
  }

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => _pages[index]));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: _onItemSelected,
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.black.withOpacity(.5),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(Icons.task_sharp),
            onPressed: () {
              _onItemSelected(0);
              // Navigator.push(context, MaterialPageRoute(builder: (context) => TaskPage()));
            },
          ),
          label: 'Task',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(Icons.calendar_month_outlined),
            onPressed: () {
              _onItemSelected(1);
            },
          ),
          label: 'Calendar',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(Icons.list_alt_outlined),
            onPressed: () {
              _onItemSelected(2);
              // Navigator.push(context, MaterialPageRoute(builder: (context) => ResultPage()));
            },
          ),
          label: 'Results',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(Icons.analytics),
            onPressed: () {
              _onItemSelected(3);
              // Navigator.push(context, MaterialPageRoute(builder: (context) => AnalyticsPage() ));
            },
          ),
          label: 'Analytics',
        ),
        BottomNavigationBarItem(
          icon: IconButton(
            icon: Icon(Icons.emergency_share),
            onPressed: () {
              _onItemSelected(4);
              // Navigator.push(context, MaterialPageRoute(builder: (context) => AnalyticsPage() ));
            },
          ),
          label: 'Clinical Trails',
        ),
      ],
    );
  }
}
