import 'package:Health_Guardian/ClinicalTrials/AllTrials.dart';
import 'package:Health_Guardian/ClinicalTrials/EnrolledTrials.dart';
import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ClinicalTrailsPage extends StatelessWidget {
  static String clinicalTrailId = "";
  static const route = '/clinicaltrailspage';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [Text("Enrolled Trials"), Text("All Trials")],
              indicatorSize: TabBarIndicatorSize.label,
            ),
          ),
          body: TabContent(),
        ),
      ),
    );
  }

  Future<void> makeHttpPostRequest(String userResponse) async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    final response = await http.post(
      Uri.parse(
          'https://midyear-castle-408217.uc.r.appspot.com/users/addSubscription'), // Replace with your API endpoint
      body: {
        'clinicalTrail': clinicalTrailId,
        'user': userId,
        'response': userResponse
      },
    );

    if (response.statusCode == 200) {
      print('HTTP POST request successful');
    } else {
      print('HTTP POST request failed with status: ${response.statusCode}');
    }
  }
}

class TabContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [EnrolledTrials(), AllTrials()],
    );
  }
}

void main() {
  runApp(ClinicalTrailsPage());
}
