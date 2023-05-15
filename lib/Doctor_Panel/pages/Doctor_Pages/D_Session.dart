import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbtest/Chat_Pages/ChatRoom.dart';
import 'package:dbtest/Doctor_Panel/pages/Doctor_Pages/dochome.dart';
import 'package:dbtest/Patient_Panel/pages/vitals.dart';
import 'package:dbtest/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

class D_Session extends StatefulWidget {
  final DocumentSnapshot<Map<String, dynamic>>? patientInfo;
  const D_Session({Key? key, this.patientInfo}) : super(key: key);

  @override
  State<D_Session> createState() => _D_Session();
}

class _D_Session extends State<D_Session> {
  bool _prescriptionAdded = false;
  String docid = "";
  String docname = "";
  String patId = "";
  String rstatus = "";
  String ruid = "";
  final _formKey2 = GlobalKey<FormState>();
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _medicationController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _frequencyController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  User? DoctorID = FirebaseAuth.instance.currentUser!;

  void _submitForm() async {
    if (_formKey2.currentState!.validate()) {
      // Process the form data here
      String patientName = _patientNameController.text;
      String medication = _medicationController.text;
      String dosage = _dosageController.text;
      String frequency = _frequencyController.text;
      String duration = _durationController.text;

      String doctorID = FirebaseAuth.instance.currentUser!.uid;
      String PatientID = "";
      String PatientName = "";
      var requestDetails = await FirebaseFirestore.instance
          .collection('Requests')
          .where('D_id', isEqualTo: doctorID)
          .where('R_Status', isEqualTo: "Accepted")
          .get();

      PatientID = requestDetails.docs[0]['P_id'].toString();
      PatientName = requestDetails.docs[0]['P_Name'].toString();
      var requestId = requestDetails.docs[0]['R_UID'].toString();
      FirebaseFirestore.instance.collection('Prescriptions').doc().set({
        'D_id': doctorID,
        'P_id': PatientID,
        'P_Name': patientName,
        'Medication': medication,
        'Dosage': dosage,
        'Frequency': frequency,
        'Duration': duration,
        'PrescribedAt': DateTime.now().toString(),
        'RequestID': requestId,
      });

      _prescriptionAdded = true;

      // You can then use this data to do whatever you want, such as
      // send it to an API or store it in a database.
      print('Patient Name: $patientName');
      print('Medication: $medication');
      print('Dosage: $dosage');
      print('Frequency: $frequency');
      print('Duration: $duration');
      print('Doctor ID: $doctorID');
      print('Patient ID: $PatientID');
      print('Prescription Added: $_prescriptionAdded');

      // Close the pop-up form
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Prescrption has been added !"),
        duration: Duration(seconds: 6),
        backgroundColor: Colors.blue,
      ));
    }
  }

  showPrescriptionDialog() {
    return AlertDialog(
        title: const Text('Prescription Form'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _patientNameController,
                  decoration: const InputDecoration(labelText: 'Patient Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the patient name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _medicationController,
                  decoration: const InputDecoration(labelText: 'Medication'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the medication';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _dosageController,
                  decoration: const InputDecoration(labelText: 'Dosage'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the dosage';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _frequencyController,
                  decoration: const InputDecoration(labelText: 'Frequency'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the frequency';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _durationController,
                  decoration: const InputDecoration(
                    labelText: 'Duration',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the duration';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    _submitForm();
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ));
  }

  void getOnGoingData() async {
    var vari = await FirebaseFirestore.instance
        .collection('Requests')
        .where('D_id', isEqualTo: DoctorID!.uid)
        .where('R_Status', isEqualTo: "Accepted")
        .snapshots()
        .listen((vari) {
      setState(() {
        if (vari.docs.isNotEmpty) {
          docid = vari.docs[0]['D_id'].toString();
          patId = vari.docs[0]['P_id'].toString();
          docname = vari.docs[0]['D_Name'].toString();
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
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DocHome(),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    getOnGoingData();
    getUpdatedVitals();
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
                                                  widget.patientInfo!
                                                      .data()!['P_Name'],
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
                                                  "  Samreena Wali  ",
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
                                                    "$temprature",
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(temprature,
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
                                                Text(BPM,
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
                                                Text(oxygen,
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
                                          if (_prescriptionAdded == false) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return showPrescriptionDialog();
                                              },
                                            );
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Prescription Already Added'),
                                                  content: const Text(
                                                      'You have already added prescription for this patient, Start a new session to add new prescription.'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: const Text('OK'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                        child: const Text(
                                          "  Write Prescription  ",
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
                                                chatRoomId: docid + patId,
                                                user1: docid,
                                                user2: patId,
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
                                          },
                                          child: const Text(
                                            "Close",
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
