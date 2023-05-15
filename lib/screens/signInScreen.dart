// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbtest/Admin_Panel/Dashboard.dart';
import 'package:dbtest/constantfiles.dart';
import 'package:dbtest/screens/patient/signup_p.dart';
import 'package:dbtest/reuseable_widgets/reuseable_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Doctor_Panel/pages/Doctor_Pages/dochome.dart';
import '../Doctor_Panel/passwordupdate/forgotpassword.dart';
import '../Patient_Panel/Patient_Dashboard.dart';
import 'doctor/doc_token.dart';
import 'patient/P_Token.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  SharedPreferences? data;
  bool value = false;
  saveValue() async {
    if (value) {
      data = await SharedPreferences.getInstance();
      data!.setString("email", _emailTextController.text.trim());
      data!.setString("password", _passwordTextController.text.trim());
    }
  }

  getrememberpassword() async {
    data = await SharedPreferences.getInstance();
    String? email = data!.getString("email");
    String? password = data!.getString("password");
    if (email != null && password != null) {
      setState(() {
        _emailTextController.text = email;
        _passwordTextController.text = password;
      });
    }
  }

  @override
  void initState() {
    getrememberpassword();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20,
                MediaQuery.of(context).size.height * 0.1,
                20,
                MediaQuery.of(context).size.height * 0.1),
            child: Column(
              children: [
                logoWidget("assets/images_a/login.png"),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null) {
                      return "This field is required";
                    } else if (!RegExp(
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                        .hasMatch(value)) {
                      return "Invalid Email.";
                    }
                    return null;
                  },
                  controller: _emailTextController,
                  obscureText: false,
                  enableSuggestions: !false,
                  autocorrect: !false,
                  cursorColor: Colors.indigo,
                  style: TextStyle(color: Colors.indigo.withOpacity(0.9)),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.mail_outline,
                      color: Colors.indigo,
                    ),
                    labelText: 'Enter Email',
                    labelStyle:
                        TextStyle(color: Colors.indigo.withOpacity(0.9)),
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Colors.indigo.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(width: 0, style: BorderStyle.none),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  keyboardType: false
                      ? TextInputType.visiblePassword
                      : TextInputType.text,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                  // validator: (value) {
                  //   if (value == null) {
                  //     return "This field is required";
                  //   } else if (value.length < 8) {
                  //     return "minimum 8 characters required";
                  //   } else if (!RegExp(
                  //           r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,32}$')
                  //       .hasMatch(value)) {
                  //     return "Enter Valid Password";
                  //   }
                  //   return null;
                  // },
                  controller: _passwordTextController,
                  obscureText: true,
                  enableSuggestions: !false,
                  autocorrect: !false,
                  cursorColor: Colors.indigo,
                  style: TextStyle(color: Colors.indigo.withOpacity(0.9)),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.mail_outline,
                      color: Colors.indigo,
                    ),
                    labelText: 'Enter password',
                    labelStyle:
                        TextStyle(color: Colors.indigo.withOpacity(0.9)),
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Colors.indigo.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(width: 0, style: BorderStyle.none),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: value,
                      onChanged: (value) {
                        setState(() {
                          this.value = value!;
                        });
                      },
                    ),
                    const Text(
                      "Remember Me",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                signInsignUpButton(context, true, () async {
                  await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                    email: _emailTextController.text,
                    password: _passwordTextController.text,
                  )
                      .then((value) async {
                    // print(value);
                    saveValue();
                    final userid =
                        FirebaseAuth.instance.currentUser!.uid.toString();

                    print(userid);

                    var doctors = await FirebaseFirestore.instance
                        .collection('Doctors')
                        .where('D_id', isEqualTo: userid)
                        .get();

                    var patients = await FirebaseFirestore.instance
                        .collection('Patients')
                        .where('P_id', isEqualTo: userid)
                        .get();

                    var admins = await FirebaseFirestore.instance
                        .collection('Admin')
                        .where('A_UID', isEqualTo: userid)
                        .get();

                    if (patients.docs.isNotEmpty) {
                      await FirebaseFirestore.instance
                          .collection("Patients")
                          .doc(userid)
                          .update({
                        "P_Password": _passwordTextController.text,
                        "status": "Online",
                      });
                      pid = patients.docs[0]['P_id'];
                      Pname = patients.docs[0]['P_Name'];

                      PHandleToken().insertToken();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const PatientDashboardPage()));
                    } else if (doctors.docs.isNotEmpty) {
                      await FirebaseFirestore.instance
                          .collection("Doctors")
                          .doc(userid)
                          .update({
                        "D_Password": _passwordTextController.text,
                        "status": "Online",
                      });
                      Did = doctors.docs[0]['D_id'];
                      Dname = doctors.docs[0]['D_Name'];
                      DHandleToken().insertToken();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => const DocHome()));
                    } else if (admins.docs.isNotEmpty) {
                      await FirebaseFirestore.instance
                          .collection("Admin")
                          .doc(userid)
                          .update({"A_Password": _passwordTextController.text});
                      print('Hello Admin');
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const A_DashboardPage()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'User not found in database, please sign up',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
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
                    }
                  }).onError((error, stackTrace) {
                    print("Error: ${error.toString()}");
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Invalid credentials, try again',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
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
                  });
                }),
                signUpOption(),
                const SizedBox(
                  height: 20,
                ),
                forgotpass(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(
            color: Colors.indigo,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const signUpScreen()));
          },
          child: const Text(
            "Sign Up",
            style: TextStyle(
              color: Colors.indigo,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Row forgotpass() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Forgot Password? ",
          style: TextStyle(
            color: Colors.indigo,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ForgotPassword()));
          },
          child: const Text(
            "Click here",
            style: TextStyle(
              color: Colors.indigo,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
