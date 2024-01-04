import 'package:Health_Guardian/environment.dart';
import 'package:flutter/material.dart';
import 'package:Health_Guardian/apiCall.dart';
import 'package:flutter/services.dart';
import 'Constants/urlConstant.dart';
import 'dart:convert';
import 'loginpage.dart';
import 'task_page.dart';

String phqRequestPath = 'Json/phqRequest.json';

String jsonString = '''
{
  "user": "${user}"
}
''';

class PHQ8Screen extends StatefulWidget {
  @override
  State<PHQ8Screen> createState() => _PHQ8ScreenState();
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
    "Little Interest or Pleasure in doing Things",
    [
      Answer("Not At All"),
      Answer("Several Days"),
      Answer("Over Half of the Days"),
      Answer("Almost Everyday"),
    ],
  ));

  list.add(Question(
    "Either feel Down, Depressed, or Hopeless",
    [
      Answer("Not At All"),
      Answer("Several Days"),
      Answer("Over Half of the Days"),
      Answer("Almost Everyday"),
    ],
  ));

  list.add(Question(
    "Trouble falling Asleep or Sleeping too Much",
    [
      Answer("Not At All"),
      Answer("Several Days"),
      Answer("Over Half of the Days"),
      Answer("Almost Everyday"),
    ],
  ));

  list.add(Question(
    "Feeling Tired or Lack of Energy",
    [
      Answer("Not At All"),
      Answer("Several Days"),
      Answer("Over Half of the Days"),
      Answer("Almost Everyday"),
    ],
  ));

  list.add(Question(
    "Poor Appetite or Overeating",
    [
      Answer("Not At All"),
      Answer("Several Days"),
      Answer("Over Half of the Days"),
      Answer("Almost Everyday"),
    ],
  ));

  list.add(Question(
    "Feeling Bad about yourself or that you are a failure",
    [
      Answer("Not At All"),
      Answer("Several Days"),
      Answer("Over Half of the Days"),
      Answer("Almost Everyday"),
    ],
  ));

  list.add(Question(
    "Trouble Concentrating on Tasks like Reading or Watching Television",
    [
      Answer("Not At All"),
      Answer("Several Days"),
      Answer("Over Half of the Days"),
      Answer("Almost Everyday"),
    ],
  ));

  list.add(Question(
    "Moving or Speaking Slowly that Other People Could have noticed. Or being Fidhety or restless that you have been moving around a lot more than usual",
    [
      Answer("Not At All"),
      Answer("Several Days"),
      Answer("Over Half of the Days"),
      Answer("Almost Everyday"),
    ],
  ));

  return list;
}

class _PHQ8ScreenState extends State<PHQ8Screen> {
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
                      "Patient Health Questionnaire",
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
                String value = ans[i];
                if (value=="Not At All"){
                  jsonData[key]=0;
                }
                else if(value=="Several Days"){
                  jsonData[key]=1;
                }
                else if(value=="Over Half of the Days"){
                  jsonData[key]=2;
                }
                else if(value=="Almost Everyday"){
                  jsonData[key]=3;
                }
                //jsonData[key] = value;
              }
              print(jsonData);
              //display score
              makePostApiCall(setEnvironment.apiBaseUrlPHQ, phq_unencoded_post,
                  jsonData);
              Future.delayed(Duration(seconds: 5), () {
                makeGetApiCallPHQ(setEnvironment.apiBaseUrlPHQ, id);
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
