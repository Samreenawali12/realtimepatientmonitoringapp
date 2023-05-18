import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbtest/Admin_Panel/Pages/History_Page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../screens/signInScreen.dart';
import '../Dashboard.dart';
import '../Pages/admin_profile.dart';

class NavigationDrawer extends StatefulWidget {
  const NavigationDrawer({Key? key}) : super(key: key);

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  var adminEmail = "";
  var adminname = "";

  void getData() async {
    User? adminId = FirebaseAuth.instance.currentUser!;
    var vari = await FirebaseFirestore.instance
        .collection('Admin')
        .doc(adminId.uid)
        .get();

    setState(() {
      if (vari.data() != null) {
        adminEmail = vari.data()!['A_Email'].toString();
        adminname = vari.data()!['A_Name'].toString();
      }
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: context.canvasColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }
}

Widget buildHeader(BuildContext context) {
  return Material(
    color: Colors.indigo,
    child: InkWell(
      onTap: () {
        // Navigator.of(context).push(
        //         MaterialPageRoute(
        //           builder: (context) => AdminUserPage(),
        //         ),
        //       );
      },
      child: Container(
          padding: EdgeInsets.only(
            top: 24 + MediaQuery.of(context).padding.top,
            bottom: 24,
          ),
          child: Column(
            children: const [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.transparent,
                backgroundImage: AssetImage("assets/Images/adminImage-01.png"),
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                "ADMIN",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          )),
    ),
  );
}

Widget buildMenuItems(BuildContext context) {
  return Column(
    children: [
      ListTile(
        leading: const Icon(Icons.home_outlined),
        title: const Text("Home"),
        onTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const aDashboardPage(),
            ),
          );
        },
      ),
      ListTile(
        leading: const Icon(Icons.notifications_outlined),
        title: const Text("Alert History"),
        onTap: () {},
      ),
      ListTile(
        leading: const Icon(Icons.people_rounded),
        title: const Text("profile"),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AdminProfile(),
            ),
          );
        },
      ),
      ListTile(
        leading: const Icon(Icons.mark_chat_read_outlined),
        title: const Text("History"),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const A_History(),
            ),
          );
        },
      ),
      const Divider(color: Colors.indigo),
      ListTile(
        leading: const Icon(Icons.logout_rounded),
        title: const Text("Logout"),
        onTap: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const SignInScreen()));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'You have been signed out. See you soon!',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              backgroundColor: Colors.indigo,
              shape: Border(
                top: BorderSide(
                  color: Colors.indigo,
                  width: 2,
                ),
                bottom: BorderSide(
                  color: Colors.indigo,
                  width: 2,
                ),
              ),
            ),
          );
        },
      )
    ],
  );
}
