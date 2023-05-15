import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';

import 'package:velocity_x/velocity_x.dart';

class ECGGraph extends StatefulWidget {
  const ECGGraph({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _ECGGraphState createState() => _ECGGraphState();
}

class _ECGGraphState extends State<ECGGraph> {
  int i = 0;
  late List<LiveData> chartData = [];
  late ChartSeriesController _chartSeriesController;
  int timer = 10;
  int index = 0;
  List allECG = [];

  //retrieve data
  _retrieveData() async {
    // Timer.periodic(Duration(seconds: 20), (timer) async {
    index = 0;
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("i8fCoT6I13P9JH0PbiYFQIFVZCF3/ECG");
    var newData = await ref.get();
    setState(() {
      for (var element in newData.children) {
        allECG.add(element);
      }
      plotData();
    });
  }

  plotData() {
    int count = 0;
    if (allECG.isNotEmpty) {
      Timer.periodic(const Duration(microseconds: 100), (timer) {
        if (count < allECG.length) {
          num ECGValue = num.parse(allECG[count].value.toString());
          if (i > 238) {
            setState(() {
              chartData.add(LiveData(i++, ECGValue));
              chartData.removeAt(0);
            });
          } else {
            setState(() {
              chartData.add(LiveData(i++, ECGValue));
            });
          }
          count++;
        } else {
          timer.cancel();
          _retrieveData();
        }
      });
    } else {
      _retrieveData();
    }
  }

  @override
  void initState() {
    super.initState();
    plotData();
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
              "Real Time ECG",
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
                height: size.height / 3,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        "assets/Images/ecg-01.png",
                      ),
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.center),
                ),
              ),
              Text(
                "ECG Peak values represents (xyz)",
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
                height: size.height / 2.1,
                child: SizedBox(
                  // width: size.width,
                  // height: size.height /2,
            child: SfCartesianChart(
                series: <LineSeries<LiveData, int>>[
                  LineSeries<LiveData, int>(
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesController = controller;
                    },
                    dataSource: chartData,
                    color: const Color.fromARGB(255, 89, 13, 254),
                    xValueMapper: (LiveData sales, _) => sales.time,
                    yValueMapper: (LiveData sales, _) => sales.sensorvalue,
                  )
                ],
                primaryXAxis: NumericAxis(
                    majorGridLines: const MajorGridLines(width: 0),
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    interval: 3,
                    title: AxisTitle(text: 'Time (seconds)')),
                primaryYAxis: NumericAxis(
                    axisLine: const AxisLine(width: 0),
                    majorTickLines: const MajorTickLines(size: 0),
                    title: AxisTitle(text: 'Beats Per Minute '))
                    )
                    ),
              ),
            ],
          )
                    
                    ));
  }

  List<LiveData> getChartData(int i, num num1) {
    return <LiveData>[
      LiveData(i, num1),
    ];
  }
}

class LiveData {
  LiveData(this.time, this.sensorvalue);
  final int time;
  final num sensorvalue;
}
