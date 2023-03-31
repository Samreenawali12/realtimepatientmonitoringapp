import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../screens/signInScreen.dart';

class HomeScreenDoc extends StatefulWidget {
  const HomeScreenDoc({Key? key}) : super(key: key);

  @override
  State<HomeScreenDoc> createState() => _HomeScreenDocState();
}

class _HomeScreenDocState extends State<HomeScreenDoc> {
  final currentUser = FirebaseAuth.instance;
  String name = '';
  String address = '';
  String email = '';
  String password = '';
  String role = "";

  void getData() async {
    User? docID = FirebaseAuth.instance.currentUser!;
    var vari = await FirebaseFirestore.instance
        .collection('Doctors')
        .doc(docID.uid)
        .get();

    setState(() {
      if (vari.data() != null) {
        name = vari.data()!['D_Name'].toString();
        address = vari.data()!['D_Address'];
        email = vari.data()!['D_Email'];
        password = vari.data()!['D_Password'];
        role = vari.data()!['role'];
      } else {
        name = "Received Empty Value";
        address = "Received Empty Value";
        email = "Received Empty Value";
        password = "Received Empty Value";
        role = "Received Empty Value";
      }
    });
  }

  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: Column(children: [
              Text(
                'Name: $name',
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                'Address: $address',
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                'Email: $email',
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                'Password: $password',
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                'Role: $role',
                style: const TextStyle(fontSize: 20),
              ),
            ]),
          ),
          Center(
            child: ElevatedButton(
              child: Text("Log Out"),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                print('Signed out');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignInScreen()));
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
          ),
        ],
      ),
    );
  }
}
