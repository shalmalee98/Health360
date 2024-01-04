import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:Health_Guardian/ClinicalTrailsPage.dart';
import 'package:Health_Guardian/ClinicalTrials/EnrolledTrials.dart';
import 'package:flutter/material.dart';
import 'package:Health_Guardian/ClinicalTrials/Questionnaires.dart';
import 'package:Health_Guardian/ClinicalTrials/VoiceQuestion.dart';
import 'package:Health_Guardian/ClinicalTrials/MultiChoiceQuestion.dart';
import 'package:Health_Guardian/ClinicalTrials/TextQuestion.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Health_Guardian/ClinicalTrials/MediaUpload.dart';
import 'package:permission_handler/permission_handler.dart';

class Questions extends StatefulWidget {
  @override
  QuestionsState createState() => QuestionsState();
  const Questions({Key? key}) : super(key: key);
  static const route = '/questions';
}

class QuestionsState extends State<Questions> {
  static const route = '/questions';

  bool flag = false;

  late List<List<String>> selectedChoices;

  void onMediaUploaded(int index, String mediaUrl) {
    setState(() {
      selectedChoices[index] = [mediaUrl];
    });
  }

  void onVoiceUploaded(int index, String mediaUrl) {
    setState(() {
      selectedChoices[index] = [mediaUrl];
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check and request microphone permission
    checkAndRequestMicrophonePermission();

    // Rest of your existing build method
    var array = ModalRoute.of(context)!.settings.arguments;
    final args = ModalRoute.of(context)!.settings.arguments as QuestionsData;
    final item = args.questions;
    if (flag == false) {
      selectedChoices = List.generate(item.length, (index) => []);
      flag = true;
    }

    final id = args.id;
    fetchData() async {
      final prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      final responseList = List.generate(item.length, (index) {
        return {
          "question": item[index]['question'],
          "questionType": item[index]['questionType'],
          "response": selectedChoices[index]
        };
      });

      void _showResultErrorDialog() {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            Future.delayed(Duration(seconds: 2), () {
              Navigator.pushNamed(context, ClinicalTrailsPage.route);
            });
            return const AlertDialog(
              title: Text("Success:"),
              content: Text(
                "Your Response added to the Database\n"
                "Thank you",
                textAlign: TextAlign.center,
              ),
            );
          },
        );
      }

      final response = await http.post(
        Uri.parse(
            'https://midyear-castle-408217.uc.r.appspot.com/responses/add'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
            {"questionnaire": id, "user": userId, "responses": responseList}),
      );

      if (response.statusCode == 200) {
        print("Response Added");
        _showResultErrorDialog();
      } else {
        print('HTTP POST request failed with status: 404');
      }
    }

    if (item.length > 0) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Questions"),
        ),
        body: ListView.builder(
          itemCount: item.length,
          itemBuilder: (context, index) {
            final question = item[index];
            Widget questionWidget;
            if (question['questionType'] == 'multiselect') {
              questionWidget =
                  MultiChoiceQuestion(question, selectedChoices, index);
            } else if (question['questionType'] == 'text') {
              questionWidget =
                  TextInputQuestion(question, selectedChoices, index);
            } else if (question['questionType'] == 'select') {
              questionWidget =
                  MultiChoiceQuestion(question, selectedChoices, index);
            } else if (question['questionType'] == 'voice') {
              questionWidget = VoiceQuestion(
                question: question['question'],
                questionImage: question['questionImage'] ?? "",
                index: index,
                onVoiceQuestioned: (mediaUrl) =>
                    onVoiceUploaded(index, mediaUrl!),
              );
            } else {
              questionWidget = MediaUpload(
                question: question['question'],
                questionImage: question['questionImage'] != null
                    ? question['questionImage']
                    : "",
                onMediaUploaded: (mediaUrl) =>
                    onMediaUploaded(index, mediaUrl!),
                index: index,
                selectedChoices: selectedChoices,
              );
            }

            return Column(
              children: [
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: questionWidget,
                  ),
                ),
                Divider(
                  color: Colors.black,
                  thickness: 1.0,
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: BottomAppBar(
          child: ElevatedButton(
            onPressed: () {
              print(selectedChoices);
              fetchData();
            },
            child: Text("Submit"),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Questions"),
      ),
      body: Center(child: Text("No Questions")),
    );
  }

  Future<void> checkAndRequestMicrophonePermission() async {
    var status = await Permission.microphone.status;

    if (!status.isGranted) {
      var result = await Permission.microphone.request();

      if (!result.isGranted) {
        print('Microphone permission denied');
      }
    }
  }
}

class Question {
  final int id;
  final String question;
  final String questionType;
  final List<Option> options;

  Question({
    required this.id,
    required this.question,
    required this.questionType,
    required this.options,
  });

  factory Question.fromJson(Map<Array, dynamic> json) {
    List<Option> options = (json['questionOptions'] as List).map((option) {
      return Option.fromJson(option);
    }).toList();

    return Question(
      id: json['_id'],
      question: json['question'],
      questionType: json['questionType'],
      options: options,
    );
  }
}

class Option {
  final int id;
  final String name;
  final String image;

  Option({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Option.fromJson(Map<Object, dynamic> json) {
    return Option(id: json['_id'], name: json['name'], image: json['image']);
  }
}

class QuestionTile extends StatelessWidget {
  final Question question;

  QuestionTile({required this.question});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(question.question),
            subtitle: Text(question.questionType),
          ),
          OptionsList(options: question.options),
        ],
      ),
    );
  }
}

class OptionsList extends StatelessWidget {
  final List<Option> options;

  OptionsList({required this.options});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.map((option) {
        return Container(
          color: Color(0x99AB937F),
          child: ListTile(
            title: Text(option.name),
          ),
        );
      }).toList(),
    );
  }
}
