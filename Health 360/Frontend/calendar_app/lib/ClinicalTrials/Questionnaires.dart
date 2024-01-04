import 'package:Health_Guardian/ClinicalTrials/DetailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Health_Guardian/ClinicalTrials/Questionnaires.dart';
import 'package:Health_Guardian/ClinicalTrials/Questions.dart';

class QuestionsData {
  final List<dynamic> questions;
  final String id;

  QuestionsData(this.questions, this.id);
}

class Questionnaires extends StatelessWidget {
  const Questionnaires({Key? key}) : super(key: key);
  static const route = '/questionnaires';

  @override
  Widget build(BuildContext context) {
    const colors = [
      Color.fromRGBO(65, 171, 101, 0.6),
      Color(0x99AB937F),
      Color.fromARGB(153, 63, 94, 139),
      Color(0x99556B2F),
      Color(0x99BC735D),
      Color.fromRGBO(6, 94, 139, 0.6)
    ];
    final item =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    if (item != null &&
        item['questionnaire'] != null &&
        item['questionnaire'].length > 0) {
      return Scaffold(
          appBar: AppBar(
            title: Text("Questionnaire"),
          ),
          body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/Background.jpg"),
                    fit: BoxFit.cover)),
            child: ListView.builder(
              itemCount: item['questionnaire'].length,
              itemBuilder: (context, index) {
                final questionnaire = item['questionnaire'][index];

                var questions = [];
                if (questionnaire['questions'] != null &&
                    questionnaire['questions'].length > 0) {
                  questions = questionnaire['questions'];
                }
                return Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: colors[(index) % 6],
                        borderRadius: BorderRadius.circular(5)),
                    child: ListTile(
                      title: Text(questionnaire['name'] ?? 'No Name'),
                      subtitle: Text(
                          questionnaire['description'] ?? 'No Description'),
                      onTap: () {
                        navigateToQuestionsScreen(
                            context, questions, questionnaire['_id']);
                      },
                    ));
              },
            ),
          ));
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Questions"),
        ),
        body: Center(child: Text("No Questionnaire")));
  }

  void navigateToQuestionsScreen(
      BuildContext context, List<dynamic> questions, String Id) {
    Navigator.pushNamed(
      context,
      Questions.route,
      arguments: QuestionsData(questions, Id),
    );
  }
}
