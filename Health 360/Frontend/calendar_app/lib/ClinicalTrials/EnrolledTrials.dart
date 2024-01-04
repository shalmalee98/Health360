import 'package:Health_Guardian/ClinicalTrials/Questionnaires.dart';
import 'package:Health_Guardian/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class EnrolledTrials extends StatefulWidget {
  @override
  EnrolledTrialsState createState() => EnrolledTrialsState();
}

class EnrolledTrialsState extends State<EnrolledTrials> {
  late Future<List<dynamic>> _dataFuture;
  late List<dynamic> _trialData = [];
  late List<dynamic> _enrolledData = [];

  @override
  void initState() {
    super.initState();
    _dataFuture = fetchData();
  }

  Future<List<dynamic>> fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    final response = await http.post(
      Uri.parse(
          'https://midyear-castle-408217.uc.r.appspot.com/users/subscribedTo'),
      body: {'userId': userId},
    );

    if (response.statusCode == 201) {
      List<dynamic> jsonArray = jsonDecode(response.body);
      _trialData = jsonArray;
      _enrolledData = jsonArray;
      return jsonArray;
    } else {
      print('HTTP POST request failed with status: ${response.statusCode}');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    const colors = [
      Color.fromRGBO(244, 172, 69, 0.6),
      Color.fromRGBO(65, 171, 101, 0.6),
      Color(0x99AB937F),
      Color.fromARGB(153, 63, 94, 139),
      Color(0x99556B2F),
      Color(0x99BC735D),
      Color.fromRGBO(6, 94, 139, 0.6)
    ];

    return Scaffold(
        body: FutureBuilder<List<dynamic>>(
            future: _dataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return Center(child: Text('No data available.'));
              } else {
                return Scaffold(
                  body: SafeArea(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("images/Background.jpg"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 30, 10, 0),
                          ),
                          Row(
                            children: [
                              Padding(
                                  padding: EdgeInsets.fromLTRB(10, 30, 10, 0)),
                              Text(
                                "Enrolled Trials",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).size.width / 21,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width / 27.0),
                          ),
                          // Add Search Bar here
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              MediaQuery.of(context).size.width / 8.22,
                              0, // Top padding
                              MediaQuery.of(context).size.width / 8.22,
                              0, // Bottom padding - Change this value to adjust the bottom padding
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width / 205.5,
                                  vertical: MediaQuery.of(context).size.height /
                                      421.5,
                                ),
                                hintText: "Search",
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                  borderSide: BorderSide(),
                                ),
                              ),
                              onChanged: (search) {
                                if (search.length == 0) {
                                  _trialData = _enrolledData;
                                }
                                setState(() {
                                  _trialData = _enrolledData.where((trial) {
                                    return trial['name']
                                        .toLowerCase()
                                        .contains(search.toLowerCase());
                                  }).toList();
                                });
                              },
                            ),
                          ),
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 50),
                          // Display Enrolled Trials
                          Expanded(
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: MediaQuery.of(context)
                                        .size
                                        .width /
                                    (MediaQuery.of(context).size.height / 3),
                              ),
                              itemCount: _trialData.length > 0
                                  ? _trialData.length
                                  : snapshot.data?.length,
                              itemBuilder: (context, index) {
                                var item;
                                if (_trialData.length == 0) {
                                  return null;
                                }
                                if (_trialData != null &&
                                    _trialData.length >= index &&
                                    _trialData[index] != null &&
                                    _trialData[index]['_id'].length > 0) {
                                  item = _trialData[index];
                                } else {
                                  item = snapshot.data![index];
                                }
                                if (item != null) {
                                  return Container(
                                    margin: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: colors[index % 6],
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ListTile(
                                      title: Padding(
                                        padding: EdgeInsets.only(top: 8),
                                        child: Text(
                                          item['name'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      subtitle: Text(
                                        item['description'],
                                        overflow: TextOverflow
                                            .ellipsis, // Set overflow behavior
                                        maxLines:
                                            2, // Adjust the number of visible lines if needed
                                      ),
                                      onTap: () {
                                        navigatorKey.currentState?.pushNamed(
                                          Questionnaires.route,
                                          arguments: item,
                                        );
                                      },
                                    ),
                                  );
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }));
  }
}
