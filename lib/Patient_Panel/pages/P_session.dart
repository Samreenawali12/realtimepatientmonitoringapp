import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbtest/Chat_Pages/ChatRoom.dart';
import 'package:dbtest/Patient_Panel/Patient_Dashboard.dart';
import 'package:dbtest/Patient_Panel/pages/vitals.dart';
import 'package:dbtest/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

class P_Session extends StatefulWidget {
  final R_ID;
  const P_Session({Key? key, this.R_ID}) : super(key: key);
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
          // Call getPrescriptionData() outside of setState()
          // getPrescriptionData();
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
            builder: (context) => const PatientDashboardPage(),
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

  bool _prescriptionExists = false;

  Future<bool> _requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    return status.isGranted;
  }

  Widget _buildPrescriptionButton() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Prescriptions')
          .where('P_id', isEqualTo: patientID!.uid)
          .where('D_id', isEqualTo: docid)
          .where('RequestID', isEqualTo: widget.R_ID)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Prescription is not added yet');
        }
        if (!snapshot.hasData) {
          return const Text('Prescription is not added yet');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }

        final documents = snapshot.data!.docs;

        if (documents.isNotEmpty) {
          final prescriptionData =
              documents.last.data() as Map<String, dynamic>;
          final medication = prescriptionData['Medication'];
          final dosage = prescriptionData['Dosage'];
          final frequency = prescriptionData['Frequency'];
          final duration = prescriptionData['Duration'];
          final prescribedAt = prescriptionData['PrescribedAt'];

          return ElevatedButton(
            onPressed: () async {
              print('Medication: $medication');
              print('Dosage: $dosage');
              print('Frequency: $frequency');
              print('Duration: $duration');
              print('Prescription exists: $_prescriptionExists');
              print('docid: $docid');
              print('patientID: ${patientID!.uid}');
              print('Date: $prescribedAt');
              if (await _requestStoragePermission()) {
                // Generate PDF document
                final pdf = pw.Document();
                pdf.addPage(pw.MultiPage(
                  pageFormat: PdfPageFormat.a4,
                  build: (pw.Context context) => [
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 30),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Container(
                            padding: const pw.EdgeInsets.only(left: 30),
                            child: pw.Text(
                              'PRESCRIPTION',
                              style: pw.TextStyle(
                                color: PdfColors.blue,
                                fontSize: 30,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                          pw.SizedBox(height: 30),
                          pw.Container(
                            padding: const pw.EdgeInsets.only(left: 30),
                            child: pw.Text(
                              'Doctor Name: $docname',
                              style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                          pw.SizedBox(height: 10),
                          pw.Container(
                            padding: const pw.EdgeInsets.only(left: 30),
                            child: pw.Text(
                              'Patient Name: $patname',
                              style: pw.TextStyle(
                                fontSize: 16,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                          pw.SizedBox(height: 30),
                          pw.Row(
                            children: [
                              pw.Expanded(
                                child: pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Container(
                                      padding:
                                          const pw.EdgeInsets.only(left: 30),
                                      child: pw.Text(
                                        'Medication',
                                        style: pw.TextStyle(
                                          fontSize: 16,
                                          fontWeight: pw.FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    pw.SizedBox(height: 10),
                                    pw.Container(
                                      padding:
                                          const pw.EdgeInsets.only(left: 30),
                                      child: pw.Text(
                                        medication,
                                        style: pw.TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              pw.Expanded(
                                child: pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Container(
                                      padding:
                                          const pw.EdgeInsets.only(left: 30),
                                      child: pw.Text(
                                        'Dosage',
                                        style: pw.TextStyle(
                                          fontSize: 16,
                                          fontWeight: pw.FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    pw.SizedBox(height: 10),
                                    pw.Container(
                                      padding:
                                          const pw.EdgeInsets.only(left: 30),
                                      child: pw.Text(
                                        dosage,
                                        style: pw.TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 30),
                          pw.Row(
                            children: [
                              pw.Expanded(
                                child: pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Container(
                                      padding:
                                          const pw.EdgeInsets.only(left: 30),
                                      child: pw.Text(
                                        'Frequency',
                                        style: pw.TextStyle(
                                          fontSize: 16,
                                          fontWeight: pw.FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    pw.SizedBox(height: 10),
                                    pw.Container(
                                      padding:
                                          const pw.EdgeInsets.only(left: 30),
                                      child: pw.Text(
                                        frequency,
                                        style: pw.TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              pw.Expanded(
                                child: pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Container(
                                      padding:
                                          const pw.EdgeInsets.only(left: 30),
                                      child: pw.Text(
                                        'Duration',
                                        style: pw.TextStyle(
                                          fontSize: 16,
                                          fontWeight: pw.FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    pw.SizedBox(height: 10),
                                    pw.Container(
                                      padding:
                                          const pw.EdgeInsets.only(left: 30),
                                      child: pw.Text(
                                        duration,
                                        style: pw.TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 200),
                          pw.Container(
                            padding: const pw.EdgeInsets.only(left: 300),
                            child: pw.Text(
                              'Prescribed Date' +
                                  ': ' +
                                  prescribedAt.toString(),
                              style: pw.TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ),
                          pw.SizedBox(height: 100),
                          pw.Container(
                            padding: const pw.EdgeInsets.only(left: 30),
                            child: pw.RichText(
                              text: pw.TextSpan(
                                children: [
                                  pw.TextSpan(
                                    text:
                                        "Thank you for using our service. We hope you get well soon.",
                                  ),
                                  pw.TextSpan(
                                    text:
                                        "\n-Team Real Time Patient Monitoring System",
                                    style: pw.TextStyle(
                                        fontStyle: pw.FontStyle.italic),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ));

                // Save PDF document to device storage
                final bytes = await pdf.save();
                final dir = await getApplicationDocumentsDirectory();
                final file = File('${dir.path}/prescription.pdf');
                await file.writeAsBytes(bytes);

                // Open downloaded PDF file
                OpenFile.open(file.path);
              } else {
                // Permission was denied
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Storage permission denied'),
                  ),
                );
              }
            },
            child: const Text(
              'Download Prescription',
              style: TextStyle(fontSize: 17),
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: const Text(
              'No Prescription is prescribed yet, Please wait for the doctor to prescribe the medication.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.red)),
        );
        // Update _prescriptionExists variable
        setState(() {
          _prescriptionExists = false;
        });
      },
    );
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
            iconTheme: const IconThemeData(color: Colors.black),
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
                      padding: const EdgeInsets.all(10.0),
                      child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: size.height / 5,
                              width: size.width / 2.5,
                              child: Column(
                                children: [
                                  const Text(
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
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 40.0,
                                                          top: 20.0,
                                                          bottom: 20.0),
                                                  child: Text(
                                                    "$patname\n\nAge: 21",
                                                    style: TextStyle(
                                                        fontSize:
                                                            size.width / 25,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
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
                                  const Text(
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
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 40.0,
                                                  top: 20.0,
                                                  bottom: 20.0),
                                              child: Text(
                                                "$docname \n\n MBBS ",
                                                style: TextStyle(
                                                    fontSize: size.width / 25,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                          width: 10,
                        ),
                        const Divider(
                          height: 30,
                          color: Color.fromARGB(255, 120, 119, 119),
                        ),
                        Container(
                          child: Column(
                              //mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Align(
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
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 18.0),
                                                    child: Text(
                                                      " temperature: $temprature",
                                                      style: TextStyle(
                                                          fontSize:
                                                              size.width / 22,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
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
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20.0),
                                                    child: Text(
                                                      "Temp Graph",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
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
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 20.0),
                                                  child: Text(
                                                    "Heart Rate: $BPM bpm",
                                                    style: TextStyle(
                                                        fontSize:
                                                            size.width / 22,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
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
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20.0),
                                                    child: Text(
                                                      "BPM Graph",
                                                      style: TextStyle(
                                                          fontSize:
                                                              size.width / 22,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
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
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 20.0),
                                                  child: Text(
                                                    "Oxygen Level: $oxygen %",
                                                    style: TextStyle(
                                                        fontSize:
                                                            size.width / 22,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
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
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20.0),
                                                    child: Text(
                                                      "SpO2 Graph",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
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
                                                const SizedBox(
                                                  height: 10,
                                                  width: 10,
                                                ),
                                                const Align(
                                                  alignment: Alignment.center,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 8.0,
                                                        left: 100.0,
                                                        bottom: 18.0),
                                                    child: Text(
                                                      "See ECG Graph",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                _buildPrescriptionButton(),
                                const Divider(
                                  height: 30,
                                  color: Color.fromARGB(255, 120, 119, 119),
                                ),
                                const Align(
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
                                  child: Container(
                                      //color: MyTheme.creamColor,
                                      child: Column(
                                    children: [
                                      const SizedBox(
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
                                            fontSize: 17,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                        width: 10,
                                      ),
                                    ],
                                  )),
                                ),
                                const Divider(
                                  height: 30,
                                  color: Color.fromARGB(255, 120, 119, 119),
                                ),
                                const Align(
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
                                        const SizedBox(
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
                                            Navigator.pop(context);

                                            // Navigator.pushNamed(context, MyRoutes.DocDashR);
                                          },
                                          child: const Text(
                                            "    Close    ",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
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
