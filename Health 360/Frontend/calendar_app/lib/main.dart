import 'package:Health_Guardian/ClinicalTrailsPage.dart';
import 'package:Health_Guardian/ClinicalTrials/DetailsScreen.dart';
import 'package:Health_Guardian/ClinicalTrials/Questionnaires.dart';
import 'package:Health_Guardian/ClinicalTrials/Questions.dart';
import 'package:Health_Guardian/environment.dart';
import 'package:Health_Guardian/signuppage.dart';
import 'package:Health_Guardian/loginpage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'login_page.dart';
import 'task_page.dart';
//import 'login_page.dart';
import 'notification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import "package:Health_Guardian/Pushnotification.dart";
import "package:Health_Guardian/api/api.dart";
import "firebase_options.dart";

final navigatorKey = GlobalKey<NavigatorState>();
Future<void> main() async {
  setEnvironment
      .setUpEnv(environment.mock); //realService for IBM, mock for mockServer.
  WidgetsFlutterBinding.ensureInitialized();
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('launch_background');
  final InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);
  // await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Api().initNotifications();

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      navigatorKey: navigatorKey,
      routes: {
        NotificationScreen.route: (context) => const NotificationScreen(),
        SignupPageState.route: ((context) => SignupPage()),
        LoginPageState.route: ((context) => LoginPage()),
        DetailsScreen.route: ((context) => const DetailsScreen()),
        ClinicalTrailsPage.route: ((context) => ClinicalTrailsPage()),
        Questionnaires.route: ((context) => const Questionnaires()),
        Questions.route: ((context) => const Questions())
      }));
}
