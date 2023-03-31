import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'dart:math' as math;

import 'package:velocity_x/velocity_x.dart';

class ECGGraph extends StatefulWidget {
  ECGGraph({Key? key, required this.title}) : super(key: key);
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
      newData.children.forEach((element) {
        allECG.add(element);
      });
      plotData();
    });

    // var event = await ref.get().then((event) {
    //   Timer.periodic(Duration(seconds: 1), (timer) {
    //     if (index <= event.children.length) {
    //       num ECGValue =
    //           num.parse(event.children.elementAt(index).toString());
    //       if (i > 20) {
    //         chartData.add(LiveData(i++, ECGValue));
    //         chartData.removeAt(0);
    //       } else {
    //         chartData.add(LiveData(i++, ECGValue));
    //       }
    //       index++;
    //     } else {
    //       timer.cancel();
    //     }
    //   });
    // });
    // Print the data of the snapshot

    // num ECGValue = num.parse(event.children.elementAt(index).toString());
    // if (i >= 250) {
    //   i = 0;
    //   chartData = [];
    //   chartData.add(LiveData(i++, ECGValue));
    //   //chartData.removeAt(0);
    // } else {
    //   chartData.add(LiveData(i++, ECGValue));
    // }

    // event.children.forEach((element) {
    //   print(element.value.toString());
    //   num mynum = num.parse(element.value.toString());
    //   if (mounted) {
    //     setState(() {
    //       if (i >= 250) {
    //         i = 0;
    //         chartData = [];
    //         chartData.add(LiveData(i++, mynum));
    //         //chartData.removeAt(0);
    //       } else {
    //         chartData.add(LiveData(i++, mynum));
    //       }
    //     });
    //   }
    // });
    //final sensorvalue = event.snapshot.value;
    // });
  }

  plotData() {
    int count = 0;
    if (allECG.length > 0) {
      Timer.periodic(Duration(microseconds: 100), (timer) {
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

    // for (int j = 0; j < allECG.length; j++) {
    //   num ECGValue = num.parse(allECG[j].value.toString());
    //   if (i > 238) {
    //     setState(() {
    //       chartData.add(LiveData(i++, ECGValue));
    //       chartData.removeAt(0);
    //     });
    //   } else {
    //     setState(() {
    //       chartData.add(LiveData(i++, ECGValue));
    //     });
    //   }
    // }
  }

  @override
  void initState() {
    super.initState();
    plotData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("graph"),
            ),
            body: SfCartesianChart(
                series: <LineSeries<LiveData, int>>[
                  LineSeries<LiveData, int>(
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesController = controller;
                    },
                    dataSource: chartData,
                    color: Color.fromARGB(255, 89, 13, 254),
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
                    title: AxisTitle(text: 'Beats Per Minute ')))));
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
