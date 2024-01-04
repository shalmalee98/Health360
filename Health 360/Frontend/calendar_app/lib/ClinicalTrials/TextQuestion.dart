import 'package:flutter/material.dart';

class TextInputQuestion extends StatefulWidget {
  final Map<String, dynamic> question;
  final List<List<String>> selectedChoices;
  final int index;

  TextInputQuestion(this.question, this.selectedChoices, this.index);

  @override
  _TextInputQuestionState createState() => _TextInputQuestionState();
}

class _TextInputQuestionState extends State<TextInputQuestion> {
  String? userResponse;

  @override
  Widget build(BuildContext context) {
    if (widget.question['questionImage'] != null &&
        widget.question['questionImage'].length > 0) {
      return Container(
          margin: EdgeInsets.all(8.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${widget.index + 1}. ${widget.question['question']}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: Image.network(
                    widget.question['questionImage'],
                    height: null,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Type your answer here',
                  ),
                  onChanged: (text) {
                    setState(() {
                      userResponse = text;
                      widget.selectedChoices[widget.index] = [userResponse!];
                    });
                  },
                ),
              ]));
    } else {
      return Container(
          margin: EdgeInsets.all(8.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${widget.index + 1}. ${widget.question['question']}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Type your answer here',
                  ),
                  onChanged: (text) {
                    setState(() {
                      userResponse = text;
                      widget.selectedChoices[widget.index] = [userResponse!];
                    });
                  },
                ),
              ]));
    }
    return Column(
      children: <Widget>[
        // Display the question text
        Text(widget.question['question'] ?? 'Question'),
        // Display a text input field for the user's response
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: Image.network(
            widget.question['questionImage'],
            height: null, // Set the height as needed
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        TextField(
          decoration: InputDecoration(
            hintText: 'Type your answer here',
          ),
          onChanged: (text) {
            setState(() {
              userResponse = text;
              widget.selectedChoices[widget.index] = [userResponse!];
            });
          },
        ),
      ],
    );
  }
}
