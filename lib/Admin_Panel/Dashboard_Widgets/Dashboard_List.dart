import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbtest/Admin_Panel/Pages/History_Page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../Pages/Admin_Page.dart';
import '../Pages/Doctor_Page.dart';
import '../Pages/Patient_Page.dart';

class A_DashboardList extends StatefulWidget {
  const A_DashboardList({Key? key}) : super(key: key);

  @override
  State<A_DashboardList> createState() => _A_DashboardListState();
}

class _A_DashboardListState extends State<A_DashboardList> {
  String name = '';
  String address = '';
  String email = '';
  String password = '';
  void getData() async {
    User? user = await FirebaseAuth.instance.currentUser;
    var vari = await FirebaseFirestore.instance
        .collection("Admin")
        .doc(user?.uid)
        .get();
    setState(() {
      if (vari.data() != null) {
        name = vari.data()!['A_Name'].toString();
        address = vari.data()!['A_Address'].toString();
        email = vari.data()!['A_Email'].toString();
        password = vari.data()!['A_Password'].toString();
      }
    });
  }

  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            height: 130,
            width: double.maxFinite,
            child: Card(
              color: Colors.transparent,
              elevation: 0,
              child: Container(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Color.fromARGB(0, 51, 0, 75),
                      backgroundImage: AssetImage("assets/Images/admin.webp"),
                    ),
                    "$name".text.xl.color(context.accentColor).make().p8(),
                  ],
                ),
              ),
            )),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          height: size.height / 6,
          width: double.maxFinite,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AdminPage(),
                ),
              );
            },
            child: Card(
              elevation: 5,
              color: Colors.indigo,
              child: Container(
                padding: EdgeInsets.only(left: size.width / 15),
                child: Row(
                  children: [
                    Container(
                      height: size.height / 7,
                      width: size.width / 6.5,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              "assets/Images/admin.webp",
                            ),
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.center),
                      ),
                    ),
                    "Admin Details"
                        .text
                        .xl2
                        .bold
                        .color(Colors.white)
                        .make()
                        .p12()
                        .px12(),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          height: size.height / 6,
          width: double.maxFinite,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DoctorPage(),
                ),
              );
            },
            child: Card(
              elevation: 5,
              color: Colors.indigo,
              child: Container(
                padding: EdgeInsets.only(left: size.width / 15),
                child: Row(
                  children: [
                    Container(
                      height: size.height / 7,
                      width: size.width / 6.5,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              "assets/Images/DoctorImage-01.png",
                            ),
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.center),
                      ),
                    ),
                    "Doctor Details"
                        .text
                        .xl2
                        .bold
                        .color(Colors.white)
                        .make()
                        .p12()
                        .px12(),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          height: size.height / 6,
          width: double.maxFinite,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PatientPage(),
                ),
              );
            },
            child: Card(
              elevation: 5,
              color: Colors.indigo,
              child: Container(
                padding: EdgeInsets.only(left: size.width / 15),
                child: Row(
                  children: [
                    Container(
                      height: size.height / 6,
                      width: size.width / 6,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              "assets/Images/PatientImage-01.png",
                            ),
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.center),
                      ),
                    ),
                    "Patient Details"
                        .text
                        .xl2
                        .bold
                        .color(Colors.white)
                        .make()
                        .p12()
                        .p12(),
                  ],
                ),
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          height: size.height / 6,
          width: double.maxFinite,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => A_History(),
                ),
              );
            },
            child: Card(
              elevation: 5,
              color: Colors.indigo,
              child: Container(
                padding: EdgeInsets.only(left: size.width / 15),
                child: Row(
                  children: [
                    Container(
                      height: size.height / 6,
                      width: size.width / 6,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              "assets/Images/adminImage-01.png",
                            ),
                            fit: BoxFit.fitWidth,
                            alignment: Alignment.center),
                      ),
                    ),
                    "History Details"
                        .text
                        .xl2
                        .bold
                        .color(Colors.white)
                        .make()
                        .p12()
                        .px12(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
