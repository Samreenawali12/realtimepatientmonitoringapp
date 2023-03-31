import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class D_CancelledRequests extends StatefulWidget {
  D_CancelledRequests({Key? key}) : super(key: key);

  @override
  State<D_CancelledRequests> createState() => _D_CancelledRequestsState();
}

class _D_CancelledRequestsState extends State<D_CancelledRequests> {
  final currentUser = FirebaseAuth.instance;
  String uId = '';
  String name = '';
  void getDoctorData() async {
    User? DoctorID = FirebaseAuth.instance.currentUser!;
    var vari = await FirebaseFirestore.instance
        .collection('Doctors')
        .doc(DoctorID.uid)
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

  String docname = '';
  String docid = '';
  String rstatus = '';
  String ruid = '';
  String message = "";
  String rtime = "";

  void getCancelledData() async {
    User? DoctorID = FirebaseAuth.instance.currentUser!;
    var vari = await FirebaseFirestore.instance
        .collection('Requests')
        //.doc(patientID.uid)
        .where('D_id', isEqualTo: DoctorID.uid)
        .where('R_Status', isEqualTo: "cancelled")
        .snapshots()
        .listen((vari) {
      if (vari.docs.isNotEmpty) {
        setState(() {
          docid = vari.docs[0]['D_id'].toString();
          docname = vari.docs[0]['D_Name'].toString();
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
    getDoctorData();
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
                      .where('D_id', isEqualTo: uId)
                      .where('R_Status', isEqualTo: "cancelled")
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!.docs.length > 0) {
                        final RequestDocs = snapshot.data!.docs;
                        return Container(
                          width: size.width / 1,
                          height: size.height * 0.8,
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
                                                      "${RequestDocs[index]["P_Name"].toString()}"
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
                                top: size.height / 1.5,
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
