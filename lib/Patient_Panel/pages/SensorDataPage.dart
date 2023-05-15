import 'dart:async';
import 'package:dbtest/Patient_Panel/Graphs/BPMGraph.dart';
import 'package:dbtest/Patient_Panel/Graphs/ECGGraph.dart';
import 'package:dbtest/Patient_Panel/Graphs/Spo2Graph.dart';
import 'package:dbtest/Patient_Panel/Graphs/TempGraph.dart';
import 'package:dbtest/Patient_Panel/pages/AllDoctors.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:velocity_x/velocity_x.dart';
import 'vitals.dart';
// patient sensor value page
class SensorDataPage extends StatefulWidget {
  const SensorDataPage({Key? key}) : super(key: key);

  @override
  State<SensorDataPage> createState() => _SensorDataPageState();
}

class _SensorDataPageState extends State<SensorDataPage> {
  late Interpreter _interpreter;
  final List<double> _input = [
    double.parse(oxygen),
    double.parse(temprature),
    double.parse(BPM)
  ];
  late List<List<double>> _output;
  bool _isLoaded = false;
  @override
  void initState() {
    getUpdatedVitals();
    _loadModel();
    super.initState();
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

  Future<void> _runInference() async {
    if (_isLoaded) {
      try {
        _output = List.generate(1, (_) => List.filled(1, 0.0));
        _interpreter.run(_input, _output);

        double result = _output[0][0];
        String message = result > 0.5 ? 'Normal' : 'Critical';
        print(message);
        if (message == 'Critical') {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                    'Vitals are NOT in normal range, kindly Consult Doctor'),
                content: Text(message),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const AllDoctorsPage()),
                      );
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Vitals are in normal range'),
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "Patient Vitals Data",
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: context.accentColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width / 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      Container(
                        height: size.height / 3,
                        width: size.width / 1.7,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                "assets/Images/vitals-01.png",
                              ),
                              fit: BoxFit.fitWidth,
                              alignment: Alignment.center),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Temp: $temprature °F \n\n SpO2: $oxygen % \n\n BPM: $BPM bpm",
                        style: TextStyle(
                            fontSize: size.width / 19,
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            color: context.accentColor),
                      ),
                    ],
                  )
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    // padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
                    height: size.height / 4,
                    width: size.width / 2.1,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const Graph(
                              title: 'SensorsGraphs',
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 5,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                height: size.height / 8,
                                width: size.width / 4,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                        "assets/Images/temperature.png",
                                      ),
                                      fit: BoxFit.fitWidth,
                                      alignment: Alignment.center),
                                ),
                              ),
                              " Temperature: ${temprature.toString()} F\n Check Your Graph"
                                  .text
                                  .xl
                                  .bold
                                  .color(const Color.fromARGB(255, 39, 3, 97))
                                  .make()
                                  .p8(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    //padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    height: size.height / 4,
                    width: size.width / 2.1,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const BPMGraph(
                              title: 'BPM',
                            ),
                            // Graph(
                            //   title: 'SensorsGraphs',
                            // ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 5,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                height: size.height / 8,
                                width: size.width / 3,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                        "assets/Images/heart3.webp",
                                      ),
                                      fit: BoxFit.fitWidth,
                                      alignment: Alignment.center),
                                ),
                              ),
                              " HeartRate: ${BPM.toString()}\n Check Your Graph"
                                  .text
                                  .xl
                                  .bold
                                  .color(const Color.fromARGB(255, 39, 3, 97))
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
                  SizedBox(
                    // padding: EdgeInsets.fromLTRB(2, 10, 0, 0),
                    height: size.height / 4,
                    width: size.width / 2.1,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const Spo2Graph(
                              title: 'Oxygen Level',
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 5,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                height: size.height / 7,
                                width: size.width / 3,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                        "assets/Images/spo2.png",
                                      ),
                                      fit: BoxFit.fitWidth,
                                      alignment: Alignment.center),
                                ),
                              ),
                              "Oxygen Level: ${oxygen.toString()} \n Check your Graph"
                                  .text
                                  .xl
                                  .bold
                                  .color(const Color.fromARGB(255, 39, 3, 97))
                                  .make()
                                  .p8(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    // padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    height: size.height / 4,
                    width: size.width / 2.1,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const ECGGraph(title: "ECG")),
                        );
                      },
                      child: Card(
                        elevation: 5,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                height: size.height / 7,
                                width: size.width / 2,
                                decoration: const BoxDecoration(
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
                                  .color(const Color.fromARGB(255, 39, 3, 97))
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
                  "ASK OUR AI BOT ABOUT YOUR CONDITON"
                      .text
                      .xl
                      .bold
                      .color(const Color.fromARGB(255, 39, 3, 97))
                      .make()
                      .p8(),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    height: size.height / 10,
                    width: size.width / 1.1,
                    child: InkWell(
                      onTap: () {
                        _runInference();
                      },
                      child: Card(
                        elevation: 5,
                        color: Colors.indigo,
                        child: Container(
                          child: Column(
                            children: [
                              "ANALYZE YOUR VITALS"
                                  .text
                                  .xl
                                  .bold
                                  .color(const Color.fromARGB(255, 255, 255, 255))
                                  .make()
                                  .p20(),
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
      ),
    );
  }
}
