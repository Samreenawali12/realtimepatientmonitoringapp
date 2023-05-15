import 'package:dbtest/Admin_Panel/Pages/History/AdminCompletedRequests.dart';
import 'package:dbtest/Admin_Panel/Pages/History/AdminCancelledRequests.dart';
import 'package:flutter/material.dart';
import 'History/Admin_Requests.dart';
import 'History/AdminAcceptedRequests.dart';

class A_History extends StatefulWidget {
  const A_History({Key? key}) : super(key: key);

  @override
  State<A_History> createState() => _A_HistoryState();
}

class _A_HistoryState extends State<A_History> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
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
                  text: "Requests",
                ),
                Tab(
                  text: "Accepted",
                ),
                Tab(
                  text: "Cancelled",
                ),
                Tab(
                  text: "Complete",
                ),
              ],
            ),
          ),
          body: const TabBarView(children: [
            AdminRequests(),
            AdminAcceptedRequests(),
            AdminCancelledRequests(),
            AdminCompletedRequests()
          ]),
        ));
  }
}
