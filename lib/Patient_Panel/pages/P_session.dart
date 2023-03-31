import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbtest/Chat_Pages/ChatRoom.dart';
import 'package:dbtest/Patient_Panel/Patient_Dashboard.dart';
import 'package:dbtest/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class P_Session extends StatefulWidget {
  const P_Session({Key? key}) : super(key: key);
  @override
  State<P_Session> createState() => _P_Session();
}

class _P_Session extends State<P_Session> {
  String docid = "";
  String docname = "";
  String patname = "";
  String rstatus = "";
  String ruid = "";
  User? patientID = FirebaseAuth.instance.currentUser!;
  void getOnGoingData() async {
    var vari = await FirebaseFirestore.instance
        .collection('Requests')
        //.doc(patientID.uid)
        .where('P_id', isEqualTo: patientID!.uid)
        .where('R_Status', isEqualTo: "Accepted")
        .snapshots()
        .listen((vari) {
      setState(() {
        if (vari.docs.isNotEmpty) {
          docid = vari.docs[0]['D_id'].toString();
          docname = vari.docs[0]['D_Name'].toString();
          patname = vari.docs[0]['P_Name'].toString();
          rstatus = vari.docs[0]['R_Status'].toString();
          ruid = vari.docs[0]['R_UID'].toString();
        } else {
          getcloseData();
        }
      });
    });
  }

