import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbtest/Patient_Panel/pages/p_history.dart';
import 'package:dbtest/Patient_Panel/pages/requested_doc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Dashboard_Widgets/dashboard_list.dart';
import 'Dashboard_Widgets/navigation_drawer.dart';

class PatientDashboardPage extends StatefulWidget {
  const PatientDashboardPage({Key? key}) : super(key: key);
  @override
  State<PatientDashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<PatientDashboardPage>
    with WidgetsBindingObserver {
  // with WidgetsBindingObserver {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //for online anf offline status
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");
  }

  void setStatus(String status) async {
    await _firestore.collection('Patients').doc(_auth.currentUser?.uid).update({
      "status": status,
    });
  }
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     setStatus("Online");
  //   } else {
  //     setStatus("Offline");
  //   }
  // }

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List<Widget> _pages = <Widget>[
    const DashboardList(),
    const Requesteddoc(),
    const P_History(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      drawer: const PatientNavigationDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Requested to',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'History',
          ),
        ],
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped, //bold on click
      ),
      body: Container(
        child: _pages.elementAt(_selectedIndex),
      ),
    );
  }
}
