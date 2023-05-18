// ignore_for_file: library_private_types_in_public_api, unused_field, avoid_print, unused_local_variable

import 'package:dbtest/Patient_Panel/pages/vitals.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';

import 'package:velocity_x/velocity_x.dart';

class Graph extends StatefulWidget {
  const Graph({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _GraphState createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  Timer? _timer;
  int i = 0;
  late List<LiveData> chartData = [];
  late ChartSeriesController _chartSeriesController;
  //retrieve data
  _retrieveData() async {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      DatabaseReference ref = FirebaseDatabase.instance
          .ref("i8fCoT6I13P9JH0PbiYFQIFVZCF3/Body Temp");
      DatabaseEvent event = await ref.once();
      // Print the data of the snapshot
      print(event.snapshot.value);
      final sensorvalue = event.snapshot.value;
      num mynum = num.parse(event.snapshot.value.toString());
      if (mounted) {
        setState(() {
          if (i >= 10) {
            chartData.add(LiveData(i++, mynum));
            chartData.removeAt(0);
          } else {
            chartData.add(LiveData(i++, mynum));
          }
        });
      }
    });
  }

  @override
  void initState() {
    // chartData = _retrieveData();
    // Timer.periodic(const Duration(seconds: 1), updateDataSource);
    super.initState();
    getUpdatedVitals();
    _retrieveData();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
            title: Text(
              "Real Time Temperature",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: context.accentColor),
            ),
          ),
          body: Column(
            children: [
              Container(
                width: size.width / 2,
                height: size.height / 2.9,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        "assets/Images/temp-01.png",
                      ),
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.center),
                ),
              ),
              Text(
                "${temprature.value}°F",
                style: TextStyle(
                  fontSize: size.height / 40,
                  color: const Color.fromARGB(255, 65, 23, 165),
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  letterSpacing: 4,
                  wordSpacing: 5,
                ),
              ),
              SizedBox(
                width: size.width,
                height: size.height / 2,
                child: SizedBox(
                  width: size.width,
                  height: size.height / 2,
                  child: SfCartesianChart(
                      series: <LineSeries<LiveData, int>>[
                        LineSeries<LiveData, int>(
                          onRendererCreated:
                              (ChartSeriesController controller) {
                            _chartSeriesController = controller;
                          },
                          dataSource: chartData,
                          color: const Color.fromARGB(255, 89, 13, 254),
                          xValueMapper: (LiveData sales, _) => sales.time,
                          yValueMapper: (LiveData sales, _) =>
                              sales.sensorvalue,
                        )
                      ],
                      primaryXAxis: NumericAxis(
                          majorGridLines: const MajorGridLines(width: 0),
                          edgeLabelPlacement: EdgeLabelPlacement.shift,
                          interval: 1,
                          title: AxisTitle(text: 'Time (seconds)')),
                      primaryYAxis: NumericAxis(
                          axisLine: const AxisLine(width: 0),
                          majorTickLines: const MajorTickLines(size: 0),
                          title: AxisTitle(text: 'Sensor Value'))),
                ),
              ),
            ],
          )
          ),
    );
  }

  // List<LiveData> getChartData(int i, num num1) {
  //   return <LiveData>[
  //     LiveData(i, num1),
  //   ];
  // }
}

class LiveData {
  LiveData(this.time, this.sensorvalue);
  final int time;
  final num sensorvalue;
}
