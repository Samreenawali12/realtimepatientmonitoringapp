import 'dart:convert';
import 'package:dbtest/Patient_Panel/pages/Requesteddoc.dart';
import 'package:dbtest/Patient_Panel/pages/vitals.dart';
import 'package:dbtest/Patient_Panel/pages/doctorProfile.dart';
import 'package:http/http.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:velocity_x/velocity_x.dart';

class AllDoctorsPage extends StatefulWidget {
  const AllDoctorsPage({Key? key}) : super(key: key);
  @override
  State<AllDoctorsPage> createState() => _AllDoctorsPageState();
}

class _AllDoctorsPageState extends State<AllDoctorsPage> {
  late Interpreter _interpreter;
  final List<double> _input = [
    double.parse(oxygen),
    double.parse(temprature),
    double.parse(BPM)
  ];
  late List<List<double>> _output;
  bool _isLoaded = false;

  final currentUser = FirebaseAuth.instance;
  String uId = '';
  String name = '';
  int counter = 0;

  void getData() async {
    User? patientID = FirebaseAuth.instance.currentUser!;
    var vari = await FirebaseFirestore.instance
        .collection('Patients')
        .doc(patientID.uid)
        .get();
    if (mounted) {
      setState(() {
        if (vari.data() != null) {
          uId = vari.data()!['P_id'].toString();
          name = vari.data()!['P_Name'].toString();
        } else {
          name = "Received Empty Value";
        }
      });
    }
  }

  @override
  void initState() {
    getData();
    getUpdatedVitals();
    _loadModel();
    super.initState();
    counter = counter++;
  }

  uploadRequest({var DoctorDocs, String? condition}) async {
    var DoctorId = DoctorDocs["D_id"].toString();
    var data = await FirebaseFirestore.instance
        .collection('Requests')
        .where('P_id', isEqualTo: uId)
        //.where('D_id', isEqualTo: DoctorId)
        .where('R_Status', isEqualTo: "Requested")
        .get();
    if (data.docs.isEmpty) {
      //reciever token
      final recieverfcmToken = DoctorDocs["D_Token"].toString();
      final docId = DoctorDocs["D_id"].toString();
      //send push notification
      await sendNotifcation(
          title: name,
          BODY: "This Patient has Requested for assistance",
          Token: recieverfcmToken,
          con: condition);
      //store request data in DB
      final currentTime = DateTime.now().millisecondsSinceEpoch.toString();
      User? user = FirebaseAuth.instance.currentUser;
      _Request.doc(currentTime).set({
        'P_id': user?.uid,
        'P_Name': name,
        'D_id': DoctorDocs["D_id"].toString(),
        'D_Name': DoctorDocs["D_Name"].toString(),
        'R_Status': 'Requested',
        'R_Time': DateTime.now().toString(),
        'R_UID': currentTime,
        'R_EndTime': 'NULL',
      }).then((value) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const Requesteddoc()),
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sorry, You have already requested',
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          backgroundColor: Colors.indigo,
          shape: Border(
            top: BorderSide(
              color: Colors.indigo,
              width: 2,
            ),
            bottom: BorderSide(
              color: Colors.indigo,
              width: 2,
            ),
          ),
        ),
      );
    }
    //FlutterRingtonePlayer.playNotification();
  }

  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset('mymodel.tflite');
      setState(() {
        _isLoaded = true;
      });
    } catch (e) {
      print('Failed to load model. $e');
    }
  }

  Future<void> _runInference(var DoctorDocs) async {
    if (_isLoaded) {
      try {
        _output = List.generate(1, (_) => List.filled(1, 0.0));
        _interpreter.run(_input, _output);

        double result = _output[0][0];
        String message = result > 0.5 ? 'Normal' : 'Critical';
        print(message);
        if (message == 'Critical') {
          uploadRequest(DoctorDocs: DoctorDocs, condition: 'Critical');
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                    'Vitals are normal, So You cannot send urgent Request'),
                content: Text(message),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      } catch (e) {
        print('Failed to run inference. $e');
      }
    } else {
      print('Interpreter is not initialized');
    }
  }
//api 
  Future<String> sendNotifcation(
      {required String title,
      required String BODY,
      required String Token,
      String? con}) async {
    String message = con ?? "no";
    Map<String, dynamic> body = {
      "to": Token,
      "notification": {"body": BODY, "title": title},
      "data": {
        "patientID": uId,
        "patientName": name,
        "Condition": message,
        "From": "Patient"
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

  final TextEditingController _D_IdController = TextEditingController();
  final TextEditingController _D_AddressController = TextEditingController();
  final TextEditingController _D_EmailController = TextEditingController();
  final TextEditingController _D_PasswordController = TextEditingController();
  final TextEditingController _D_NameController = TextEditingController();
  final TextEditingController _D_PhoneNumberController =
      TextEditingController();
  final TextEditingController _D_CnicController = TextEditingController();
  final TextEditingController _D_GenderController = TextEditingController();
  void getToken() async {
    String ptoken = '';
    User? user = FirebaseAuth.instance.currentUser;
    var vari = await FirebaseFirestore.instance
        .collection("Patients")
        .doc(user?.uid)
        .get();
    if (mounted) {
      setState(() {
        if (vari.data() != null) {
          ptoken = vari.data()!['P_Token'].toString();
        }
      });
    }
  }

  final CollectionReference _Doctors =
      FirebaseFirestore.instance.collection('Doctors');
  final CollectionReference _Request =
      FirebaseFirestore.instance.collection('Requests');
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.indigo,
        title: "All doctors".text.xl4.bold.color(context.accentColor).make(),
      ),
      body: StreamBuilder(
        stream: _Doctors.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            final DoctorDocs = streamSnapshot.data!.docs;
            return ListView.builder(
              itemCount: DoctorDocs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot = DoctorDocs[index];
                String docId = DoctorDocs[index]['D_id'].toString();
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => DoctorProfilePage(
                          Doctordetails: DoctorDocs[index],
                        ),
                      ),
                    );
                  },
                  child: SizedBox(
                    // height: size.height / 5,
                    width: context.screenWidth,
                    child: Card(
                      color: context.cardColor,
                      //margin: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      elevation: 4,
                      child: Column(
                        children: [
                          Row(children: [
                            Container(
                              height: 80,
                              width: 80,
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              // alignment: Alignment.centerLeft,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                      "assets/Images/defaultdoctor.jpg",
                                    ),
                                    fit: BoxFit.fitWidth,
                                    alignment: Alignment.center),
                              ),
                            ).pOnly(top: 10, left: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DoctorDocs[index]["D_Name"].toString()
                                    .text
                                    .bold
                                    .xl2
                                    .color(context.accentColor)
                                    .make()
                                    .px8()
                                    .pOnly(top: 4),
                                DoctorDocs[index]["D_Email"].toString()
                                    .text
                                    .bold
                                    .xl
                                    .textStyle(context.captionStyle)
                                    .make()
                                    .px8(),
                                DoctorDocs[index]["status"].toString()
                                    .text
                                    .bold
                                    .size(16)
                                    .color(const Color.fromARGB(255, 73, 7, 180))
                                    .make()
                                    .px8(),
                                Row(
                                  children: [
                                    ElevatedButton(
                                        child: const Text('Send Request'),
                                        onPressed: () async {
                                          uploadRequest(
                                              DoctorDocs: DoctorDocs[index]);
                                        }),
                                    ElevatedButton(
                                        onPressed: () async {
                                          _runInference(DoctorDocs[index]);
                                        },
                                        child: const Text("Urgent Request"))
                                  ],
                                ),
                              ],
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
