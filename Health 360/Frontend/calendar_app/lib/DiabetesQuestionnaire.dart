import 'package:Health_Guardian/environment.dart';
import 'package:Health_Guardian/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:Health_Guardian/apiCall.dart';
import 'package:flutter/services.dart';
import 'Constants/urlConstant.dart';
import 'dart:convert';
import 'task_page.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:collection/collection.dart';
import 'dart:typed_data';


String phqRequestPath = 'Json/phqRequest.json';

String jsonString = '''
{
  "data_endpoint": "https://hg-production-taskmanager-ssc.ortmd733nb9.us-east.codeengine.appdomain.cloud/api/v1/datasets/0d78cf90-02b8-42f1-a15e-80687f4880d5"
}
''';

class DiabetesScreen extends StatefulWidget {
  @override
  State<DiabetesScreen> createState() => _DiabetesScreenState();
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
    "Do you suffer from High Blood Pressure?",
    [
      Answer("Yes"),
      Answer("No"),
    ],
  ));

  list.add(Question(
    "Have you been diagnosed with High Colesterol?",
    [
      Answer("Yes"),
      Answer("No"),
    ],
  ));

  list.add(Question(
    "What is your BMI (Body Mass Index)?",
    [
      Answer("BMI less than 18.5"),
      Answer("BMI between 18.5 and 24.9"),
      Answer("BMI between 25 and 29.9"),
      Answer("BMI between 30 and 34.9"),
      Answer("BMI between 35 and 39.9"),
      Answer("BMI 40 or higher"),
    ],
  ));

  list.add(Question(
    "Do you Smoke?",
    [
      Answer("Yes"),
      Answer("No"),
    ],
  ));

  list.add(Question(
    "Have you had any Stroke?",
    [
      Answer("Yes"),
      Answer("No"),
    ],
  ));

  list.add(Question(
    "Do you suffer from any Heath conditions or Heath Diseases?",
    [
      Answer("Yes"),
      Answer("No"),
    ],
  ));

  list.add(Question(
    "Do you engage in Physical Activity Daily?",
    [
      Answer("Yes"),
      Answer("No"),
    ],
  ));

  list.add(Question(
    "Are you a heavy drinker? (adult men having more than 14 drinks per week and adult women having more than 7 drinks per week)",
    [
      Answer("Yes"),
      Answer("No"),
    ],
  ));


  list.add(Question(
    "How will rate you your General Health?",
    [
      Answer("Excellent"),
      Answer("Very Good"),
      Answer("Good"),
      Answer("Fair"),
      Answer("Poor"),
    ],
  ));
  list.add(Question(
    "In Past 30 Days How many days have you suffered a mental distress?",
    [
      Answer("Less Than 10 Days"),
      Answer("10 to 15 Days"),
      Answer("15 to 20 Days"),
      Answer("Above 20 Days"),
    ],
  ));

  list.add(Question(
    "In Past 30 Days How many days have you suffered a physical distress?",
    [
      Answer("Less Than 10 Days"),
      Answer("10 to 15 Days"),
      Answer("15 to 20 Days"),
      Answer("Above 20 Days"),
    ],
  ));

  list.add(Question(
    "Do you face difficulty walking?",
    [
      Answer("Yes"),
      Answer("No"),
    ],
  ));

  list.add(Question(
    "What is your gender?",
    [
      Answer("Male"),
      Answer("Female"),
    ],
  ));

  list.add(Question(
    "What is your Age?",
    [
      Answer("18 to 30 years"),
      Answer("31 to 45 years"),
      Answer("45 to 60 years"),
      Answer("61 to 75 years"),
      Answer("76 years and above"),
    ],
  ));

  list.add(Question(
    "What is your Annual Income?",
    [
      Answer("Less than \$10,000"),
      Answer("\$10,000 to \$25,000"),
      Answer("\$25,000 to \$50,000"),
      Answer("\$50,000 to \$75,000"),
      Answer("Above \$75,000"),
    ],
  ));

  list.add(Question(
    "Do you include fruits and vegetables in your diet?",
    [
      Answer("Yes"),
      Answer("No"),
    ],
  ));

  return list;
}

