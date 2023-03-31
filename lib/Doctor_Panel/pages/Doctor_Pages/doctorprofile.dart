// ignore_for_file: unnecessary_string_interpolations, avoid_unnecessary_containers

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:velocity_x/velocity_x.dart';

import '../../../theme.dart';
import '../../drawer.dart';

class docProfile extends StatefulWidget {
  @override
  State<docProfile> createState() => _docProfileState();
}

class _docProfileState extends State<docProfile> {
  String pUID = '';
  String name = '';
  String address = '';
  String email = '';
  String password = '';
  String gender = '';
  //String age = '';
  String phonenumber = '';
  String cnic = '';
  String day = '';
  String timing = '';
  String institution = '';
  String specialization = '';
  String education = '';
  String experience = '';
  void getData() async {
    User? user = await FirebaseAuth.instance.currentUser;
    // ignore: deprecated_member_use
    user!.updateProfile(displayName: name);
    var vari = await FirebaseFirestore.instance
        .collection("Doctors")
        .doc(user.uid)
        .get();
    setState(() {
      if (vari.data() != null) {
        pUID = vari.data()!['D_id'].toString();
        name = vari.data()!['D_Name'].toString();
        address = vari.data()!['D_Address'].toString();
        email = vari.data()!['D_Email'].toString();
        password = vari.data()!['D_Password'].toString();
       // age = vari.data()!['D_Age'].toString();
        phonenumber = vari.data()!['D_PhoneNumber'].toString();
        gender = vari.data()!['D_Gender'].toString();
        cnic = vari.data()!['D_Cnic'].toString();
        day = vari.data()!['D_Days'].toString();
        timing = vari.data()!['D_Timings'].toString();
        institution = vari.data()!['D_Institution'].toString();
        specialization = vari.data()!['D_Specialization'].toString();
        education = vari.data()!['D_Education'].toString();
        experience = vari.data()!['D_Experience'].toString();
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "Profile",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: MyTheme.darkbluishColor),
        ),
      ),
      body: // SingleChildScrollView(
          Column(
        //Positioned(top: 0.0),
        children: [
          Container(
            width: size.width / 1, //width of container jitna kam utna zada
            height: size.height / 4,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Image.asset(
                  "assets/Images/defaultdoctor.jpg",
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
              width: size.width / 1,
              height: size.height / 10,
              color: Colors.indigo,
              child: Row(
                //crossAxisAlignment: CrossAxisAlignment.baseline,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "Name",
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    "$name",
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.normal,
                        color: Colors.white),
                  ),
                ],
              )),
          Container(
              color: Colors.white,
              width: size.width / 1,
              height: size.height / 2,
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: <Widget>[
                  Card(
                    elevation: 3,
                    color: Colors.white,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            color: MyTheme.darkbluishColor, width: 3)),
                    child: Container(
                        // color: Colors.blue,
                        child: Column(
                      children: [
                        Image.asset(
                          "assets/Images/heart3.webp",
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        const Text(
                          "Specialization",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text("$specialization",
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.normal)),
                      ],
                    )),
                  ),
                  Card(
                    color: Colors.white,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            color: MyTheme.darkbluishColor, width: 3)),
                    child: Container(
                        //color: MyTheme.creamColor,
                        child: Column(
                      children: [
                        Image.asset(
                          "assets/Images/clock3.webp",
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        const Text(
                          "Timings",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text("$timing",
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.normal)),
                      ],
                    )),
                  ),
                  Card(
                    color: Colors.white,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            color: MyTheme.darkbluishColor, width: 3)),
                    child: Container(
                        width: size.width / 20,
                        //color: MyTheme.creamColor,
                        child: Column(
                          children: [
                            Image.asset(
                              "assets/Images/dayy6.webp",
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                            const Text(
                              "Available From",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text("$day",
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal)),
                          ],
                        )),
                  ),
                  Card(
                    color: Colors.white,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            color: MyTheme.darkbluishColor, width: 3)),
                    child: Container(
                        //color: MyTheme.creamColor,
                        child: Column(
                      children: [
                        Image.asset(
                          "assets/Images/email2.jpg",
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        const Text(
                          "Email",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text("$email",
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.normal)),
                      ],
                    )),
                  ),
                  Card(
                    color: Colors.white,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            color: MyTheme.darkbluishColor, width: 3)),
                    child: Container(
                        //color: MyTheme.creamColor,
                        child: Column(
                      children: [
                        Image.asset(
                          "assets/Images/phone1.jpg",
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        const Text(
                          "Phone Number",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text("$phonenumber",
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.normal)),
                      ],
                    )),
                  ),
                  Card(
                    color: Colors.white,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            color: MyTheme.darkbluishColor, width: 3)),
                    child: Container(
                        //color: MyTheme.creamColor,
                        child: Column(
                      children: [
                        Image.asset(
                          "assets/Images/cnic1.jpg",
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        const Text(
                          "Cnic",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text("$cnic",
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.normal)),
                      ],
                    )),
                  ),
                  Card(
                    color: Colors.white,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            color: MyTheme.darkbluishColor, width: 3)),
                    child: Container(
                        //color: MyTheme.creamColor,
                        child: Column(
                      children: [
                        Image.asset(
                          "assets/Images/address.jpg",
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        const Text(
                          "Address",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text("$address",
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.normal)),
                      ],
                    )),
                  ),
                  Card(
                    color: Colors.white,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            color: MyTheme.darkbluishColor, width: 3)),
                    child: Container(
                        //color: MyTheme.creamColor,
                        child: Column(
                      children: [
                        Image.asset(
                          "assets/Images/gender.webp",
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        const Text(
                          "Gender",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text("$gender",
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.normal)),
                      ],
                    )),
                  ),
                  Card(
                    color: Colors.white,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            color: MyTheme.darkbluishColor, width: 3)),
                    child: Container(
                        //color: MyTheme.creamColor,
                        child: Column(
                      children: [
                        Image.asset(
                          "assets/Images/books1.webp",
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        const Text(
                          "Educations",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text("$education",
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.normal)),
                      ],
                    )),
                  ),
                  Card(
                    color: Colors.white,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            color: MyTheme.darkbluishColor, width: 3)),
                    child: Container(
                        //color: MyTheme.creamColor,
                        child: Column(
                      children: [
                        Image.asset(
                          "assets/Images/education.webp",
                          height: 100,
                          width: 70,
                          fit: BoxFit.cover,
                        ),
                        const Text(
                          "Institute",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text("$institution",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            )),
                      ],
                    )),
                  ),
                  Card(
                    color: Colors.white,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(
                            color: MyTheme.darkbluishColor, width: 3)),
                    child: Container(
                        //color: MyTheme.creamColor,
                        child: Column(
                      children: [
                        Image.asset(
                          "assets/Images/experience2.webp",
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                        const Text(
                          "Experience",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text("$experience",
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.normal)),
                      ],
                    )),
                  ),
                ],
              )),
        ],
      ),
      //   ),
      drawer: const MyDrawer(),
    );
  }
}
