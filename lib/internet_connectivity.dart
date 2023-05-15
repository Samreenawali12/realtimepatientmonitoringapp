// import 'dart:async';

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// class InternetConnectivity extends StatefulWidget {
//   InternetConnectivity({Key? key}) : super(key: key);

//   @override
//   State<InternetConnectivity> createState() => _InternetConnectivityState();
// }

// class _InternetConnectivityState extends State<InternetConnectivity> {
//   //set variable for Connectivity subscription listiner
//   StreamSubscription? internetconnection;
//   bool isoffline = false;
//    void initState() {
//     internetconnection = Connectivity()
//         .onConnectivityChanged
//         .listen((ConnectivityResult result) {
//       // whenevery connection status is changed.
//       if (result == ConnectivityResult.none) {
//         //there is no any connection
//         setState(() {
//           isoffline = true;
//         });
//       } else if (result == ConnectivityResult.mobile) {
//         //connection is mobile data network
//         setState(() {
//           isoffline = false;
//         });
//       } else if (result == ConnectivityResult.wifi) {
//         //connection is from wifi
//         setState(() {
//           isoffline = false;
//         });
//       }
//     });
//     super.initState();
//   }

//   @override
//   dispose() {
//     super.dispose();
//     internetconnection!.cancel();
//     //cancel internent connection subscription after you are done
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
//   Widget errmsg(String text, bool show) {
//     //error message widget.
//     if (show == true) {
//       //if error is true then show error message box
//       return Container(
//         padding: EdgeInsets.all(10.00),
//         margin: EdgeInsets.only(bottom: 10.00),
//         color: Color.fromARGB(255, 122, 8, 0),
//         child: Row(children: [
//           Container(
//             margin: EdgeInsets.only(right: 6.00),
//             child: Icon(Icons.info, color: Colors.white),
//           ), // icon for error message

//           Text(text, style: TextStyle(color: Colors.white)),
//           //show error message text
//         ]),
//       );
//     } else {
//       return Container();
//       //if error is false, return empty container.
//     }
//   }
// }