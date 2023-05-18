import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbtest/Patient_Panel/pages/patient_profile.dart';
import 'package:dbtest/Patient_Panel/pages/requested_doc.dart';
import 'package:dbtest/Patient_Panel/pages/all_Doctors.dart';
import 'package:dbtest/Patient_Panel/pages/sensorguide.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../pages/sensor_data_page.dart';

class DashboardList extends StatefulWidget {
  const DashboardList({Key? key}) : super(key: key);

  @override
  State<DashboardList> createState() => _DashboardListState();
}

class _DashboardListState extends State<DashboardList> {
  bool isoffline = false;
  // get current user
  final currentUser = FirebaseAuth.instance;
  String name = '';

  void getData() async {
    User? patientID = FirebaseAuth.instance.currentUser!;
    var vari = await FirebaseFirestore.instance
        .collection('Patients')
        .doc(patientID.uid)
        .get();

    setState(() {
      if (vari.data() != null) {
        name = vari.data()!['P_Name'].toString();
      } else {
        name = "Received Empty Value";
      }
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  // @override
  // dispose() {
  //   super.dispose();
  //   internetconnection!.cancel();
  //   //cancel internent connection subscription after you are done
  // }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width / 25),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                "Welcome $name".text.xl4.bold.color(context.accentColor).make(),
              ],
            ),
          ),
          Container(
            padding: Vx.mOnly(right: 20.0, left: 20.0, top: 0.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                "Dashboard".text.xl2.make().pOnly(bottom: 12),
              ],
            ),
          ),
          Container(
            //padding: Vx.mOnly(right: 20.0, left: 20.0, top: 0.0),
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width / 25),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  //  height: size.height / 3.8,
                  width: size.width / 2.2,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PatientProfile(),
                        ),
                      );
                      // getdata();
                    },
                    child: Card(
                      elevation: 5,
                      color: Colors.indigo,
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height *
                                0.20, // 120,
                            width: MediaQuery.of(context).size.width * 0.35,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                    "assets/Images/profile.png",
                                  ),
                                  fit: BoxFit.fitWidth,
                                  alignment: Alignment.center),
                            ),
                          ),
                          " Profile"
                              .text
                              .xl
                              .bold
                              .color(Colors.white)
                              .make()
                              .p8(),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  // height: 200,
                  // width: 175,
                  // height: size.height / 3.8,
                  width: size.width / 2.2,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AllDoctorsPage(),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 5,
                      color: Colors.indigo,
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height *
                                0.20, // 120,
                            width: MediaQuery.of(context).size.width * 0.35,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                    "assets/Images/DoctorImage-01.png",
                                  ),
                                  fit: BoxFit.fitWidth,
                                  alignment: Alignment.center),
                            ),
                          ),
                          " All Doctors"
                              .text
                              .xl
                              .bold
                              .color(Colors.white)
                              .make()
                              .p8(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width / 25),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  // height: 200,
                  // width: 175,
                  // height: size.height / 3.8,
                  width: size.width / 2.2,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SensorDataPage(),
                      ));
                    },
                    child: Card(
                      elevation: 5,
                      color: Colors.indigo,
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height *
                                0.20, // 120,
                            width: MediaQuery.of(context).size.width * 0.35,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                    "assets/Images/vitals2-01.png",
                                  ),
                                  fit: BoxFit.fitWidth,
                                  alignment: Alignment.center),
                            ),
                          ),
                          " Check your Vitals"
                              .text
                              .xl
                              .bold
                              .color(Colors.white)
                              .make()
                              .p8(),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  // height: 200,
                  // width: 175,
                  // height: size.height / 3.8,
                  width: size.width / 2.2,
                  child: InkWell(
                    onTap: () async {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Requesteddoc(),
                      ));
                      // DatabaseReference ref =
                      //     FirebaseDatabase.instance.ref("users/123");
                      // await ref.set({
                      //   "name": "John",
                      //   "age": 18,
                      //   "address": {"line1": "100 Mountain View"}
                      // });
                    },
                    child: Card(
                      elevation: 5,
                      color: Colors.indigo,
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height *
                                0.20, // 120,
                            width: MediaQuery.of(context).size.width * 0.35,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(
                                    "assets/Images/Request2-01.png",
                                  ),
                                  fit: BoxFit.fitWidth,
                                  alignment: Alignment.center),
                            ),
                          ),
                          "Request Doctor"
                              .text
                              .xl
                              .bold
                              .color(Colors.white)
                              .make()
                              .p8(),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width / 25,
                top: MediaQuery.of(context).size.width / 25),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                "Sensor Guide".text.xl2.bold.color(context.accentColor).make(),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            width: size.width / 1,
            height: size.height / 10,
            child: InkWell(
              onTap: () async {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const sensorguide(),
                ));
              },
              child: Card(
                //elevation: 5,
                //  color: Color.fromARGB(255, 255, 255, 255),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "RTHMS Sensor-kit Guide ",
                      style: TextStyle(
                          fontSize: size.width / 20,
                          fontWeight: FontWeight.normal,
                          color: context.accentColor),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget errmsg(String text, bool show) {
  //   //error message widget.
  //   if (show == true) {
  //     //if error is true then show error message box
  //     return Container(
  //       padding: EdgeInsets.all(10.00),
  //       margin: EdgeInsets.only(bottom: 10.00),
  //       color: Color.fromARGB(255, 122, 8, 0),
  //       child: Row(children: [
  //         Container(
  //           margin: EdgeInsets.only(right: 6.00),
  //           child: Icon(Icons.info, color: Colors.white),
  //         ), // icon for error message

  //         Text(text, style: TextStyle(color: Colors.white)),
  //         //show error message text
  //       ]),
  //     );
  //   } else {
  //     return Container();
  //     //if error is false, return empty container.
  //   }
  // }
}
