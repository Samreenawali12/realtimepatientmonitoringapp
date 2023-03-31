import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbtest/Doctor_Panel/pages/Doctor_Pages/D_Session.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart';
import '../../../../Patient_Panel/pages/P_session.dart';

class AdminRequests extends StatefulWidget {
  AdminRequests({Key? key}) : super(key: key);

  @override
  State<AdminRequests> createState() => _AdminRequestsState();
}

class _AdminRequestsState extends State<AdminRequests> {
  String patname = '';
  String patid = '';
  String docname = '';
  String docid = '';
  String rstatus = '';
  String ruid = '';
  String message = "";
  String rtime = "";
  void getRequestData() async {
    var vari = await FirebaseFirestore.instance
        .collection('Requests')
        .where('R_Status', isEqualTo: "Requested")
        .snapshots()
        .listen((vari) {
      if (vari.docs.isNotEmpty) {
        setState(() {
          patid = vari.docs[0]['P_id'].toString();
          patname = vari.docs[0]['P_Name'].toString();
          docid = vari.docs[0]['D_id'].toString();
          docname = vari.docs[0]['D_Name'].toString();
          rstatus = vari.docs[0]['R_Status'].toString();
          ruid = vari.docs[0]['R_UID'].toString();
          rtime = vari.docs[0]['R_Time'].toString();
        });
      } else {
        setState(() {
          message = "No Request History Found";
        });
      }
    });
  }

  @override
  void initState() {
    getRequestData();
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
                      .where('R_Status', isEqualTo: "Requested")
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.docs.length > 0) {
                        final RequestDocs = snapshot.data!.docs;
                        return Container(
                          width: size.width / 1,
                          height: size.height * 0.9,
                          child: ListView.builder(
                              itemCount: RequestDocs.length,
                              itemBuilder: (context, index) {
                                final DocumentSnapshot documentSnapshot =
                                    RequestDocs[index];
                                return Container(
                                  height: size.height / 4,
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
                                                      "Doctor ID: :"
                                                          .text
                                                          .color(context
                                                              .accentColor)
                                                          .make()
                                                          .px12(),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      "${RequestDocs[index]["D_id"].toString()}"
                                                          .text
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
                                                      "Doctor Name:"
                                                          .text
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
                                                      "Patient ID:"
                                                          .text
                                                          .color(context
                                                              .accentColor)
                                                          .make()
                                                          .px12(),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      "${RequestDocs[index]["P_id"].toString()}"
                                                          .text
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
                                                      "Patient Name:"
                                                          .text
                                                          .semiBold
                                                          .color(context
                                                              .accentColor)
                                                          .make()
                                                          .px12(),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      "${RequestDocs[index]["P_Name"].toString()}"
                                                          .text
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
                                top: size.height / 1.5,
                              )),
                              Text(
                                "No Request History",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 42, 7, 99)),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                    return Container();
                  })
            ],
          ),
        ),
      ),
    ));
  }
}
