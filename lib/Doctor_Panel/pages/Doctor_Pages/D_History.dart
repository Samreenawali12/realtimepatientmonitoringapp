import 'package:flutter/material.dart';

import 'D_CancelledRequests.dart';
import 'D_CompletedRequests.dart';

class D_History extends StatefulWidget {
  const D_History({Key? key}) : super(key: key);

  @override
  State<D_History> createState() => _D_HistoryState();
}

class _D_HistoryState extends State<D_History> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            // automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            title: const Text(
              "Requests Recieved History",
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
            D_CompletedRequests(),
            D_CancelledRequests(),
          ]),
        ));
  }
}
