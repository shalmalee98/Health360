import 'dart:convert';
import 'package:Health_Guardian/Parkinsons.dart';
import 'package:Health_Guardian/soundRecorder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';

import 'loginpage.dart';

String id = "";
int phq_score = 2;
int sleep_score = -1;
int sleep_scale = 0;
Map cal_data = {};
Map phq_data = {};
List<Map> taskList = [];
String phq_diag = '';
String sleep_diag = '';

class apiCall extends StatefulWidget {
  const apiCall({Key? key}) : super(key: key);

  @override
  State<apiCall> createState() => _apiCallState();
}

class _apiCallState extends State<apiCall> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

@override
Widget build(BuildContext context) {
  return Container(
    height: 200,
    width: 300,
    decoration: BoxDecoration(
      color: Colors.green.withOpacity(.5),
    ),
  );
}

Map<String, String> calendarheaders = {
  'Content-Type': 'application/json',
  'User-Agent': 'PostmanRuntime/7.31.1',
  'Accept': '*/*',
  'Accept-Encoding': 'gzip, deflate, br',
  'Connection': 'keep-alive',
  'Authorization':
      'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNjg2NTkzNjE2LCJpYXQiOjE2Nzg4MTc2MTYsImp0aSI6ImI5YzM1MDNjMTk1YTQ0NmU5MjVmNWU3N2JiMWZlZWNlIiwidXNlcl9pZCI6MTEyfQ.r6dMDcY9HkB7zUrCo3m2u3-Bou72kPWiXEVGjbkJoDE'
};

//Post call for sleepq and phq tasks
Future<void> makePostApiCall(
    String baseUrl, String payLoad, Map<String, dynamic> jsonbody) async {
  final url = Uri.parse('$baseUrl/$payLoad');
  //print("Post URL: " + url.toString());
  // print("JSON BODY POST " + jsonbody.toString());
  final headers = {'Content-Type': 'application/json'};
  final body = jsonEncode(jsonbody);
  print("BODY" + body);
  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    print("RESPONSE BODY" + response.body);
    final bodyResponse = json.decode(response.body);
    id = bodyResponse['id'];
    print(id);
  } else {
    print("Error Post Request");
  }
}

//Get API Call for Sleep Questionnaire returning score
Future<int> makeGetApiCallSleepQ(String baseUrl, String payLoad) async {
  sleep_score = -1;
  final geturl = Uri.parse('$baseUrl/$payLoad');
  final headers = {'Content-Type': 'application/json'};
  final getResponse = await http.get(geturl, headers: headers);
  final getRequestBody = json.decode(getResponse.body);
  print("BODY DECODED " + getRequestBody.toString());
  if (getResponse.statusCode == 200) {
    if (getRequestBody.toString().contains("INVALID_RESULTS") ||
        getRequestBody.toString().contains("NOT_AVAILABLE")) {
      return sleep_score = -1;
    } else {
      sleep_score = getRequestBody['data']['sleep_scale'];
      sleep_diag = getRequestBody['data']['label'];
      cal_data = getRequestBody['data'];
    }
  } else {
    print('Get Request failed with status: ${getResponse.statusCode}.');
  }
  return sleep_score;
}

//Get API Call for PHQ8 returning score
Future<int> makeGetApiCallPHQ(String baseUrl, String payLoad) async {
  phq_score = -1;
  final geturl = Uri.parse('$baseUrl/$payLoad');

  final headers = {'Content-Type': 'application/json'};
  final getResponse = await http.get(geturl, headers: headers);
  final getRequestBody = json.decode(getResponse.body);
  print("BODY DECODED " + getRequestBody.toString());
  if (getResponse.statusCode == 200) {
    if (getRequestBody.toString().contains("INVALID_RESULTS") ||
        getRequestBody.toString().contains("NOT_AVAILABLE")) {
      return phq_score = -1;
    } else {
      phq_score = (getRequestBody['data']['score']);
      phq_diag = (getRequestBody['data']['classification']);
      cal_data = getRequestBody['data'];
    }
  } else {
    print('Get Request failed with status: ${getResponse.statusCode}.');
  }
  return phq_score;
}

//Similar to makePostApiCall() with different parameter datatype
Future<void> makePostCalendarCall(
    String baseUrl, String payLoad, String jsonbody) async {
  final url = Uri.parse('$baseUrl/$payLoad');
  print("URL" + url.toString());
  final headers = {'Content-Type': 'application/json'};
  final response = await http.post(url, headers: headers, body: jsonbody);
  print("RESPONSE" + response.toString());
  if (response.statusCode == 200) {
    final bodyResponse = json.decode(response.body);
    id = bodyResponse['id'];
  } else {
    print(response.statusCode);
    print("Error Post Request");
  }
}