class _DiabetesScreenState extends State<DiabetesScreen> {
  bool _isloading = false;
  //define the datas
  List<Question> questionList = getQuestions();
  int currentQuestionIndex = 0;
  int score = 0;
  Answer? selectedAnswer;
  List<String> ans = [];
  List<String> ansTest = [];
  String selectedOption = '';
  double maxValue = -100;
  int maxIndex = -1;

  @override
  void _showErrorDialog(String result) {

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
              child: Text('Return To Tasks'),
            ),
          ],
        );
      },
    );


  }
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
                "Diabetes Detection Questionnaire",
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
            selectedOption = answer.answerText;
          });
        },
      ),
    );
  }




  String DiabetesClassification = '';
  String popupMessage = '';

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
          List<int> selectedOptionsList = [];
          if (selectedAnswer == null) {
            showDialog(
                context: context, builder: (_) => _showSelectAnOptionDialog());
          } else {
            // ansTest.add(selectedAnswer);
            ansTest.add(selectedOption);
            if (isLastQuestion) {
              setState(() {
                _isloading = true;
              });

              //Dynamically allocating each selected answer as key value pair in jsonbody

              Map<String, dynamic> jsonData = json.decode(jsonString);
              print("Majhi New List");
              print(ansTest);
              for (int i = 0; i < ansTest.length; i++) {
                String key = 'question${i + 1}';
                String value = ansTest[i];
                jsonData[key] = value;
                if (i == 0 || i == 1 || i == 3 || i == 4 || i == 5 || i == 6 || i == 7 || i == 11 || i == 15)
                {
                  if (ansTest[i] == "Yes")
                  {selectedOptionsList.add(1);}
                  else{selectedOptionsList.add(0);}
                }
                if(i == 2)
                {
                  if (ansTest[i] == "BMI less than 18.5") {
                    selectedOptionsList.add(18);
                  } else if (ansTest[i] == "BMI between 18.5 and 24.9") {
                    selectedOptionsList.add(22);
                  } else if (ansTest[i] == "BMI between 25 and 29.9") {
                    selectedOptionsList.add(27);
                  } else if (ansTest[i] == "BMI between 30 and 34.9") {
                    selectedOptionsList.add(32);
                  } else if (ansTest[i] == "BMI between 35 and 39.9") {
                    selectedOptionsList.add(37);
                  } else if (ansTest[i] == "BMI 40 or higher") {
                    selectedOptionsList.add(42);
                  }
                }
                if(i == 8)
                {
                  if (ansTest[i] == "Excellent") {
                    selectedOptionsList.add(1);
                  } else if (ansTest[i] == "Very Good") {
                    selectedOptionsList.add(2);
                  } else if (ansTest[i] == "Good") {
                    selectedOptionsList.add(3);
                  } else if (ansTest[i] == "Fair") {
                    selectedOptionsList.add(4);
                  } else if (ansTest[i] == "Poor") {
                    selectedOptionsList.add(5);
                  }
                }
                if(i == 9 || i == 10)
                {
                  if (ansTest[i] == "Less Than 10 Days") {
                    selectedOptionsList.add(5);
                  } else if (ansTest[i] == "10 to 15 Days") {
                    selectedOptionsList.add(12);
                  } else if (ansTest[i] == "15 to 20 Days") {
                    selectedOptionsList.add(17);
                  } else if (ansTest[i] == "Above 20 Days") {
                    selectedOptionsList.add(25);
                  }
                }

                if(i == 12)
                {
                  if (ansTest[i] == "Male") {
                    selectedOptionsList.add(1);
                  }
                  else{
                    selectedOptionsList.add(0);
                  }
                }

                if(i == 13)
                {
                  if (ansTest[i] == "18 to 30 years") {
                    selectedOptionsList.add(1);
                  } else if (ansTest[i] == "31 to 45 years") {
                    selectedOptionsList.add(3);
                  } else if (ansTest[i] == "45 to 60 years") {
                    selectedOptionsList.add(7);
                  } else if (ansTest[i] == "61 to 75 years") {
                    selectedOptionsList.add(9);
                  } else if (ansTest[i] == "76 years and above") {
                    selectedOptionsList.add(13);
                  }
                }
                if (i == 14) {
                  if (ansTest[i] == "Less than \$10,000") {
                    selectedOptionsList.add(1);
                  } else if (ansTest[i] == "\$10,000 to \$25,000") {
                    selectedOptionsList.add(5);
                  } else if (ansTest[i] == "\$25,000 to \$50,000") {
                    selectedOptionsList.add(6);
                  } else if (ansTest[i] == "\$50,000 to \$75,000") {
                    selectedOptionsList.add(7);
                  } else if (ansTest[i] == "Above \$75,000") {
                    selectedOptionsList.add(8);
                  }
                }

              }

              print("Meri List: ");
              print(selectedOptionsList);
              //Model Calucation

              print(jsonData);
              print('My JsonData: $jsonData');

              print("My tflite models");
              //Importing ML model from assets
              try
              {
                  final interpreter = await Interpreter.fromAsset(
                      'assets/DiabetesModel3.tflite');
                  // Diabetic var input = [[1, 0, 42, 0, 0, 0, 0, 0, 1, 0, 4, 3, 5, 1, 0, 12, 3, 1]];
                  //var input = [[1, 0, 23, 0, 0, 0, 1, 1, 0, 0, 2, 0, 0, 0, 1, 13, 4, 1]];
                  // var input = [[1, 1, 36, 0, 0, 1, 1, 0, 4, 0, 14, 0, 1, 10, 5, 1]];
                  // var input = [[0, 0, 22, 0, 0, 0, 1, 0, 2, 3, 2, 0, 0, 6, 8, 1]];
                  var input = [selectedOptionsList];
                  print("My Input: ");
                  print(input);
                  var output = List.filled(3, 100).reshape([1, 3]);
                  //var output = Float32List(3);
                  print("interpreter run:");
                  interpreter.run(input, output);
                  print("Output?");

                  for (var value in output) {
                    for (int i = 0; i < value.length; i++) {
                      double num = value[i];
                      if (num > maxValue) {
                        maxValue = num;
                        maxIndex = i;
                      }
                    }

                    print("In Loop");
                    print(value);
                  }

                  print("Max value: $maxValue");
                  print("Max value Index: $maxIndex");

                  if (maxIndex == 0) {
                    DiabetesClassification = 'Non-Diabetic';
                    popupMessage = 'Great news! You have been classified as Non-Diabetic.';
                  } else if (maxIndex == 1) {
                    DiabetesClassification = 'Pre-Diabetic';
                    popupMessage = 'You are classified as Pre-Diabetic. Please consider consulting your doctor for advice.';
                  } else {
                    DiabetesClassification = 'Diabetic';
                    popupMessage = 'You have been classified as Diabetic. It\'s important to consult your doctor for proper management.';
                  }

                  interpreter.close();
                  //display score

                  Map<String, dynamic> diab_score = {
                    "user": user,
                    "score": maxIndex,
                  };


                  makePostApiCall(setEnvironment.apiBaseUrlDiab, diab_unencoded_post, diab_score);

                  Future.delayed(Duration(seconds: 8), () {
                    showDialog(
                        context: context, builder: (_) => _showScoreDialog());
                    setState(() {
                      _isloading = false;
                    });
                  });

              } catch (e) {
                print("Error occurred: $e");
                final result = "Failed to connect to the server. Please try again in some time.";
                _showErrorDialog(result);
              }




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
        // "  You are classified as $popupMessage"
        " $popupMessage",
        style: TextStyle(color: Colors.green),
      ),
      content: ElevatedButton(
        child: const Text("Go To Tasks"),
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


