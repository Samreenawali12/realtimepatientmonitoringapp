import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbtest/Patient_Panel/Patient_Dashboard.dart';
import 'package:dbtest/Patient_Panel/pages/p_history.dart';
import 'package:dbtest/Patient_Panel/pages/patient_profile.dart';
import 'package:dbtest/Patient_Panel/pages/update_password.dart';
import 'package:dbtest/screens/signInScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../functions/auth.dart';

class PatientNavigationDrawer extends StatefulWidget {
  const PatientNavigationDrawer({Key? key}) : super(key: key);

  @override
  State<PatientNavigationDrawer> createState() =>
      _PatientNavigationDrawerState();
}

class _PatientNavigationDrawerState extends State<PatientNavigationDrawer> {
  // ignore: unused_field
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  String name = '';
  String email = '';
  void getData() async {
    var vari = await FirebaseFirestore.instance
        .collection("Patients")
        .doc(user?.uid)
        .get();
    if (mounted) {
      setState(() {
        const Visibility(visible: true, child: CircularProgressIndicator());
        if (vari.data() != null) {
          name = vari.data()!['P_Name'].toString();
          email = vari.data()!['P_Email'].toString();
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
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
            //Text("$name"),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Material(
      color: Colors.indigo,
      child: InkWell(
        onTap: () {},
        child: Container(
            padding: EdgeInsets.only(
              top: 24 + MediaQuery.of(context).padding.top,
              bottom: 24,
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage("assets/Images/profile.png"),
                ),
                const SizedBox(
                  height: 12,
                ),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            )),
      ),
    );
  }

  Widget buildMenuItems(BuildContext context) {
    return Column(children: [
      ListTile(
        leading: const Icon(Icons.home_outlined),
        title: const Text("Home"),
        onTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const PatientDashboardPage(),
            ),
          );
        },
      ),
      ListTile(
        leading: const Icon(Icons.notifications_outlined),
        title: const Text("ALerts"),
        onTap: () {},
      ),
      ListTile(
        leading: const Icon(Icons.people_rounded),
        title: const Text("Update profile"),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const PatientProfile()));
        },
      ),
      ListTile(
        leading: const Icon(Icons.password_sharp),
        title: const Text("Reset Password"),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ChangePassword(),
            ),
          );
        },
      ),
      ListTile(
        leading: const Icon(Icons.mark_chat_read_outlined),
        title: const Text("Requests History"),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const P_History(),
            ),
          );
        },
      ),
      const Divider(color: Colors.indigo),
      ListTile(
        leading: const Icon(Icons.logout_rounded),
        title: const Text("Logout"),
        onTap: () async {
          FirebaseFirestore.instance
              .collection("Patients")
              .doc(user!.uid)
              .update({
            'status': 'Offline',
            'P_Token': null,
          });
          authFunction().signOut();
          // ignore: avoid_print
          print('Signed out');
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const SignInScreen()));
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
      ),
    ]);
  }
}
