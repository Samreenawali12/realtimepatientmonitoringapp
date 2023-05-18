import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

//patient vitals get from firebase
Rx<String> temprature = '0'.obs;
Rx<String> BPM = '0'.obs;
Rx<String> oxygen = '0'.obs;

getUpdatedVitals() async {
  var user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    DatabaseReference refTemprature =
        FirebaseDatabase.instance.ref("i8fCoT6I13P9JH0PbiYFQIFVZCF3/Body Temp");
    refTemprature.onValue.listen((event) {
      // Handle data here
      DataSnapshot snapshot = event.snapshot;
      print(snapshot.value);
      temprature.value = snapshot.value.toString();
      // ...
    });
    DatabaseReference refBPM =
        FirebaseDatabase.instance.ref("i8fCoT6I13P9JH0PbiYFQIFVZCF3/BPM");
    refBPM.onValue.listen((event) {
      // Handle data here
      DataSnapshot snapshot = event.snapshot;
      print(snapshot.value);
      BPM.value = snapshot.value.toString();
      // ...
    });
    DatabaseReference refSpo2 =
        FirebaseDatabase.instance.ref("i8fCoT6I13P9JH0PbiYFQIFVZCF3/Spo2");
    refSpo2.onValue.listen((event) {
      // Handle data here
      DataSnapshot snapshot = event.snapshot;
      print(snapshot.value);
      oxygen.value = snapshot.value.toString();
      // ...
    });
  }
}
