import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DHandleToken {
  User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference DoctorsDoc =
      FirebaseFirestore.instance.collection("Doctors");
  insertToken() async {
    //get token
    var fcm = FirebaseMessaging.instance;
    final fcmToken = await fcm.getToken();
    print("FCM token is :$fcmToken");
    //set Token
    DoctorsDoc.doc(user?.uid).update({"D_Token": fcmToken});
    print("INSERTED TOKEN SUCCESSFULLY");
  }
}