//get api call for phq,returning map
Future<dynamic> makeGetApiCallPHQCalendar(
    String baseUrl, String payLoad) async {
  final geturl = Uri.parse('$baseUrl/$payLoad');
  final headers = {'Content-Type': 'application/json'};
  final getResponse = await http.get(geturl, headers: headers);
  final getRequestBody = json.decode(getResponse.body);
  cal_data = {};
  print("GET URL:" + geturl.toString());
  print("BODY DECODED " + getRequestBody.toString());

  if (getResponse.statusCode == 200) {
    if (getRequestBody.toString().contains("INVALID_RESULTS") ||
        getRequestBody.toString().contains("NOT_AVAILABLE")) {
    } else {
      phq_score = (getRequestBody['data']['score']);
      cal_data = getRequestBody['data'];
      print(phq_score);
    }
  } else {
    print('Get Request failed with status: ${getResponse.statusCode}.');
  }
  return cal_data;
}

//get api call for sleepq,returning map
Future<dynamic> makeGetApiCallSleepQCalendar(
    String baseUrl, String payLoad) async {
  final geturl = Uri.parse('$baseUrl/$payLoad');
  print(geturl);
  final headers = {'Content-Type': 'application/json'};
  final getResponse = await http.get(geturl, headers: headers);
  final getRequestBody = json.decode(getResponse.body);
  print("BODY DECODED " + getRequestBody.toString());

  if (getResponse.statusCode == 200) {
    if (getRequestBody.toString().contains("INVALID_RESULTS")) {
      return cal_data = {};
    } else {
      sleep_scale = (getRequestBody['data']['sleep_scale']);
      cal_data = getRequestBody['data'];
      print(sleep_scale);
      return cal_data;
    }
  } else {
    print('Get Request failed with status: ${getResponse.statusCode}.');
  }
}

//Get call for our Analytics API with score
Future<dynamic> getCallMockAPI(String baseUrl, String payLoad) async {
  cal_data = {};
  http.Response response = await http.get(
    Uri.parse('$baseUrl/$payLoad'),
    headers: calendarheaders,
  );

  if (response.statusCode == 200) {
    print("Success");
    final Data = jsonDecode(response.body);
    final getRequestBody = json.decode(response.body);
    print("=======================");
    print(Data.length);

    for (var i = 0; i < Data.length; i++) {
      taskList.add(Data[i]);
    }
  }
  return taskList;
}

Future<dynamic> postParkinson(String baseUrl, String payLoad) async {
  try {
    final request =
        await http.MultipartRequest("POST", Uri.parse('$baseUrl/$payLoad'));
    // var audioStream = http.ByteStream(Stream.castFrom(audioFile.openRead()));
    // var length = await audioFile.length();

    //var audio = http.MultipartFile.fromBytes('audio', (await rootBundle.load('${filePath}')).buffer.asUint8List(), filename: 'flutter_sound_tmp.wav');

    var audio = await createMultipartFileFromCacheFile('flutter_sound_tmp.wav');
    // Now you can use the audioMultipartFile in your HTTP request

    request.fields['user'] = user;
    request.files.add(audio);
    final response = await request.send();
    var responsedata = await response.stream.toBytes();
    var result = String.fromCharCodes(responsedata);

    print("This much is done");

    if (response.statusCode == 200) {
      // Handle the response from the server here
      print('POST request successful!');
      print('Response body: ${result}');
    } else {
      // Handle the case where the request was not successful
      print('POST request failed with status code ${response.statusCode}');
      print('Response body: ${result}');
    }
  } catch (e) {
    // Handle any exceptions that may occur during the POST request
    print('Error occurred during the POST request: $e');
  }
}

Future<http.MultipartFile> createMultipartFileFromCacheFile(
    String filePath) async {
  // Get the cache directory
  Directory cacheDir = await getTemporaryDirectory();
  print(cacheDir.path);

  // Read the file from the cache directory

  String filePath =
      '/data/user/0/com.example.Health_Guardian/app_flutter/records/record.wav';
  File audioFile = File(filePath);

  // Read file content as bytes
  // List<int> fileBytes = await file.readAsBytes();
  // print(fileBytes);
  if (audioFile.existsSync()) {
    // The file exists, you can proceed with uploading it.
    print("File Exists");
  } else {
    print("The file does not exist at the specified path: $filePath");
  }
  final audioStream = http.ByteStream(audioFile.openRead());
  final length = await audioFile.length();
  print(length);

  final userField = http.MultipartFile.fromString(
    'user', // Field name for the "user" field in the request
    user, // Value for the "user" field
  );

  // Create an http.MultipartFile
  final multipartFile = http.MultipartFile(
    'audio', // Field name for the audio file in the request
    audioStream,
    length,
    filename: 'record.wav', // Change this to the desired filename
    contentType: MediaType('audio', 'wav'), // Adjust the content type
  );

  return multipartFile;
}
