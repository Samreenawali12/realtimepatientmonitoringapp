import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbtest/Doctor_Panel/pages/Doctor_Pages/D_Session.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../functions/NotificationAPI.dart';

class docRequest extends StatefulWidget {
  final patientID;
  const docRequest({Key? key, this.patientID}) : super(key: key);

  @override
  State<docRequest> createState() => _docRequestState();
}

class _docRequestState extends State<docRequest> {
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

  String patname = '';
  String patid = '';
  String rstatus = '';
  String ruid = '';
  String rmessage = "";
  void getRequestData() async {
    User? DoctorID = FirebaseAuth.instance.currentUser!;
    var vari = FirebaseFirestore.instance
        .collection('Requests')
        //.doc(patientID.uid)
        .where('D_id', isEqualTo: DoctorID.uid)
        .where('R_Status', isEqualTo: "Requested")
        //.where('D_id', isEqualTo: )
        .snapshots() // real time page values update
        .listen((vari) {
      setState(() {
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
    });
  }

  String message = "";
  void getAcceptedData() async {
    User? DoctorID = FirebaseAuth.instance.currentUser!;
    var vari = FirebaseFirestore.instance
        .collection('Requests')
        //.doc(patientID.uid)
        .where('D_id', isEqualTo: DoctorID.uid)
        .where('R_Status', isEqualTo: "Accepted")
        .snapshots() // real time page values update
        .listen((vari) {
      if (vari.docs.isNotEmpty) {
        setState(() {
          patid = vari.docs[0]['P_id'].toString();
          patname = vari.docs[0]['P_Name'].toString();
          rstatus = vari.docs[0]['R_Status'].toString();
          ruid = vari.docs[0]['R_UID'].toString();
          rmessage = "Yes";
        });
      } else {
        setState(() {
          message = "No Patients Request ";
          rmessage = "No";
        });
      }
    });
  }

  String ptoken = '';
  // Future<String> sendNotifcation(
  //     String title, String BODY, String Token) async {
  //   Map<String, dynamic> body = {
  //     "to": "$Token",
  //     "notification": {"body": "$BODY", "title": "$title"},
  //     "data": {
  //       "doctorID": "$uId",
  //       "doctorName": "$name",
  //     },
  //   };
  //   final msg = jsonEncode(body);
  //   Map<String, String> headers = {
  //     "Content-Type": "application/json",
  //     "Authorization":
  //         "key=AAAANLrY2CU:APA91bEdhKkzCHU7IdUSwusI8vc-6kdgaInhCNIqXzGplbBGeEexiIiz1RAV6iCB-vWxDqV0NMHCkcmDt_F9Jz3Ipi65WU5z0za5HFqpoLv2gC48VJErD8_6PZBMaO0xlAhCKm-eJbfN"
  //   };
  //   Response response = await post(
  //       Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //       headers: headers,
  //       body: msg);
  //   print(response.body.toString());
  //   return response.body;
  // }
  @override
  void initState() {
    getDoctorData();
    getRequestData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "Request",
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: context.accentColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
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
                                            .where('D_id', isEqualTo: uId)
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
                Container(
                  child: Column(
                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text(
                          "Patient's Requests",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      ]),
                ),
                FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    future: FirebaseFirestore.instance
                        .collection('Requests')
                        .where('D_id', isEqualTo: uId)
                        .where('R_Status', isEqualTo: "Requested")
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final RequestDocs = snapshot.data!.docs;
                        return SizedBox(
                          width: size.width / 1,
                          height: size.height * 0.8,
                          child: ListView.builder(
                              itemCount: RequestDocs.length,
                              itemBuilder: (context, index) {
                                final DocumentSnapshot documentSnapshot =
                                    RequestDocs[index];
                                return SizedBox(
                                  height: size.height / 5.5,
                                  width: context.screenWidth,
                                  child: Card(
                                    color: context.cardColor,
                                    //margin: const EdgeInsets.all(10),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: size.width / 50,
                                        vertical: size.width / 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(22),
                                    ),
                                    elevation: 4,
                                    child: Column(
                                      children: [
                                        // '$rstatus' == 'Requested'
                                        //     ?
                                        Row(children: [
                                          Container(
                                            height: 80,
                                            width: 80,
                                            padding: const EdgeInsets.only(
                                                left: 10, top: 10),
                                            // alignment: Alignment.centerLeft,
                                            decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                    "assets/Images/PatientImage-01.png",
                                                  ),
                                                  fit: BoxFit.fitWidth,
                                                  alignment: Alignment.center),
                                            ),
                                          ).pOnly(top: 10, left: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              RequestDocs[index]["P_Name"]
                                                  .toString()
                                                  .text
                                                  .bold
                                                  .xl2
                                                  .color(context.accentColor)
                                                  .make()
                                                  .px8()
                                                  .pOnly(top: 4),
                                              ElevatedButton(
                                                child: const Text(
                                                    'Accept Request'),
                                                onPressed: () async {
                                                  var PatientId =
                                                      RequestDocs[index]["P_id"]
                                                          .toString();
                                                  var data =
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'Requests')
                                                          .where('D_id',
                                                              isEqualTo: uId)
                                                          .where('P_id',
                                                              isEqualTo:
                                                                  PatientId)
                                                          .where('R_Status',
                                                              isEqualTo:
                                                                  "Requested")
                                                          .get();
                                                  if (data.docs.isNotEmpty) {
                                                    //then send push notification
                                                    var vari =
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'Patients')
                                                            .doc(patid)
                                                            .get();
                                                    if (vari
                                                        .data()!
                                                        .isNotEmpty) {
                                                      ptoken = vari
                                                          .data()!['P_Token']
                                                          .toString();
                                                      sendNotifcation(
                                                          title: name,
                                                          message:
                                                              "Doctor has accepted your request\n kindly start your session",
                                                          token: ptoken,
                                                          doctorId: uId,
                                                          doctorName: name);
                                                    }

                                                    User? DoctorID =
                                                        FirebaseAuth.instance
                                                            .currentUser!;
                                                    FirebaseFirestore.instance
                                                        .collection("Requests")
                                                        .doc(ruid)
                                                        .update({
                                                      'R_Status': 'Accepted',
                                                    });
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            D_Session(
                                                          patientInfo: vari,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                              )
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: size.width / 4,
                                                      top: size.width / 14)),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color.fromARGB(
                                                          255, 185, 0, 0),
                                                  //onPrimary: Colors.black,
                                                ),
                                                onPressed: () async {
                                                  FirebaseFirestore.instance
                                                      .collection("Requests")
                                                      .doc(ruid)
                                                      .update({
                                                    'R_Status': 'cancelled',
                                                    'R_EndTime': DateTime.now()
                                                        .toString(),
                                                  });
                                                  var vari =
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'Patients')
                                                          .doc(patid)
                                                          .get();
                                                  if (vari.data()!.isNotEmpty) {
                                                    ptoken = vari
                                                        .data()!['P_Token']
                                                        .toString();
                                                  }
                                                  sendNotifcation(
                                                      title: name,
                                                      message:
                                                          "Doctor has cancelled your request",
                                                      token: ptoken,
                                                      doctorId: uId,
                                                      doctorName: name);

                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const docRequest(),
                                                    ),
                                                  );
                                                },
                                                child: const Text(
                                                  'Decline',
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          )
                                        ])
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        );
                      }
                      return Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                                padding: EdgeInsets.only(
                              left: size.width / 6,
                              top: size.width / 10,
                            )),
                            Text(
                              message,
                              style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 42, 7, 99)),
                            ),
                          ],
                        ),
                      );
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
