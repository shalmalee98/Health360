import 'package:flutter/material.dart';

class MultiChoiceQuestion extends StatefulWidget {
  final Map<String, dynamic> question;
  final List<List<String>> selectedChoices;
  final int index;

  MultiChoiceQuestion(this.question, this.selectedChoices, this.index);

  @override
  _MultiChoiceQuestionState createState() => _MultiChoiceQuestionState();
}

class _MultiChoiceQuestionState extends State<MultiChoiceQuestion> {
  @override
  Widget build(BuildContext context) {
    List<dynamic> choices = widget.question['questionOptions'] as List<dynamic>;
    if (widget.question['questionImage'] != null &&
        widget.question['questionImage'].length > 0) {
      return Column(
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
          Column(
            children: choices.asMap().entries.map((entry) {
              int index = entry.key;
              dynamic choice = entry.value;
              bool _value =
                  widget.selectedChoices[widget.index].contains(choice["name"]);

              return SizedBox(
                width: 300,
                child: CheckboxListTile(
                  title: Text(choice["name"]!),
                  value: _value,
                  onChanged: (value) {
                    print(value);
                    setState(() {
                      if (value!) {
                        widget.selectedChoices[widget.index]
                            .add(choice["name"]);
                      } else {
                        widget.selectedChoices[widget.index]
                            .remove(choice["name"]);
                      }
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '${widget.index + 1}. ${widget.question['question']}',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        Column(
          children: choices.asMap().entries.map((entry) {
            int index = entry.key;
            dynamic choice = entry.value;
            bool _value =
                widget.selectedChoices[widget.index].contains(choice["name"]);

            return SizedBox(
              width: 300,
              child: CheckboxListTile(
                title: Text(choice["name"]!),
                value: _value,
                onChanged: (value) {
                  print(value);
                  setState(() {
                    if (value!) {
                      widget.selectedChoices[widget.index].add(choice["name"]);
                    } else {
                      widget.selectedChoices[widget.index]
                          .remove(choice["name"]);
                    }
                  });
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
