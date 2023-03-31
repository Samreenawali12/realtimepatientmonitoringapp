import 'dart:async';

import 'package:dbtest/Patient_Panel/Graphs/BPMGraph.dart';
import 'package:dbtest/Patient_Panel/Graphs/Spo2Graph.dart';
import 'package:dbtest/Patient_Panel/Graphs/TempGraph.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import 'combineGraph.dart';

class SensorDataPage extends StatefulWidget {
  SensorDataPage({Key? key}) : super(key: key);

  @override
  State<SensorDataPage> createState() => _SensorDataPageState();
}

class _SensorDataPageState extends State<SensorDataPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Patient Vitals Data",
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: context.accentColor),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  height: size.height / 3,
                  width: size.width / 2.1,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => 
                          Graph(
                            title: 'SensorsGraphs',
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 5,
                      color: Color.fromARGB(255, 255, 255, 255),
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              height: size.height / 6,
                              width: size.width / 3,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                      "assets/Images/temperature.png",
                                    ),
                                    fit: BoxFit.fitWidth,
                                    alignment: Alignment.center),
                              ),
                            ),
                            " Temperature: 98 F\n Check Your Graph"
                                .text
                                .xl
                                .bold
                                .color(Color.fromARGB(255, 39, 3, 97))
                                .make()
                                .p8(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  height: size.height / 3,
                  width: size.width / 2.1,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>BPMGraph(title: 'BPM',),
                          // Graph(
                          //   title: 'SensorsGraphs',
                          // ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 5,
                      color: Color.fromARGB(255, 255, 255, 255),
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              height: size.height / 6,
                              width: size.width / 3,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                      "assets/Images/heart3.webp",
                                    ),
                                    fit: BoxFit.fitWidth,
                                    alignment: Alignment.center),
                              ),
                            ),
                            " HeartRate: 33\n Check Your Graph"
                                .text
                                .xl
                                .bold
                                .color(Color.fromARGB(255, 39, 3, 97))
                                .make()
                                .p8(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(2, 10, 0, 0),
                  height: size.height / 3,
                  width: size.width / 2.1,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Spo2Graph(
                            title: 'Oxygen Level',
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 5,
                      color: Color.fromARGB(255, 255, 255, 255),
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              height: size.height / 6,
                              width: size.width / 3,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                      "assets/Images/spo2.png",
                                    ),
                                    fit: BoxFit.fitWidth,
                                    alignment: Alignment.center),
                              ),
                            ),
                            "Oxygen Level: 56 \n Check your Graph"
                                .text
                                .xl
                                .bold
                                .color(Color.fromARGB(255, 39, 3, 97))
                                .make()
                                .p8(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  height: size.height / 3,
                  width: size.width / 2.1,
                  child: InkWell(
                    onTap: () {
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //     builder: (context) => Spo2Graph(
                      //       title: 'SensorsGraphs',
                      //     ),
                      //   ),
                      // );
                    },
                    child: Card(
                      elevation: 5,
                      color: Color.fromARGB(255, 255, 255, 255),
                      child: Container(
                        child: Column(
                          children: [
                            Container(
                              height: size.height / 6,
                              width: size.width / 2,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                      "assets/Images/ecg.webp",
                                    ),
                                    fit: BoxFit.fitWidth,
                                    alignment: Alignment.center),
                              ),
                            ),
                            " ECG\n See Graph "
                                .text
                                .xl
                                .bold
                                .color(Color.fromARGB(255, 39, 3, 97))
                                .make()
                                .p8(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
