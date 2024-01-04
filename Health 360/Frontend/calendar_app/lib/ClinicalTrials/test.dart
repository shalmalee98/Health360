import 'package:flutter/material.dart';

class QuestionnaireWidget extends StatefulWidget {
  final List<Question> questions;
  final String questionnaireId;
  final String userId;

  const QuestionnaireWidget({
    required this.questions,
    required this.questionnaireId,
    required this.userId,
  });

  @override
  _QuestionnaireWidgetState createState() => _QuestionnaireWidgetState();
}

class _QuestionnaireWidgetState extends State<QuestionnaireWidget> {
  List<String> responses = [];

  @override
  Widget build(BuildContext context) {
    final questions =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    return ListView.builder(
      itemCount: questions.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            Text(questions[index].question),
            if (questions[index].questionType == 'multiselect')
              CheckboxOptionsWidget(
                options: questions[index].questionOptions,
                onChanged: (selectedOptions) {
                  // Record selected options along with the question ID
                  String questionId = questions[index].id;
                  String selectedOptionIds =
                      selectedOptions.map((option) => option.id).join(",");
                  responses.add("$questionId:$selectedOptionIds");
                },
              ),
            // Add more conditional widgets for other question types here
          ],
        );
      },
    );
  }
}

class CheckboxOptionsWidget extends StatefulWidget {
  final List<Option> options;
  final Function(List<Option>) onChanged;

  CheckboxOptionsWidget({required this.options, required this.onChanged});

  @override
  _CheckboxOptionsWidgetState createState() => _CheckboxOptionsWidgetState();
}

class _CheckboxOptionsWidgetState extends State<CheckboxOptionsWidget> {
  List<Option> selectedOptions = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.options.map((option) {
        return CheckboxListTile(
          title: Text(option.name),
          value: selectedOptions.contains(option),
          onChanged: (selected) {
            setState(() {
              if (selected != null) {
                if (selected) {
                  selectedOptions.add(option);
                } else {
                  selectedOptions.remove(option);
                }
              }
              widget.onChanged(selectedOptions);
            });
          },
        );
      }).toList(),
    );
  }
}

class Question {
  final String id;
  final String question;
  final String questionType;
  final List<Option> questionOptions;

  Question({
    required this.id,
    required this.question,
    required this.questionType,
    required this.questionOptions,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    List<Option> options = (json['questionOptions'] as List).map((option) {
      return Option.fromJson(option);
    }).toList();

    return Question(
      id: json['_id'],
      question: json['question'],
      questionType: json['questionType'],
      questionOptions: options,
    );
  }
}

class Option {
  final String id;
  final String name;
  final String image;

  Option({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Option.fromJson(Map<String, dynamic> json) {
    return Option(
      id: json['_id'],
      name: json['name'],
      image: json['image'],
    );
  }
}
