import 'package:Health_Guardian/task_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//blank questionnaire displaying information of the disease

class brady_q extends StatelessWidget {
  const brady_q({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/Background.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(children: [
                  Padding(padding: EdgeInsets.fromLTRB(20, 60, 20, 0)),
                  Row(
                    children: [
                      IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TaskPage()))),
                      Padding(padding: EdgeInsets.fromLTRB(10, 30, 10, 15)),
                      Text(
                        "Health Guardian",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                  SafeArea(child: Padding(padding:EdgeInsets.all(15),
                      child: Text("Bradykinesia is a common symptom of Parkinson's disease, characterized by slow movement and reduced spontaneous movements, caused by degeneration of dopamine-producing neurons in the brain.",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),))),
                  SafeArea(child: Padding(padding:EdgeInsets.all(15),
                      child: Text("The feature you have requested is not currently available, but it will be implemented in the near future.\nWe apologize for any inconvenience this may cause and appreciate your patience and understanding as we work to improve our product.",
                        style: TextStyle(fontStyle: FontStyle.italic, fontSize: 14),)))
                ])
            )
        )
    );
  }
}
