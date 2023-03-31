// import 'package:flutter/material.dart';
// import 'package:velocity_x/velocity_x.dart';
// // import 'package:draw_graph/draw_graph.dart';
// // import 'package:draw_graph/models/feature.dart';
// class SensorsData extends StatefulWidget {
//   SensorsData({Key? key}) : super(key: key);

//   @override
//   State<SensorsData> createState() => _SensorsDataState();
// }

// class _SensorsDataState extends State<SensorsData> {
//   final List<Feature> features = [
//     Feature(
//       title: "Flutter",
//       color: Colors.blue,
//       data: [1,0.4,0.5],
//     ),
//     // Feature(
//     //   title: "Kotlin",
//     //   color: Colors.black,
//     //   data: [1, 0.8, 0.6, 0.7, 0.3, 0.1],
//     // ),
//     // Feature(
//     //   title: "Java",
//     //   color: Colors.orange,
//     //   data: [0.4, 0.2, 0.9, 0.5, 0.6, 0.4],
//     // ),
//     // Feature(
//     //   title: "React Native",
//     //   color: Colors.red,
//     //   data: [0.5, 0.2, 0, 0.3, 1, 1.3],
//     // ),
//     // Feature(
//     //   title: "Swift",
//     //   color: Colors.green,
//     //   data: [0.25, 0.6, 1, 0.5, 0.8, 1,4],
//     // ),
//   ];
//   @override
//   Widget build(BuildContext context) {
//      final size = MediaQuery.of(context).size;
//     return Scaffold(
//        appBar: AppBar(
//           backgroundColor: Colors.white,
//           iconTheme: IconThemeData(color: Colors.black),
//           title: Text("Sensors Data",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: context.accentColor),),
//         ),
//               body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         crossAxisAlignment: CrossAxisAlignment.center,

//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 64.0),
//             child: Text(
//               "Patient's Data",
//               style: TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: 2,
//               ),
//             ),
//           ),
//           LineGraph(
//             features: features,
//             size: Size(420, 450),
//             labelX: ['Temp', 'BPM', 'SPO2'],
//             labelY: ['100','200','300','400'],
//             showDescription: true,
//             graphColor: Colors.black87,
//           ),
//           SizedBox(
//             height: 20,
//           )
//         ],
//       ),
//     );
//   }
// }