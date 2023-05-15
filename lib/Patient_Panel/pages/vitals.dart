import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
  //patient vitals get from firebase
  String temprature = '0';
  String BPM = '0';
  String oxygen = '0';

  getUpdatedVitals() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DatabaseReference refTemprature =
          FirebaseDatabase.instance.ref("${user.uid}/Body Temp");
      refTemprature.onValue.listen((event) {
        // Handle data here
        DataSnapshot snapshot = event.snapshot;
        print(snapshot.value);
        temprature = snapshot.value.toString();
        // ...
      });
      DatabaseReference refBPM =
          FirebaseDatabase.instance.ref("${user.uid}/BPM");
      refBPM.onValue.listen((event) {
        // Handle data here
        DataSnapshot snapshot = event.snapshot;
        print(snapshot.value);
        BPM = snapshot.value.toString();
        // ...
      });
      DatabaseReference refSpo2 =
          FirebaseDatabase.instance.ref("${user.uid}/Spo2");
      refSpo2.onValue.listen((event) {
        // Handle data here
        DataSnapshot snapshot = event.snapshot;
        print(snapshot.value);
        oxygen = snapshot.value.toString();
        // ...
      });
    }
  }

