// ignore_for_file: non_constant_identifier_names, unused_local_variable, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import '../../Doctor_Panel/pages/Doctor_Pages/D_Session.dart';
import '../../Doctor_Panel/pages/Doctor_Pages/docRequest.dart';
import '../../functions/NotificationAPI.dart';

class Alarm extends StatefulWidget {
  final RemoteMessage message;
  const Alarm({super.key, required this.message});

  @override
  State<Alarm> createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  final currentUser = FirebaseAuth.instance;
  String uId = '';
  String name = '';

  void getDoctorData() async {
    User? doctorID = FirebaseAuth.instance.currentUser!;
    var vari = await FirebaseFirestore.instance
        .collection('Doctors')
        .doc(doctorID.uid)
        .get();
    setState(() {
      if (vari.data() != null) {
        uId = vari.data()!['D_id'].toString();
        name = vari.data()!['D_Name'].toString();
      } else {
        uId = "Received Empty Value";
        name = "Received Empty Value";
      }
    });
  }

  @override
  void initState() {
    getDoctorData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(children: [
        Row(
          children: [
            Container(
              alignment: Alignment.topCenter,
              child: const MyStatefulWidget(),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              height: Size.height / 13,
              width: Size.width / 1,
              padding: EdgeInsets.only(left: Size.width / 7),
              child: const Text(
                "EMERGENCY ALERT",
                style: TextStyle(
                    color: Color.fromARGB(255, 32, 1, 134),
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            )
          ],
        ),
        Row(
          children: [
            Container(
              height: Size.height / 13,
              width: Size.width / 1,
              padding: EdgeInsets.only(left: Size.width / 7),
              child: const Text(
                "Emergency Request recieved!\nPatient's Vitals : Not Normal",
                style: TextStyle(
                    color: Color.fromARGB(255, 62, 61, 66),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            )
          ],
        ),
        Row(
          children: [
            Container(
              height: Size.height / 2.7,
              width: Size.width / 1,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      "assets/Images/announce.png",
                    ),
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.center),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 80),
                  child: ElevatedButton(
                      onPressed: () async {
                        FlutterRingtonePlayer.stop();
                        var patientId =
                            widget.message.data['patientID'].toString();
                        var data = await FirebaseFirestore.instance
                            .collection('Requests')
                            .where('D_id',
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser!.uid)
                            .where('P_id', isEqualTo: patientId)
                            .where('R_Status', isEqualTo: "Requested")
                            .get();
                        if (data.docs.isNotEmpty) {
                          //then send push notification
                          var vari = await FirebaseFirestore.instance
                              .collection('Patients')
                              .doc(patientId)
                              .get();
                          if (vari.data()!.isNotEmpty) {
                            var ptoken = vari.data()!['P_Token'].toString();
                            sendNotifcation(
                                title: name,
                                message:
                                    "Doctor has accepted your request\n kindly start your session",
                                token: ptoken,
                                doctorId: uId,
                                doctorName: name);
                          }

                          User? DoctorID = FirebaseAuth.instance.currentUser!;
                          FirebaseFirestore.instance
                              .collection("Requests")
                              .doc(data.docs[0]['R_UID'].toString())
                              .update({
                            'R_Status': 'Accepted',
                          });
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => D_Session(
                                patientInfo: vari,
                              ),
                            ),
                          );
                        }
                      },

                      //  () {
                      //   FlutterRingtonePlayer.stop();
                      //   Navigator.of(context).pushReplacement(
                      //     MaterialPageRoute(
                      //       builder: (context) => D_Session(),
                      //     ),
                      //   );
                      // },
                      child: const Text(
                        "Accept",
                        style: TextStyle(fontSize: 20),
                      )),
                ),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        FlutterRingtonePlayer.stop();
                        var patientId =
                            widget.message.data['patientID'].toString();
                        var data = await FirebaseFirestore.instance
                            .collection('Requests')
                            .where('D_id',
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser!.uid)
                            .where('P_id', isEqualTo: patientId)
                            .where('R_Status', isEqualTo: "Requested")
                            .get();
                        if (data.docs.isNotEmpty) {
                          FirebaseFirestore.instance
                              .collection("Requests")
                              .doc(data.docs[0]['R_UID'].toString())
                              .update({
                            'R_Status': 'cancelled',
                            'R_EndTime': DateTime.now().toString(),
                          });
                        }
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const docRequest(),
                          ),
                        );
                        // FirebaseFirestore.instance
                        //     .collection("Requests")
                        //     .doc(ruid)
                        //     .update({
                        //   'R_Status': 'cancelled',
                        //   'R_EndTime': DateTime.now().toString(),
                        // });
                        // Navigator.of(context).pushReplacement(
                        //   MaterialPageRoute(
                        //     builder: (context) => docRequest(),
                        //   ),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 185, 0, 0),
                      ),
                      child: const Text(
                        "Decline",
                        style: TextStyle(fontSize: 20),
                      )),
                )
              ],
            )
          ],
        )
      ]),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(1.5, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticIn,
  ));
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FlutterRingtonePlayer.playAlarm();
  }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final Size = MediaQuery.of(context).size;
    return SlideTransition(
      position: _offsetAnimation,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Container(
          height: Size.height / 4,
          width: Size.width / 1.4,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "assets/Images/alert.png",
                ),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter),
          ),
        ),
      ),
    );
  }
}