  void getcloseData() async {
    User? DoctorID = FirebaseAuth.instance.currentUser!;
    var vari = await FirebaseFirestore.instance
        .collection('Requests')
        .where('R_UID', isEqualTo: ruid)
        .where('R_Status', isNotEqualTo: "Accepted")
        .snapshots()
        .listen((vari) {
      if (vari.docs.isNotEmpty) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => PatientDashboardPage(),
          ),
        );
      }
    });
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2[0].toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  @override
  void initState() {
    getOnGoingData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            title: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Session",
                style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.darkbluishColor),
              ),
            ),
          ),
          body: SingleChildScrollView(
              child: Container(
                  color: Colors.white,
                  child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: size.height / 5,
                              width: size.width / 2.5,
                              child: Column(
                                children: [
                                  Text(
                                    "Patient",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.indigo),
                                  ),
                                  Card(
                                      color: Colors.indigo,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                  width: 10,
                                                ),
                                                Text(
                                                  "  Name:  ",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  "$patname",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                SizedBox(
                                                  height: 7,
                                                  width: 7,
                                                ),
                                                Text(
                                                  "  Age:  ",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  "   21 ",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                  width: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                            Container(
                              height: size.height / 5,
                              width: size.width / 2.5,
                              child: Column(
                                children: [
                                  Text(
                                    "Doctor",
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.indigo),
                                  ),
                                  Card(
                                      color: Colors.indigo,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                  width: 10,
                                                ),
                                                Text(
                                                  "  Name:  ",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  "$docname",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                SizedBox(
                                                  height: 7,
                                                  width: 7,
                                                ),
                                                Text(
                                                  "Assigned Doctor ",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                  width: 10,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                          width: 10,
                        ),
                        Divider(
                          height: 30,
                          color: Color.fromARGB(255, 120, 119, 119),
                        ),
                        Container(
                          child: Column(
                              //mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    "Patients Vitals",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                    ),
                                  ),
                                ),
                                Container(
                                    color: Colors.white,
                                    width: size.width / 1,
                                    height: size.height / 3.2,
                                    child: GridView.count(
                                        crossAxisCount: 2,
                                        crossAxisSpacing: 5,
                                        mainAxisSpacing: 5,
                                        childAspectRatio: (1 / .4),
                                        children: <Widget>[
                                          Container(
                                            child: Card(
                                              // elevation: 3,
                                              color: Colors.white,
                                              clipBehavior: Clip.antiAlias,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  side: BorderSide(
                                                      color: MyTheme
                                                          .darkbluishColor,
                                                      width: 2)),
                                              child: Container(
                                                  // color: Colors.blue,
                                                  child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 10,
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "Temperature:",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text("value",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight
                                                              .normal)),
                                                ],
                                              )),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              //AddRoute here
                                            },
                                            child: Card(
                                              color: Colors.white,
                                              clipBehavior: Clip.antiAlias,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  side: BorderSide(
                                                      color: MyTheme
                                                          .darkbluishColor,
                                                      width: 2)),
                                              child: Container(
                                                  //color: MyTheme.creamColor,
                                                  child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 10,
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "See Graph",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              )),
                                            ),
                                          ),
                                          Card(
                                            elevation: 3,
                                            color: Colors.white,
                                            clipBehavior: Clip.antiAlias,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                side: BorderSide(
                                                    color:
                                                        MyTheme.darkbluishColor,
                                                    width: 2)),
                                            child: Container(
                                                // color: Colors.blue,
                                                child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                  width: 10,
                                                ),
                                                Text(
                                                  "Heart Rate:",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text("value",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal)),
                                              ],
                                            )),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              //AddRoute here
                                            },
                                            child: Card(
                                              color: Colors.white,
                                              clipBehavior: Clip.antiAlias,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  side: BorderSide(
                                                      color: MyTheme
                                                          .darkbluishColor,
                                                      width: 2)),
                                              child: Container(
                                                  //color: MyTheme.creamColor,
                                                  child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 10,
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "See Graph",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              )),
                                            ),
                                          ),
                                          Card(
                                            elevation: 3,
                                            color: Colors.white,
                                            clipBehavior: Clip.antiAlias,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                side: BorderSide(
                                                    color:
                                                        MyTheme.darkbluishColor,
                                                    width: 2)),
                                            child: Container(
                                                // color: Colors.blue,
                                                child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                  width: 10,
                                                ),
                                                Text(
                                                  "Oxygen Level:",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text("value",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.normal)),
                                              ],
                                            )),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              //AddRoute here
                                            },
                                            child: Card(
                                              color: Colors.white,
                                              clipBehavior: Clip.antiAlias,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  side: BorderSide(
                                                      color: MyTheme
                                                          .darkbluishColor,
                                                      width: 2)),
                                              child: Container(
                                                  //color: MyTheme.creamColor,
                                                  child: Column(
                                                children: [
                                                  SizedBox(
                                                    height: 10,
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    "See Graph",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              )),
                                            ),
                                          ),
                                        ])),
                                InkWell(
                                  onTap: () {},
                                  child: Card(
                                    color: Colors.white,
                                    clipBehavior: Clip.antiAlias,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        side: BorderSide(
                                            color: MyTheme.darkbluishColor,
                                            width: 2)),
                                    child: Row(
                                      children: [
                                        Container(
                                          child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                  width: 10,
                                                ),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "                     See ECG Graph",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                  width: 10,
                                                ),
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Divider(
                                  height: 30,
                                  color: Color.fromARGB(255, 120, 119, 119),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    "Have Questions?",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Card(
                                  color: Colors.indigo,
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                          color: MyTheme.darkbluishColor,
                                          width: 2)),
                                  child: Container(
                                      //color: MyTheme.creamColor,
                                      child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                        width: 10,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => ChatRoom(
                                                chatRoomId:
                                                    docid + patientID!.uid,
                                                user1: patientID!.uid,
                                                user2: docid,
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          "  Go To Chat  ",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                        width: 10,
                                      ),
                                    ],
                                  )),
                                ),
                                Divider(
                                  height: 30,
                                  color: Color.fromARGB(255, 120, 119, 119),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    "Close Session?",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {},
                                  child: Card(
                                    color: Colors.indigo,
                                    clipBehavior: Clip.antiAlias,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                        //color: MyTheme.creamColor,
                                        child: Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            FirebaseFirestore.instance
                                                .collection("Requests")
                                                .doc(ruid)
                                                .update({
                                              'R_Status': "completed",
                                              'R_EndTime':
                                                  DateTime.now().toString(),
                                            });

                                            //Navigator.pushNamed(context, MyRoutes.DocDashR);
                                          },
                                          child: const Text(
                                            "    Close    ",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                          width: 10,
                                        ),
                                      ],
                                    )),
                                  ),
                                ),
                              ]),
                        ),
                      ]))))),
    );
  }
}
