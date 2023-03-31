import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';
import 'dart:math' as math;

class Spo2Graph extends StatefulWidget {
  Spo2Graph({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _Spo2GraphState createState() => _Spo2GraphState();
}

class _Spo2GraphState extends State<Spo2Graph> {
  int i = 0;
  late List<LiveData> chartData = [];
  late ChartSeriesController _chartSeriesController;
  int timer=10;
  //retrieve data
  _retrieveData() async {
    Timer.periodic(Duration(seconds: 1), (timer) async {
      DatabaseReference ref =
          FirebaseDatabase.instance.ref("i8fCoT6I13P9JH0PbiYFQIFVZCF3/Spo2");
      DatabaseEvent event = await ref.once();
      // Print the data of the snapshot
      print(event.snapshot.value);
      final sensorvalue = event.snapshot.value;
      num mynum = num.parse(event.snapshot.value.toString());
      if(mounted){
         setState(() {
        if(i>=20)
        {
          chartData.add(LiveData(i++, mynum));
          chartData.removeAt(0);

        }
        else
        {
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
    _retrieveData();
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
                    interval: 1,
                    title: AxisTitle(text: 'Time (seconds)')),
                primaryYAxis: NumericAxis(
                    axisLine: const AxisLine(width: 0),
                    majorTickLines: const MajorTickLines(size: 0),
                    title: AxisTitle(text: 'Oxygen Level')))));
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
