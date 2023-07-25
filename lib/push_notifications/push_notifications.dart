import 'package:firebase_messaging/firebase_messaging.dart';

void setupPushNotifications(String topic) async {
  final fcm = FirebaseMessaging.instance;
  await fcm.requestPermission();

  fcm.subscribeToTopic(topic);
  // final token = await fcm.getToken();
  // print(token);
}
