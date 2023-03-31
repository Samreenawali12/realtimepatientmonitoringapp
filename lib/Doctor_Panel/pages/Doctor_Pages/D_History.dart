import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbtest/Doctor_Panel/pages/Doctor_Pages/D_Session.dart';
import 'package:dbtest/Patient_Panel/pages/CancelledRequests.dart';
import 'package:dbtest/Patient_Panel/pages/CompletedRequests.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart';

import 'D_CancelledRequests.dart';
import 'D_CompletedRequests.dart';

class D_History extends StatefulWidget {
  D_History({Key? key}) : super(key: key);

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
            title: Text(
              "Requests Recieved History",
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
            D_CompletedRequests(),
            D_CancelledRequests(),
          ]),
        ));
  }
}
