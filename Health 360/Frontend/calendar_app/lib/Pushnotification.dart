import 'package:Health_Guardian/ClinicalTrailsPage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);
  static String clinicalTrailId = "";
  static const route = '/notification';

  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)!.settings.arguments;
    if (message is RemoteMessage && message.notification != null) {
      String body = message.notification!.body!;
      List<String> splitbody = body.split('#');
      if (splitbody.length > 1) {
        clinicalTrailId = splitbody[1];
      } else {
        clinicalTrailId = "";
      }
      print(clinicalTrailId);
    }

    if (clinicalTrailId.isEmpty) {
      // Navigate to ClinicalTrailsPage.route if clinicalTrailId is empty
      Navigator.pushNamed(context, ClinicalTrailsPage.route);
      // Return an empty container as a placeholder widget since we've navigated away
      return Container();
    }

    return NotificationScreenWidget(clinicalTrailId: clinicalTrailId);
  }
}

class NotificationScreenWidget extends StatelessWidget {
  final String clinicalTrailId;

  const NotificationScreenWidget({required this.clinicalTrailId, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Notification Test')),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/Background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10.0),
            Center(
              child: Text(
                'Notification Test',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 24.0,
                ),
              ),
            ),
            SizedBox(height: 20.0),
            if (clinicalTrailId.isNotEmpty)
              Center(
                child: Text(
                  clinicalTrailId,
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            SizedBox(height: 27.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    print('Yes button pressed');
                    makeHttpPostRequest(context, "yes");
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.check, color: Colors.white),
                        SizedBox(width: 8.0),
                        Text('Yes', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: () {
                    print('No button pressed');
                    makeHttpPostRequest(context, "no");
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.close, color: Colors.white),
                        SizedBox(width: 8.0),
                        Text('No', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showResultDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Success:"),
          content: Text(
            "You have subscribed to the trial successfully\n"
            "Thank you",
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }

  Future<void> makeHttpPostRequest(
      BuildContext context, String userResponse) async {
    final prefs = await SharedPreferences.getInstance();
    if (clinicalTrailId.isEmpty) {
      print('Clinical Trial Id not found');
      return;
    }
    String? userId = prefs.getString('userId');

    try {
      final response = await http.post(
        Uri.parse(
            'https://midyear-castle-408217.uc.r.appspot.com/users/addSubscription'),
        body: {
          'clinicalTrial': clinicalTrailId,
          'user': userId,
          'response': userResponse
        },
      );

      if (response.statusCode == 200) {
        _showResultDialog(context);
        print('HTTP POST request successful');
      } else {
        print('HTTP POST request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }
  }
}
