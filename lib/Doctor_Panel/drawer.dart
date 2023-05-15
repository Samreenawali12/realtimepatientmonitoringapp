// ignore_for_file: non_constant_identifier_names, avoid_unnecessary_containers, unnecessary_string_interpolations, unnecessary_const

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbtest/Doctor_Panel/pages/Doctor_Pages/dochome.dart';
import 'package:dbtest/Doctor_Panel/pages/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../screens/signInScreen.dart';
import '../theme.dart';

//import '../utils/routes.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  //final currentUser = FirebaseAuth.instance;
  User? docID = FirebaseAuth.instance.currentUser!;
  String name = '';
  String email = '';
  void getData() async {
    var vari = await FirebaseFirestore.instance
        .collection('Doctors')
        .doc(docID!.uid)
        .get();

    setState(() {
      if (vari.data() != null) {
        name = vari.data()!['D_Name'].toString();
        email = vari.data()!['D_Email'];
      } else {
        name = "Received Empty Value";
        email = "Received Empty Value";
      }
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  void HomeFunc(BuildContext context) async {
    Navigator.pushNamed(context, MyRoutes.DocHomeR);
  }

  void ProfFunc(BuildContext context) async {
    Navigator.pushNamed(context, MyRoutes.DocProfileR);
  }

  void UpdFunc(BuildContext context) async {
    Navigator.pushNamed(context, MyRoutes.DocUpdateR);
  }

  @override
  // void moveToLogin(BuildContext context) async {
  // Navigator.pushNamed(context, MyRoutes.LoginRoute);
  // }

  Widget build(BuildContext context) {
    return Drawer(
      // backgroundColor: Colors.white,

      child: Container(
        //color: Colors.white,
        child: ListView(
          children: [
            DrawerHeader(
              padding: EdgeInsets.zero,
              child: UserAccountsDrawerHeader(
                margin: EdgeInsets.zero,
                decoration: const BoxDecoration(color: Colors.indigo),
                accountName: Text("$name",
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.white)),
                accountEmail: Text("$email",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Colors.white)),
                //currentAccountPicture: Image.network(imageURL),
                currentAccountPicture: const CircleAvatar(
                  backgroundImage:
                      const AssetImage("assets/Images/defaultdoctor.jpg"),
                ),
              ),
            ),
            ListTile(
              onTap: () {
                HomeFunc(context);
              },
              leading: Icon(
                CupertinoIcons.home,
                color: MyTheme.darkbluishColor,
              ),
              title: Text(
                "Home",
                textScaleFactor: 1.2,
                style: TextStyle(
                  color: MyTheme.darkbluishColor,
                ),
              ),
            ),
            ListTile(
              onTap: () {
                ProfFunc(context);
              },
              leading: Icon(
                CupertinoIcons.profile_circled,
                color: MyTheme.darkbluishColor,
              ),
              title: Text(
                "Requests",
                textScaleFactor: 1.2,
                style: TextStyle(color: MyTheme.darkbluishColor),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const DocHome()));
              },
              leading: Icon(
                CupertinoIcons.graph_circle_fill,
                color: MyTheme.darkbluishColor,
              ),
              title: Text(
                "Dashboard",
                textScaleFactor: 1.2,
                style: TextStyle(color: MyTheme.darkbluishColor),
              ),
            ),
            ListTile(
              onTap: () {
                UpdFunc(context);
              },
              leading: Icon(
                CupertinoIcons.doc_chart_fill,
                color: MyTheme.darkbluishColor,
              ),
              title: Text(
                "Update Profile",
                textScaleFactor: 1.2,
                style: TextStyle(color: MyTheme.darkbluishColor),
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, MyRoutes.Updatepass);
              },
              leading: Icon(
                Icons.password_sharp,
                color: MyTheme.darkbluishColor,
              ),
              title: Text(
                "Reset Password",
                textScaleFactor: 1.2,
                style: TextStyle(color: MyTheme.darkbluishColor),
              ),
            ),
            const Divider(
              height: 30,
              color: Colors.black,
            ),
            ListTile(
              onTap: () {
                FirebaseFirestore.instance
                    .collection("Doctors")
                    .doc(docID!.uid)
                    .update({
                  'status': 'Offline',
                  'D_Token': null,
                });
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignInScreen()));
              },
              leading: Icon(
                Icons.logout,
                color: MyTheme.darkbluishColor,
              ),
              title: Text(
                "Logout",
                textScaleFactor: 1.2,
                style: TextStyle(color: MyTheme.darkbluishColor),
              ),
            )
          ],
        ),
      ),
    );
  }
}
