import 'package:Health_Guardian/environment.dart';
import 'package:Health_Guardian/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:Health_Guardian/apiCall.dart';
import 'package:flutter/services.dart';
import 'Constants/urlConstant.dart';
import 'dart:convert';
import 'task_page.dart';

String phqRequestPath = 'Json/phqRequest.json';

String jsonString = '''
{
  "user": "${user}"
}
''';

class AUDITScreen extends StatefulWidget {
  @override
  State<AUDITScreen> createState() => _AUDITScreenState();
}

class Question {
  final String questionText;
  final List<Answer> answersList;

  Question(this.questionText, this.answersList);
}

class Answer {
  final String answerText;
  Answer(this.answerText);
}

List<String> selectedOptionsPHQ = [];

List<Question> getQuestions() {
  List<Question> list = [];
  //ADD questions and answer here

  list.add(Question(
    "How often do you have a drink containing alcohol?",
    [
      Answer("1. Never"),
      Answer("2. Monthly or less"),
      Answer("3. 2-4 times a month"),
      Answer("4. 2-3 times a week"),
      Answer("5. 4 or more times a week"),
    ],
  ));

  list.add(Question(
    "How many drinks containing alcohol do you have on a typical day when you are drinking?",
    [
      Answer("1. 1 or 2"),
      Answer("2. 3 or 4"),
      Answer("3. 5 or 6"),
      Answer("4. 7 or 9"),
      Answer("5. 10 or more"),
    ],
  ));

  list.add(Question(
    "How often do you have six or more drinks on one occasion?",
    [
      Answer("1. Never"),
      Answer("2. Less than monthly"),
      Answer("3. Monthly"),
      Answer("4. Weekly"),
      Answer("5. Daily or almost daily"),
    ],
  ));

  return list;
}

class _AUDITScreenState extends State<AUDITScreen> {
  bool _isloading = false;
  //define the datas
  List<Question> questionList = getQuestions();
  int currentQuestionIndex = 0;
  int score = 0;
  Answer? selectedAnswer;
  List<String> ans = [];

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
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/Background.jpg"),
                    fit: BoxFit.fill),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                        padding: EdgeInsets.all(
                      MediaQuery.of(context).size.height / 84.3,
                    )),
                    Text(
                      "Alcohol Use Disorders Identification Test",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width / 18.4,
                      ),
                    ),
                    _questionWidget(),
                    _answerList(),
                    _nextButton(),
                  ]),
            ),
    );
  }

  _questionWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Question ${currentQuestionIndex + 1}/${questionList.length.toString()}",
          style: TextStyle(
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.width / 20.55,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height / 42.3),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width * 0.93,
          padding: EdgeInsets.all(MediaQuery.of(context).size.height / 26),
          decoration: BoxDecoration(
            color: Color.fromRGBO(55, 169, 100, 1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            questionList[currentQuestionIndex].questionText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    );
  }

  _answerList() {
    return Column(
      children: questionList[currentQuestionIndex]
          .answersList
          .map(
            (e) => _answerButton(e),
          )
          .toList(),
    );
  }

  Widget _answerButton(Answer answer) {
    bool isSelected = answer == selectedAnswer;

    return Container(
      width: MediaQuery.of(context).size.width * 0.93,
      margin: const EdgeInsets.symmetric(vertical: 8),
      height: MediaQuery.of(context).size.height / 17.8,
      child: ElevatedButton(
        child: Text(answer.answerText),
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          primary: isSelected
              ? Color.fromRGBO(63, 94, 139, .85)
              : Color.fromRGBO(142, 164, 210, .90),
          onPrimary: isSelected ? Colors.white : Colors.black,
        ),
        onPressed: () {
          ans.add(answer.answerText);
          setState(() {
            selectedAnswer = answer;
          });
        },
      ),
    );
  }

  _nextButton() {
    bool isLastQuestion = false;
    if (currentQuestionIndex == questionList.length - 1) {
      isLastQuestion = true;
    }

    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height / 17.8,
      child: ElevatedButton(
        child: Text(isLastQuestion ? "Submit" : "Next"),
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          primary: Colors.blueAccent,
          onPrimary: Colors.white,
        ),
        onPressed: () async {
          if (selectedAnswer == null) {
            showDialog(
                context: context, builder: (_) => _showSelectAnOptionDialog());
          } else {
            if (isLastQuestion) {
              setState(() {
                _isloading = true;
              });

              //Dynamically allocating each selected answer as key value pair in jsonbody

              Map<String, dynamic> jsonData = json.decode(jsonString);
              for (int i = 0; i < ans.length; i++) {
                String key = 'question${i + 1}';
                String value = ans[i][0];
                if (value == "1") {
                  jsonData[key] = 0;
                } else if (value == "2") {
                  jsonData[key] = 1;
                } else if (value == "3") {
                  jsonData[key] = 2;
                } else if (value == "4") {
                  jsonData[key] = 3;
                } else if (value == "5") {
                  jsonData[key] = 4;
                }
                // jsonData[key] = value;
              }
              //display score
              makePostApiCall(
                  setEnvironment.apiBaseUrlAUDIT, audit_unencoded_post, jsonData);
              Future.delayed(Duration(seconds: 5), () {
                makeGetApiCallPHQ(setEnvironment.apiBaseUrlAUDIT, id);
              });

              Future.delayed(Duration(seconds: 8), () {
                showDialog(
                    context: context, builder: (_) => _showScoreDialog());
                setState(() {
                  _isloading = false;
                });
              });
            } else {
              //next question
              setState(() {
                selectedAnswer = null;
                currentQuestionIndex++;
              });
            }
          }
        },
      ),
    );
  }

  _showScoreDialog() {
    // bool isPassed = false;

    // String title = isPassed ? "Passed " : "Failed";
    print("Check My Listt");
    print('Selected Options PHQ:');
    for (var option in selectedOptionsPHQ) {
      print("Check My Listt 11");
      print(option);
    }

    return AlertDialog(
      title: Text(
        "  Score: $phq_score\n  Diagnosis: $phq_diag",
        style: TextStyle(color: Colors.green, fontSize: 15),
      ),
      content: ElevatedButton(
        child: const Text("Return To Tasks"),
        onPressed: () {
          //Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskPage()),
          );
        },
      ),
    );
  }

  _showSelectAnOptionDialog() {
    return AlertDialog(
      title: Text(
        "  Selecting an option is mandatory.",
        style: TextStyle(color: Colors.green),
      ),
      content: ElevatedButton(
        child: const Text("Back to question"),
        onPressed: () {
          Navigator.pop(context);
          setState(() {
            //currentQuestionIndex = questionList[currentQuestionIndex];
          });
        },
      ),
    );
  }
}
