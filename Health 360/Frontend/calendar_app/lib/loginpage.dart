import 'dart:convert';
import 'package:Health_Guardian/environment.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'task_page.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:Health_Guardian/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'task_page.dart';
import 'Constants/urlConstant.dart' as global;

double wdt = 360.0;
double ht = 700.0;

String user = "User01";
String accesscode = "";

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  static const route = '/loginScreen';
  bool _isLoading = false;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(statusBarColor: Colors.transparent));
    wdt = MediaQuery.of(context).size.width;
    ht = MediaQuery.of(context).size.height;
    return Scaffold(
      //setting up the background
      // resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/Background.jpg"), fit: BoxFit.fill),
        ),
        //adding the loading screen
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, ht / 7, 0, ht / 84)),
                    //adding the logo
                    Center(
                        child: Image.asset(
                      'images/logo.png',
                      fit: BoxFit.contain, // or BoxFit.cover
                      width: wdt / 2.05, // set the width to control the size
                      height: ht / 7.0,
                    )),
                    //adding all the sections
                    Center(child: headerSection()),
                    Center(child: textSection1()),
                    Center(child: textSection2()),
                    Center(child: forgotpw()),
                    Center(child: buttonSection()),
                    Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: ht / 35, horizontal: 0.0)),
                    Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            shadows: [
                              Shadow(
                                color: Colors.black87.withOpacity(0.2),
                                offset: const Offset(1, 2),
                                blurRadius: 6,
                              )
                            ],
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(wdt / 90)),
                        InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/signupScreen');
                            },
                            child: Text(
                              "Sign up",
                              style: TextStyle(
                                color: Color.fromRGBO(98, 121, 184, 1),
                                shadows: [
                                  Shadow(
                                    color: Colors.black87.withOpacity(0.2),
                                    offset: const Offset(1, 2),
                                    blurRadius: 6,
                                  )
                                ],
                              ),
                            ))
                      ],
                    )),
                    Padding(padding: EdgeInsets.all(wdt / 20.55)),
                    Text(
                      "Version: 1.0.0",
                      style: TextStyle(
                        shadows: [
                          Shadow(
                            color: Colors.black87.withOpacity(0.2),
                            offset: const Offset(1, 2),
                            blurRadius: 6,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  signIn(String email, pass) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //taking the username and password as body
    Map data = {'username': email, 'password': pass};
    var jsonResponse = null;
    //posting the body
    try {
      var response =
          await http.post(Uri.parse(setEnvironment.loginBaseUrl), body: data);
      print(response.body);
      //verifying status code
      if (response.statusCode == 200) {
        jsonResponse = json.decode(response.body);
        final prefs = await SharedPreferences.getInstance();
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        prefs.setString('userId', jsonData['user']['_id']);
        user = jsonResponse['user']['username'];
        if (jsonResponse['access'] != null) {
          accesscode = jsonResponse['access'];
        }
        String? token = prefs.getString('token');
        print(token);
        print("The user that logged in is ${token}");
        Map data = {'username': user, 'token': token};
        var updateToken =
            await http.post(Uri.parse(setEnvironment.addTokenUrl), body: data);
        print(updateToken);
        print("Fetching access code");
        print(accesscode);
        if (accesscode != "") {
          global.bearerToken = accesscode;
        }
        print(user);
        if (jsonResponse != null) {
          setState(() {
            _isLoading = false;
          });
          //moving to next page if verified
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (BuildContext context) => TaskPage()),
              (Route<dynamic> route) => false);
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        //showing error if login failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor:
                Colors.red, // Change the background color of the SnackBar
            content: Row(
              children: [
                Icon(
                  Icons.error_outline, // Add an icon to the SnackBar
                  color: Colors.white,
                ),
                SizedBox(width: wdt / 51.4),
                Text(
                  'Failed to Sign in: Wrong username or password',
                  style: TextStyle(color: Colors.white, fontSize: wdt / 28.5),
                ),
              ],
            ),
            duration: Duration(seconds: 3),
            behavior: SnackBarBehavior
                .floating, // Set the behavior of the SnackBar to floating
            shape: RoundedRectangleBorder(
              // Set a rounded border for the SnackBar
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        );
        print(response.body);
      }
    } catch (error) {
      print(error);
    }
  }

  //button for login
  Container buttonSection() {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          color: Color.fromRGBO(65, 171, 91, 1),
          borderRadius: BorderRadius.circular(29),
          boxShadow: [
            BoxShadow(
              color: Colors.black87.withOpacity(0.2),
              offset: Offset(2, 5),
              blurRadius: 3,
            )
          ]),

      width: size.width * 0.8,
      height: ht / 13.8,
      //padding: const EdgeInsets.symmetric(horizontal: 15.0),
      margin: EdgeInsets.only(top: ht / 28),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              fixedSize: Size(size.width * 0.8, ht / 28.1),
              backgroundColor: Color.fromRGBO(65, 171, 101, 1)),
          onPressed: () {
            if (emailController.text == "" || passwordController.text == "") {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Colors.white,
                      ),
                      SizedBox(width: wdt / 51.4),
                      Text(
                        'Username or Password Field cannot be empty',
                        style:
                            TextStyle(color: Colors.white, fontSize: wdt / 28),
                      ),
                    ],
                  ),
                  duration: Duration(seconds: 3),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              );
            } else {
              setState(() {
                _isLoading = true;
              });
              signIn(emailController.text, passwordController.text);
            }
          },
          child: const Text("Login",
              style: TextStyle(color: Colors.black87, fontSize: 16)),
        ),
      ),
    );
  }

  //controllers for username and password field

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  //field for username
  Container textSection1() {
    Size size = MediaQuery.of(context).size;
    return Container(
      //margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      padding: EdgeInsets.symmetric(horizontal: wdt / 18, vertical: ht / 346),
      decoration: BoxDecoration(
          color: Color.fromRGBO(236, 241, 250, 1),
          borderRadius: BorderRadius.circular(29),
          boxShadow: [
            BoxShadow(
              color: Colors.black87.withOpacity(0.2),
              offset: Offset(2, 5),
              blurRadius: 3,
            )
          ]),
      child: Column(
        children: <Widget>[
          TextField(
            controller: emailController,
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.black87),
            decoration: InputDecoration(
              border: InputBorder.none,
              icon: Icon(Icons.person, color: Colors.grey),
              hintText: "Username",
              hintStyle: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Container forgotpw() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      //margin: EdgeInsets.symmetric(horizontal: 50),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            "Forgot Password?",
            style: TextStyle(
                color: Color.fromRGBO(98, 121, 141, 1),
                fontSize: 10,
                fontWeight: FontWeight.w500),
          ),
          Padding(padding: EdgeInsets.all(wdt / 180)),
          Icon(Icons.key_outlined, color: Colors.grey, size: 15),
          Padding(padding: EdgeInsets.all(wdt / 36))
        ],
      ),
    );
  }

  //password field
  Container textSection2() {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: ht / 70),
      width: size.width * 0.8,
      padding: EdgeInsets.symmetric(horizontal: wdt / 18, vertical: ht / 346),
      decoration: BoxDecoration(
          color: Color.fromRGBO(236, 241, 250, 1),
          borderRadius: BorderRadius.circular(29),
          boxShadow: [
            BoxShadow(
              color: Colors.black87.withOpacity(0.2),
              offset: Offset(2, 5),
              blurRadius: 3,
            )
          ]),
      child: Column(
        children: <Widget>[
          TextField(
            controller: passwordController,
            cursorColor: Colors.black87,
            obscureText: _obscureText,
            style: const TextStyle(color: Colors.black87),
            decoration: InputDecoration(
                border: InputBorder.none,
                icon: Icon(Icons.lock, color: Colors.grey),
                hintText: "Password",
                hintStyle: TextStyle(color: Colors.grey),
                //setting the hide unhide password button
                suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    child: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: Colors.grey,
                    ))),
          ),
        ],
      ),
    );
  }

  Container headerSection() {
    return Container(
      margin: EdgeInsets.only(top: ht / 23.5),
      padding: EdgeInsets.symmetric(horizontal: wdt / 18, vertical: ht / 23.5),
      child: Text("Health 360",
          style: TextStyle(
              //decoration: TextDecoration.underline,
              shadows: [
                Shadow(
                  color: Colors.black87.withOpacity(0.3),
                  offset: const Offset(2, 5),
                  blurRadius: 3,
                )
              ],
              color: Color.fromRGBO(22, 44, 70, 1),
              fontSize: wdt / 10.4,
              fontWeight: FontWeight.bold)),
    );
  }
}
