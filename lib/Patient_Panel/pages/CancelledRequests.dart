import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbtest/Doctor_Panel/pages/Doctor_Pages/D_Session.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart';
import '../../../Patient_Panel/pages/P_session.dart';

class CancelledRequests extends StatefulWidget {
  CancelledRequests({Key? key}) : super(key: key);

  @override
  State<CancelledRequests> createState() => _CancelledRequestsState();
}

class _CancelledRequestsState extends State<CancelledRequests> {
  final currentUser = FirebaseAuth.instance;
  String uId = '';
  String name = '';
  void getPatientData() async {
    User? PatientID = FirebaseAuth.instance.currentUser!;
    var vari = await FirebaseFirestore.instance
        .collection('Patients')
        .doc(PatientID.uid)
        .get();
    setState(() {
      if (vari.data() != null) {
        uId = vari.data()!['P_id'].toString();
        name = vari.data()!['P_Name'].toString();
      } else {
        uId = "Received Empty Value";
        name = "Received Empty Value";
      }
    });
  }

  String patname = '';
  String patid = '';
  String rstatus = '';
  String ruid = '';
  String message = "";
  String rtime = "";

  void getCancelledData() async {
    User? PatientID = FirebaseAuth.instance.currentUser!;
    var vari = await FirebaseFirestore.instance
        .collection('Requests')
        //.doc(patientID.uid)
        .where('P_id', isEqualTo: PatientID.uid)
        .where('R_Status', isEqualTo: "cancelled")
        .snapshots()
        .listen((vari) {
      if (vari.docs.isNotEmpty) {
        setState(() {
          patid = vari.docs[0]['P_id'].toString();
          patname = vari.docs[0]['P_Name'].toString();
          rstatus = vari.docs[0]['R_Status'].toString();
          ruid = vari.docs[0]['R_UID'].toString();
          rtime = vari.docs[0]['R_Time'].toString();
        });
      } else {
        setState(() {
          // getcommpletedData();
          message = "No Data found";
        });
      }
    });
  }

  @override
  void initState() {
    getPatientData();
    getCancelledData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance
                      .collection('Requests')
                      .where('P_id', isEqualTo: uId)
                      .where('R_Status', isEqualTo: "cancelled")
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.docs.length > 0) {
                        final RequestDocs = snapshot.data!.docs;
                        return Container(
                          width: size.width / 1,
                          height: size.height * 0.7,
                          child: ListView.builder(
                              itemCount: RequestDocs.length,
                              itemBuilder: (context, index) {
                                final DocumentSnapshot documentSnapshot =
                                    RequestDocs[index];
                                return Container(
                                  height: size.height / 5.5,
                                  width: context.screenWidth,
                                  child: Card(
                                    color: context.cardColor,
                                    //margin: const EdgeInsets.all(10),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                    elevation: 4,
                                    child: Column(
                                      children: [
                                        // '$rstatus' == 'Requested'
                                        //     ?
                                        Row(children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Column(
                                                    children: [
                                                      "Doctor Name:"
                                                          .text
                                                          .xl
                                                          .semiBold
                                                          .color(context
                                                              .accentColor)
                                                          .make()
                                                          .px12(),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      "${RequestDocs[index]["D_Name"].toString()}"
                                                          .text
                                                          .xl
                                                          .semiBold
                                                          .color(context
                                                              .accentColor)
                                                          .make()
                                                          .px8()
                                                          .pOnly(top: 4),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Column(
                                                    children: [
                                                      "Request Status:"
                                                          .text
                                                          .xl
                                                          .semiBold
                                                          .color(context
                                                              .accentColor)
                                                          .make()
                                                          .px12(),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      "${RequestDocs[index]["R_Status"].toString()}"
                                                          .text
                                                          .xl
                                                          .semiBold
                                                          .color(context
                                                              .accentColor)
                                                          .make()
                                                          .px8()
                                                          .pOnly(top: 4),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Column(
                                                    children: [
                                                      "Start Time:"
                                                          .text
                                                          .xl
                                                          .semiBold
                                                          .color(context
                                                              .accentColor)
                                                          .make()
                                                          .px12(),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      "${RequestDocs[index]["R_Time"].toString()}"
                                                          .text
                                                          .medium
                                                          //
                                                          .color(context
                                                              .accentColor)
                                                          .make()
                                                          .px8()
                                                          .pOnly(top: 4),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Column(
                                                    children: [
                                                      "End Time:"
                                                          .text
                                                          .xl
                                                          .semiBold
                                                          .color(context
                                                              .accentColor)
                                                          .make()
                                                          .px12(),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      "${RequestDocs[index]["R_EndTime"].toString()}"
                                                          .text
                                                          .medium
                                                          //
                                                          .color(context
                                                              .accentColor)
                                                          .make()
                                                          .px8()
                                                          .pOnly(top: 4),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ])
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        );
                      } else {
                        return Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: EdgeInsets.only(
                                left: size.width / 5,
                                top: size.width / 2,
                              )),
                              Text(
                                "No Cancelled History",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 42, 7, 99)),
                              ),
                            ],
                          ),
                        );
                      }
                    } else {
                      return Container();
                    }
                  })
            ],
          ),
        ),
      ),
    ));
  }
}
