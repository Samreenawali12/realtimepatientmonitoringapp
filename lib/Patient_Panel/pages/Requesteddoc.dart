
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbtest/Patient_Panel/pages/P_session.dart';
import 'package:dbtest/constantfiles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class Requesteddoc extends StatefulWidget {
  final doctorID;
  const Requesteddoc({Key? key, this.doctorID}) : super(key: key);

  @override
  State<Requesteddoc> createState() => _RequesteddocState();
}

class _RequesteddocState extends State<Requesteddoc> {
  final currentUser = FirebaseAuth.instance;
  // String uId = '';
  // String name = '';
  // void getData() async {
  //   User? patientID = FirebaseAuth.instance.currentUser!;
  //   var vari = await FirebaseFirestore.instance
  //       .collection('Patients')
  //       .doc(patientID.uid)
  //       .get();
  //   setState(() {
  //     if (vari.data() != null) {
  //       uId = vari.data()!['P_id'].toString();
  //       name = vari.data()!['P_Name'].toString();
  //     } else {
  //       name = "Received Empty Value";
  //     }
  //   });
  // }

  String docname = '';
  String docid = '';
  String rstatus = '';
  String ruid = '';
  String rmessage = "";
  void getRequestData() async {
    User? patientID = FirebaseAuth.instance.currentUser!;
    var vari = FirebaseFirestore.instance
        .collection('Requests')
        .where('P_id', isEqualTo: pid)
        .where('R_Status', isEqualTo: "Requested")
        .snapshots() // real time page values update
        .listen((vari) {
      setState(() {
        if (vari.docs.isNotEmpty) {
          docid = vari.docs[0]['D_id'].toString();
          docname = vari.docs[0]['D_Name'].toString();
          rstatus = vari.docs[0]['R_Status'].toString();
          ruid = vari.docs[0]['R_UID'].toString();
          rmessage = "Yes";
        } else if (vari.docs.isEmpty) {
          getAcceptedData();
        }
      });
    });
  }

  String message = "";
  void getAcceptedData() async {
    User? patientID = FirebaseAuth.instance.currentUser!;
    var vari = FirebaseFirestore.instance
        .collection('Requests')
        //.doc(patientID.uid)
        .where('P_id', isEqualTo: patientID.uid)
        .where('R_Status', isEqualTo: "Accepted")
        .snapshots()
        .listen((data) {
      if (data.docs.isNotEmpty) {
        setState(() {
          print(data.docs);
          docid = data.docs[0]['D_id'].toString();
          docname = data.docs[0]['D_Name'].toString();
          rstatus = data.docs[0]['R_Status'].toString();
          ruid = data.docs[0]['R_UID'].toString();
          rmessage = "Accepted";
        });
      } else {
        setState(() {
          message = "No Request Found";
          rmessage = "No";
          rstatus = "cancelled";
        });
      }
    });
  }

  @override
  void initState() {
    getRequestData();
    super.initState();
  }

  final CollectionReference _Request =
      FirebaseFirestore.instance.collection('Requests');
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title:
            "Requested Doctors".text.xl3.bold.color(context.accentColor).make(),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height / 1,
          //color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Card(
                          color: Colors.indigo,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Container(
                                child: Column(
                                  children: [
                                    Image.asset(
                                      "assets/Images/tpatients.png",
                                      height: 100,
                                      width: 150,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                      width: 10,
                                    ),
                                    const Text(
                                      "No of Request",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    FutureBuilder<
                                            QuerySnapshot<
                                                Map<String, dynamic>>>(
                                        future: FirebaseFirestore.instance
                                            .collection('Requests')
                                            .where('P_id', isEqualTo: pid)
                                            .get(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return Text(
                                              snapshot.data!.docs.length
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 20.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            );
                                          } else if (snapshot.hasError) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          } else {
                                            return const CircularProgressIndicator();
                                          }
                                        })
                                  ],
                                ),
                              ),
                            ],
                          )),
                    ),
                    Container(
                      child: Card(
                          color: Colors.indigo,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Container(
                                child: Column(
                                  children: [
                                    Image.asset(
                                      "assets/Images/treatp.png",
                                      height: 100,
                                      width: 150,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                      width: 10,
                                    ),
                                    const Text(
                                      "Requested",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Text(rmessage,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 20)),
                                  ],
                                ),
                              ),
                            ],
                          )),
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
                Column(
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        "Requested Doctor",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                    ]),
                Container(
                  // height: size.height / 3.5,
                  width: context.screenWidth,
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 50),
                  child: Card(
                    color: context.cardColor,
                    //margin: const EdgeInsets.all(10),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    elevation: 4,
                    child: Column(
                      children: [
                        rstatus == "Requested"
                            ? Row(children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    "Patient Name: $Pname"
                                        .text
                                        .xl
                                        .color(context.accentColor)
                                        .make()
                                        .px8()
                                        .pOnly(top: 4, left: 10),
                                    "Doctor Name: $docname"
                                        .text
                                        .xl
                                        .color(context.accentColor)
                                        .make()
                                        .px8()
                                        .pOnly(top: 4, left: 10),
                                    "Request Status: $rstatus"
                                        .text
                                        .xl
                                        .color(context.accentColor)
                                        .make()
                                        .px8()
                                        .pOnly(top: 4, left: 10),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: size.width / 2)),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color.fromARGB(
                                              255, 185, 0, 0),
                                        ),
                                        onPressed: () async {
                                          FirebaseFirestore.instance
                                              .collection("Requests")
                                              .doc(ruid)
                                              .update({
                                            'R_Status': 'cancelled',
                                            'R_EndTime':
                                                DateTime.now().toString(),
                                          });
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const Requesteddoc(),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'Cancel Request',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ])
                            : Container(),
                        rstatus == "Accepted"
                            ? Column(
                                children: [
                                  Row(
                                    children: [
                                      const Padding(
                                          padding: EdgeInsets.only(
                                              left: 20, top: 100)),
                                      Text(
                                        "Your Request has been accepted \n by Dr. $docname",
                                        style: TextStyle(
                                            fontSize: size.width / 20,
                                            fontWeight: FontWeight.bold,
                                            color: const Color.fromARGB(
                                                255, 42, 7, 99)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Column(
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: size.width / 2)),
                                          ElevatedButton(
                                            child: const Text(
                                              'Start session',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            onPressed: () async {
                                              // Navigator.of(context).push(
                                              //   MaterialPageRoute(
                                              //     builder: (context) =>
                                              //         const P_Session(),
                                              //   ),
                                              // );
                                               Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      P_Session(R_ID: ruid),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: size.width / 9)),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color.fromARGB(
                                                  255, 185, 0, 0),
                                              //onPrimary: Colors.black,
                                            ),
                                            onPressed: () async {
                                              FirebaseFirestore.instance
                                                  .collection("Requests")
                                                  .doc(ruid)
                                                  .update({
                                                'R_Status': 'cancelled',
                                                'R_EndTime':
                                                    DateTime.now().toString(),
                                              });
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const Requesteddoc(),
                                                ),
                                              );
                                            },
                                            child: const Text(
                                              'Cancel it',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              )
                            : Container(),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                                padding: EdgeInsets.only(
                              left: size.width / 6,
                              top: size.width / 10,
                            )),

                            //request status print when no request found
                            Text(
                              message,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 42, 7, 99)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
