import "package:Health_Guardian/ClinicalTrailsPage.dart";
import "package:firebase_core/firebase_core.dart";
import "package:firebase_messaging/firebase_messaging.dart";
import "package:Health_Guardian/main.dart";
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import "package:Health_Guardian/Pushnotification.dart";
import 'package:Health_Guardian/environment.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print(message);
  if (message != null) {
    navigatorKey.currentState
        ?.pushNamed(ClinicalTrailsPage.route, arguments: message);
  }
}

void handleMessage(RemoteMessage? message) {
  if (message != null) {
    navigatorKey.currentState
        ?.pushNamed(ClinicalTrailsPage.route, arguments: message);
  }
}

class Api {
  final firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await firebaseMessaging.requestPermission();
    final fcmToken = await firebaseMessaging.getToken();
    print("I am here");
    print(fcmToken);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', fcmToken!);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}
