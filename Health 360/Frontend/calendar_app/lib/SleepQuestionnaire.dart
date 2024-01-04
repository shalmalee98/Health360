import 'dart:convert';
import 'package:Health_Guardian/environment.dart';

import 'Constants/urlConstant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Health_Guardian/apiCall.dart';
import 'loginpage.dart';
import 'task_page.dart';

String sqRequestPath = 'Json/sqRequest.json';
String jsonString = '''
{
  "user": "${user}"
}
''';

class SLeepQ extends StatefulWidget {
  @override
  State<SLeepQ> createState() => _SLeepQState();
}

class Question {
  final String questionText;
  final List<Answer> answersList;

  Question(this.questionText, this.answersList);
}

class Answer {
  final String answerText;
  //final bool isCorrect;

  Answer(this.answerText);
}

List<Question> getQuestions() {
  List<Question> list = [];
  //ADD questions and answer here

  list.add(Question(
    "Please rate your sleepiness.",
    [
      Answer("Feeling active,vital,alert,or wide awake"),
      Answer("Functioning at high levels,but not fully alert"),
      Answer("Awake,but relaxed;responsive but not fully alert"),
      Answer("Somewhat foggy, let down"),
      Answer("Foggy;losing interest in remaining awake;slowed down"),
      Answer("Sleepy,woozy,fighting sleep;prefer to lie down"),
      Answer("No longer fighting sleep;sleep onset soon,having dreamlike thoughts"),
    ],
  ));

  return list;
}

class _SLeepQState extends State<SLeepQ> {
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
                      "Sleep Questionnaire",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: MediaQuery.of(context).size.width / 17.1,
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
        //Numbering for questions
        Text(
          "Question ${currentQuestionIndex + 1}/${questionList.length.toString()}",
          style: TextStyle(
            color: Colors.black,
            fontSize: MediaQuery.of(context).size.width / 20.55,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 42.15,
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.93,
          alignment: Alignment.center,
          padding: EdgeInsets.all(
            MediaQuery.of(context).size.height / 26.4,
          ),
          decoration: BoxDecoration(
            color: Color.fromRGBO(55, 169, 100, 1),
            borderRadius: BorderRadius.circular(16),
          ),
          //Display question
          child: Text(
            questionList[currentQuestionIndex].questionText,
            style: TextStyle(
              color: Colors.white,
              fontSize: MediaQuery.of(context).size.width / 22.9,
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
    //if answer selected
    bool isSelected = answer == selectedAnswer;

    return Container(
      width: MediaQuery.of(context).size.width * 0.93,
      margin: EdgeInsets.symmetric(vertical: 8),
      height: MediaQuery.of(context).size.height / 17.7,
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
          //Adding selected answer to ans list to be passed in json request
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
      height: MediaQuery.of(context).size.height / 17.6,
      child: ElevatedButton(
        child: Text(isLastQuestion ? "Submit" : "Next"),
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          primary: Colors.blueAccent,
          onPrimary: Colors.white,
        ),
        onPressed: () async {
          setState(() {
            _isloading = true;
          });
          if (selectedAnswer == null) {
            showDialog(
                context: context, builder: (_) => _showSelectAnOptionDialog());
          } else {
            //Dynamically allocating each selected answer as key value pair in jsonbody
            if (isLastQuestion) {

              Map<String, dynamic> jsonData = json.decode(jsonString);
              for (int i = 0; i < ans.length; i++) {
                String key = 'question${i + 1}';
                String value = ans[i];
                if (value=="Feeling active,vital,alert,or wide awake"){
                  jsonData[key]=0;
                }
                else if(value=="Functioning at high levels,but not fully alert"){
                  jsonData[key]=1;
                }
                else if(value=="Awake,but relaxed;responsive but not fully alert"){
                  jsonData[key]=2;
                }
                else if(value=="Somewhat foggy, let down"){
                  jsonData[key]=3;
                }
                else if(value=="Foggy;losing interest in remaining awake;slowed down"){
                  jsonData[key]=4;
                }
                else if(value=="Sleepy,woozy,fighting sleep;prefer to lie down"){
                  jsonData[key]=5;
                }
                else if(value=="No longer fighting sleep;sleep onset soon,having dreamlike thoughts"){
                  jsonData[key]=6;
                }
                //jsonData[key] = value;
              }
              // perform api call for the particular test results
              makePostApiCall(
                  setEnvironment.apiBaseUrlSleepQ,
                  sleepq_unencoded_post,
                  jsonData);
              Future.delayed(Duration(seconds: 5), () {
                makeGetApiCallSleepQ(setEnvironment.apiBaseUrlSleepQ, id);
              });

              Future.delayed(Duration(seconds: 6), () {

                showDialog(
                    context: context, builder: (_) => _showScoreDialog());
                setState(() {
                  _isloading=false;
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
//If  no answer selected,mandatory answer needs to be selected popup
    return AlertDialog(
      title: Text(
        "  Score: $sleep_score\n  Diagnosis: $sleep_diag",
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
    // bool isPassed = false;

    // String title = isPassed ? "Passed " : "Failed";

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
