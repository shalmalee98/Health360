import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  final String defaultTitle = "Test title";
  final String defaultDescription = "Test Description";
  static const route = '/detailsScreen';

  @override
  Widget build(BuildContext context) {
    final item =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String title = defaultTitle;
    String description = defaultDescription;
    String clinicalTrailId = "";
    String defaultVolunteerDetails = "";
    String volunteerDetails = defaultVolunteerDetails;
    if (item != null) {
      title = item['name'] ?? defaultTitle;
      description = item['description'] ?? defaultDescription;
      volunteerDetails = item['volunteerDetails'] ?? defaultVolunteerDetails;
      clinicalTrailId = item['_id'] ?? "";
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(title)),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/Background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 24.0,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                description,
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            SizedBox(height: 27.0),
            Center(
              child: Text(
                "Volunteer Benefits",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                volunteerDetails,
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 27.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      makeHttpPostRequest(context, clinicalTrailId, "yes");
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
                  ElevatedButton(
                    onPressed: () {
                      makeHttpPostRequest(context, clinicalTrailId, "no");
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
      BuildContext context, String clinicalTrailId, String userResponse) async {
    final prefs = await SharedPreferences.getInstance();
    if (clinicalTrailId == "") {
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
