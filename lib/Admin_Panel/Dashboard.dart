import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../functions/auth.dart';
import '../screens/signInScreen.dart';
import 'Dashboard_Widgets/Dashboard_Home.dart';
import 'Pages/History_Page.dart';

class A_DashboardPage extends StatefulWidget {
  const A_DashboardPage({Key? key}) : super(key: key);
  @override
  State<A_DashboardPage> createState() => _A_DashboardPageState();
}
class _A_DashboardPageState extends State<A_DashboardPage> { 
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _pages = <Widget>[
    A_DashboardHome(),
    Text("Vitals history"),
    A_History(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      drawer: const NavigationDrawer(children: [],),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'History',
          ),
        ],
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped,
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         authFunction().signOut();
             Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => SignInScreen()));
        },
        child: Icon(Icons.logout),
        tooltip: 'Logout',
      ),
    );
  }
}
