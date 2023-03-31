import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dbtest/reuseable_widgets/reuseable_widget.dart';
import 'package:dbtest/screens/patient/homeScreen_p.dart';
import 'package:dbtest/screens/patient/signup_p.dart';
import 'package:dbtest/utils/colors_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'doctor/signup_D.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: [
                Text('Who would you like to sign up as?',
                    style: TextStyle(
                        color: Colors.indigo,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 30,
                ),
                PatientAndDoc(
                  context,
                  true,
                  () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const signUpScreen()));
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
