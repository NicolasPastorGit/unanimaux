import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  // Créé une instance de FirebaseMessaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // Initialise les notifications
  Future<void> initNotifications() async {
    // Demande la permission à l'utilisateur concernant les notifications
    await FirebaseMessaging.instance.requestPermission();

    // Récupère le token FCM (firebase cloud messaging) pour ce device
    final FCMtoken = await _firebaseMessaging.getToken();

    // Affiche le token pour test
    print("FCM token : $FCMtoken");
  }

  // Fonction pour gérer la réception de messages
  void handleMessage(RemoteMessage? message) {
    // Si le message est null, ne rien faire
    if(message == null) return;
  }
}