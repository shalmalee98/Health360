import 'package:flutter/material.dart';

import 'package:Health_Guardian/apiCall.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'environment.dart';
import 'Constants/urlConstant.dart';
import 'task_page.dart';

import 'loginpage.dart';

class AlzheimerDetectionScreen extends StatefulWidget {
  @override
  _AlzheimerDetectionScreenState createState() => _AlzheimerDetectionScreenState();
}

class _AlzheimerDetectionScreenState extends State<AlzheimerDetectionScreen> {
  TextEditingController textEditingController = TextEditingController();
  // bool isLoading = false;
  bool modelLoaded = false;
  bool _isloading = false;

  @override

  void _showResultDialog(String result) {
    setState(() {
      _isloading = false;
    });
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return AlertDialog(
    //       title: Text('Classification Result'),
    //       content: Text(result),
    //       actions: [
    //         TextButton(
    //           onPressed: () {
    //             //Navigator.pop(context); // Close the dialog
    //             //context,
    //             MaterialPageRoute(builder: (context) => TaskPage());
    //           },
    //           child: Text('Go To Tasks'),
    //         ),
    //       ],
    //     );
    //   },
    // );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Classification Result'),
          content: Text(result),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TaskPage()),
                );
              },
              child: Text('Go To Tasks'),
            ),
          ],
        );
      },
    );

  }

  void _submitText() async {

    print("In _submitText Function");


    // final apiUrl = "http://10.0.2.2:3000/alzh_d/score_calculate_alz";
    final userSubmittedText = textEditingController.text;
    print("User submitted text In SubmitText Function: $userSubmittedText");

    if (userSubmittedText == null || userSubmittedText.isEmpty) {
      // Show a dialog when userSubmittedText is null or empty
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Missing Description'),
            content: Text('Please describe the image.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else
    {
        setState(() {
          _isloading = true;
        });
        try {
          final response = await http.post(
            Uri.parse("${setEnvironment.apiBaseUrlAlzh}/${alzh_unencoded_post}"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "user": user,
              "text": userSubmittedText}),
          );


          if (response.statusCode == 200) {
            String data = jsonDecode(response.body)['id'];
            print("200 StatusCode");
            String getUrl = "${setEnvironment.apiBaseUrlAlzh}/$data";


            final getResponse = await http.get(Uri.parse(getUrl));
            final getRequestBody = json.decode(getResponse.body);

            print(getRequestBody['data']['score']);
            if (getRequestBody['data']['score'] == 1) {
              final String result = "Possible Alzheimer's detected. Please consult your doctor.";
              _showResultDialog(result);
            }
            else {
              final String result = "No signs of Alzheimer's detected. Stay healthy!";
              _showResultDialog(result);
            }

            print(response.body);
            print(response.body.runtimeType);

            print("Response Data: $data"); // Print the entire response data
            // final result = data['result'] as String;

          } else {
            final result = "Some error has occured";
            _showResultDialog(result);
          }
        } catch (e) {
          print("Error occurred: $e");
          final result = "An error occurred during the HTTP request.";
          _showResultDialog(result);
        }

        setState(() {
          _isloading = false;
        });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          // : Container(
      :SingleChildScrollView(
      // appBar: AppBar(
      //   title: Text('Alzheimer\'s Detection'),
      // ),
      // body: SingleChildScrollView(
      //   width: MediaQuery.of(context).size.width,
      //   height: MediaQuery.of(context).size.height,
      //   decoration: BoxDecoration(
      //     image: DecorationImage(
      //         image: AssetImage("images/Background.jpg"),
      //         fit: BoxFit.fill),
      //   ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'What do you see in the image?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 3),
              ),
            ),
            Image.asset(
              'images/cookie_theft_image.ppm', // Replace this with the actual image path
              height: 220,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Describe what you see...',
                ),
                maxLines: 4,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                String userSubmittedText = textEditingController.text;
                print("User submitted text: $userSubmittedText");
                _submitText();

              },
              child: Text('Submit'),
            ),
            // if (isLoading)
            //   CircularProgressIndicator(), // Show the loader when isLoading is true
          ],
        ),
      ),
      // ),
    );
  }
}
