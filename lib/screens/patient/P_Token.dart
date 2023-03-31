import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PHandleToken {
  User? user = FirebaseAuth.instance.currentUser;
  final CollectionReference PatientDoc =
      FirebaseFirestore.instance.collection("Patients");
  insertToken() async {
    //get token
    var _fcm = FirebaseMessaging.instance;
    final fcmToken = await _fcm.getToken();
    print("FCM token is :$fcmToken");
    //set Token
    PatientDoc.doc(user?.uid).update({"P_Token": fcmToken});
    print("INSERTED TOKEN SUCCESSFULLY");
  }
}
