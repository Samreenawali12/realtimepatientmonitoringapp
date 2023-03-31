import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbtest/Doctor_Panel/pages/Doctor_Pages/D_Session.dart';
import 'package:dbtest/Patient_Panel/pages/CancelledRequests.dart';
import 'package:dbtest/Patient_Panel/pages/CompletedRequests.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart';
import '../../../Patient_Panel/pages/P_session.dart';

class P_History extends StatefulWidget {
  P_History({Key? key}) : super(key: key);

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
            title: Text(
              "Requests History",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            bottom: TabBar(
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
          body: TabBarView(children: [
            CompletedRequests(),
            CancelledRequests(),
          ]),
        ));
  }
}
