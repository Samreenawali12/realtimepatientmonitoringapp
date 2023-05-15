import 'package:flutter/material.dart';
import '../functions/auth.dart';
import '../screens/signInScreen.dart';
import 'Dashboard_Widgets/Dashboard_Home.dart';
import 'Dashboard_Widgets/Navigation_drawer.dart' as myDrawer;
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
  final List<Widget> _pages = <Widget>[
    const A_DashboardHome(),
    const Text("Vitals history"),
    const A_History(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      drawer: const myDrawer.NavigationDrawer(),
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
              context, MaterialPageRoute(builder: (context) => const SignInScreen()));
        },
        tooltip: 'Logout',
        child: const Icon(Icons.logout),
      ),
    );
  }
}
