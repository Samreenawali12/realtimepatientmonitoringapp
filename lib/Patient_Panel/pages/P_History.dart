
import 'package:dbtest/Patient_Panel/pages/CancelledRequests.dart';
import 'package:dbtest/Patient_Panel/pages/CompletedRequests.dart';
import 'package:flutter/material.dart';

class P_History extends StatefulWidget {
  const P_History({Key? key}) : super(key: key);

  @override
  State<P_History> createState() => _P_HistoryState();
}

class _P_HistoryState extends State<P_History> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            //automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            title: const Text(
              "Requests History",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: "Completed",
                ),
                Tab(
                  text: "Cancelled",
                ),
              ],
            ),
          ),
          body: const TabBarView(children: [
            CompletedRequests(),
            CancelledRequests(),
          ]),
        ));
  }
}
