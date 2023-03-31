import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../theme.dart';
// import '../../theme.dart';

class DoctorProfilePage extends StatefulWidget {
  final DocumentSnapshot Doctordetails;
  DoctorProfilePage({Key? key, required this.Doctordetails}) : super(key: key);

  @override
  State<DoctorProfilePage> createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Doctor Profile",
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: context.accentColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                padding: EdgeInsets.only(left: 10, right: 10),
                width: context.screenWidth,
                height: size.height / 10,
                color: Colors.indigo,
                child: Row(
                  //crossAxisAlignment: CrossAxisAlignment.baseline,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Name",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      " ${widget.Doctordetails["D_Name"].toString()}",
                      style: TextStyle(
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
                  padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                  children: <Widget>[
                    Card(
                      color: Colors.white,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.indigo, width: 3)),
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
                          Text(
                            "Specialization",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                              "${widget.Doctordetails["D_Specialization"].toString()}",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.normal)),
                        ],
                      )),
                    ),
                    Card(
                      color: Colors.white,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.indigo, width: 3)),
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
                          Text(
                            "Timings",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                              "${widget.Doctordetails["D_Timings"].toString()}",
                              style: TextStyle(
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
                                "assets/Images/days.webp",
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                              Text(
                                "Available From",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                  "${widget.Doctordetails["D_Days"].toString()}",
                                  style: TextStyle(
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
                          Text(
                            "Email",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text("${widget.Doctordetails["D_Email"].toString()}",
                              style: TextStyle(
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
                          Text(
                            "Phone Number",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                              "${widget.Doctordetails["D_PhoneNumber"].toString()}",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.normal)),
                        ],
                      )),
                    ),
                    Card(
                      color: Colors.white,
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.indigo, width: 3)),
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
                          Text(
                            "Cnic",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text("${widget.Doctordetails["D_Cnic"].toString()}",
                              style: TextStyle(
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
                            "assets/Images/adrress.jpg",
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                          Text(
                            "Address",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                              "${widget.Doctordetails["D_Address"].toString()}",
                              style: TextStyle(
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
                          Text(
                            "Gender",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text("${widget.Doctordetails["D_Gender"].toString()}",
                              style: TextStyle(
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
                          Text(
                            "Educations",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                              "${widget.Doctordetails["D_Education"].toString()}",
                              style: TextStyle(
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
                            height: 70,
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                          Text(
                            "Institute",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                              "${widget.Doctordetails["D_Institution"].toString()}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
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
                          Text(
                            "Experience",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                              "${widget.Doctordetails["D_Experience"].toString()}",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.normal)),
                        ],
                      )),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
