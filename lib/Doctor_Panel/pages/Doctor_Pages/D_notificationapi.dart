import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart';

class DocNotificationApi{
   final currentUser = FirebaseAuth.instance;
  String uId = '';
  String name = '';
  void getDoctorData() async {
    User? DoctorID = FirebaseAuth.instance.currentUser!;
    var vari = await FirebaseFirestore.instance
        .collection('Doctors')
        .doc(DoctorID.uid)
        .get();
   
      if (vari.data() != null) {
        uId = vari.data()!['D_id'].toString();
        name = vari.data()!['D_Name'].toString();
      } else {
        uId = "Received Empty Value";
        name = "Received Empty Value";
      }
   
  }
  String patname = '';
  String patid = '';
  String rstatus = '';
  String ruid = '';
  String rmessage = "";
  void getRequestData() async {
    User? DoctorID = FirebaseAuth.instance.currentUser!;
    var vari = await FirebaseFirestore.instance
        .collection('Requests')
        //.doc(patientID.uid)
        .where('D_id', isEqualTo: DoctorID.uid)
        .where('R_Status', isEqualTo: "Requested")
        //.where('D_id', isEqualTo: )
        .snapshots() // real time page values update
        .listen((vari) {
      
        if (vari.docs.isNotEmpty) {
          patid = vari.docs[0]['P_id'].toString();
          patname = vari.docs[0]['P_Name'].toString();
          rstatus = vari.docs[0]['R_Status'].toString();
          ruid = vari.docs[0]['R_UID'].toString();
          rmessage = "Yes";
        } else if (vari.docs.isEmpty) {
          getAcceptedData();
        }
    });
  }

  String message = "";
  void getAcceptedData() async {
    User? DoctorID = FirebaseAuth.instance.currentUser!;
    var vari = await FirebaseFirestore.instance
        .collection('Requests')
        //.doc(patientID.uid)
        .where('D_id', isEqualTo: DoctorID.uid)
        .where('R_Status', isEqualTo: "Accepted")
        .snapshots() // real time page values update
        .listen((vari) {
      if (vari.docs.isNotEmpty) {
   
          patid = vari.docs[0]['P_id'].toString();
          patname = vari.docs[0]['P_Name'].toString();
          rstatus = vari.docs[0]['R_Status'].toString();
          ruid = vari.docs[0]['R_UID'].toString();
          rmessage = "Yes";
      
      } else {
       
          message = "No Patients Request ";
          rmessage = "No";
     
      }
    });
  }

  String ptoken = '';
  Future<String> sendNotifcation(
      String title, String BODY, String Token) async {
    Map<String, dynamic> body = {
      "to": "$Token",
      "notification": {"body": "$BODY", "title": "$title"},
      "data": {
        "doctorID": "$uId",
        "doctorName": "$name",
      },
    };
    final msg = jsonEncode(body);
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Authorization":
          "key=AAAANLrY2CU:APA91bEdhKkzCHU7IdUSwusI8vc-6kdgaInhCNIqXzGplbBGeEexiIiz1RAV6iCB-vWxDqV0NMHCkcmDt_F9Jz3Ipi65WU5z0za5HFqpoLv2gC48VJErD8_6PZBMaO0xlAhCKm-eJbfN"
    };
    Response response = await post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: headers,
        body: msg);
    print(response.body.toString());
    return response.body;
  }
}