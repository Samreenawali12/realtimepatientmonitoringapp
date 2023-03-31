import 'package:dbtest/reuseable_widgets/reuseable_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../signInScreen.dart';

class signUpScreen extends StatefulWidget {
  const signUpScreen({Key? key}) : super(key: key);

  @override
  State<signUpScreen> createState() => _signUpScreenState();
}

class _signUpScreenState extends State<signUpScreen> {
  CollectionReference patientRef =
      FirebaseFirestore.instance.collection('Patients');

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  String? radiovalue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.1,
        title: const Text(
          'Sign Up',
          style: TextStyle(
            color: Colors.indigo,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
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
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null) {
                      return "This field is required";
                    } else if (!RegExp(
                            '^([a-zA-Z]{2,}\\s[a-zA-Z]{1,}?-?[a-zA-Z]{2,}\\s?([a-zA-Z]{1,})?)')
                        .hasMatch(value)) {
                      return "Enter Valid Name";
                    }
                    return null;
                  },
                  controller: _nameController,
                  obscureText: false,
                  enableSuggestions: !false,
                  autocorrect: !false,
                  cursorColor: Colors.indigo,
                  style: TextStyle(color: Colors.indigo.withOpacity(0.9)),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person_outlined,
                      color: Colors.indigo,
                    ),
                    labelText: 'Enter Your Name',
                    labelStyle:
                        TextStyle(color: Colors.indigo.withOpacity(0.9)),
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Colors.indigo.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 0, style: BorderStyle.none),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(
                  height: 20,
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
                  controller: _emailController,
                  obscureText: false,
                  enableSuggestions: !false,
                  autocorrect: !false,
                  cursorColor: Colors.indigo,
                  style: TextStyle(color: Colors.indigo.withOpacity(0.9)),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
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
                      borderSide: BorderSide(width: 0, style: BorderStyle.none),
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null) {
                      return "This field is required";
                    } else if (value.length < 8) {
                      return "minimum 8 characters required";
                    } else if (!RegExp(
                            r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,32}$')
                        .hasMatch(value)) {
                      return "Enter Valid Password";
                    }
                    return null;
                  },
                  controller: _passwordController,
                  obscureText: true,
                  enableSuggestions: !false,
                  autocorrect: !false,
                  cursorColor: Colors.indigo,
                  style: TextStyle(color: Colors.indigo.withOpacity(0.9)),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
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
                      borderSide: BorderSide(width: 0, style: BorderStyle.none),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null) {
                      return "This field is required";
                    }
                    return null;
                  },
                  controller: _addressController,
                  obscureText: false,
                  enableSuggestions: !false,
                  autocorrect: !false,
                  cursorColor: Colors.indigo,
                  style: TextStyle(color: Colors.indigo.withOpacity(0.9)),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.home,
                      color: Colors.indigo,
                    ),
                    labelText: 'Enter Address',
                    labelStyle:
                        TextStyle(color: Colors.indigo.withOpacity(0.9)),
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Colors.indigo.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 0, style: BorderStyle.none),
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null) {
                      return "This field is required";
                    } else if (!RegExp(r'^[0][\d]{3}-[\d]{7}$')
                        .hasMatch(value)) {
                      return "invalid phone number";
                    }
                    return null;
                  },
                  controller: _phoneController,
                  obscureText: false,
                  enableSuggestions: !false,
                  autocorrect: !false,
                  cursorColor: Colors.indigo,
                  style: TextStyle(color: Colors.indigo.withOpacity(0.9)),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.phone_android,
                      color: Colors.indigo,
                    ),
                    labelText: 'Enter Phone Number(0304-XXXXXXX)',
                    labelStyle:
                        TextStyle(color: Colors.indigo.withOpacity(0.9)),
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Colors.indigo.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 0, style: BorderStyle.none),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  keyboardType: false
                      ? TextInputType.visiblePassword
                      : TextInputType.number,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null) {
                      return "This field is required";
                    }
                    return null;
                  },
                  controller: _ageController,
                  obscureText: false,
                  enableSuggestions: !false,
                  autocorrect: !false,
                  cursorColor: Colors.indigo,
                  style: TextStyle(color: Colors.indigo.withOpacity(0.9)),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.calendar_today,
                      color: Colors.indigo,
                    ),
                    labelText: 'Enter Age',
                    labelStyle:
                        TextStyle(color: Colors.indigo.withOpacity(0.9)),
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Colors.indigo.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 0, style: BorderStyle.none),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  keyboardType: false
                      ? TextInputType.visiblePassword
                      : TextInputType.number,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null) {
                      return "This field is required";
                    } else if (!RegExp(r'^[0-9]{5}-[0-9]{7}-[0-9]$')
                        .hasMatch(value)) {
                      return "Invalid Cnic";
                    }
                    return null;
                  },
                  controller: _cnicController,
                  obscureText: false,
                  enableSuggestions: !false,
                  autocorrect: !false,
                  cursorColor: Colors.indigo,
                  style: TextStyle(color: Colors.indigo.withOpacity(0.9)),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.card_membership_outlined,
                      color: Colors.indigo,
                    ),
                    labelText: 'Enter CNIC',
                    labelStyle:
                        TextStyle(color: Colors.indigo.withOpacity(0.9)),
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Colors.indigo.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 0, style: BorderStyle.none),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Text(
                        "Gender",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 60, 1, 114)),
                      ),
                    ),
                  ],
                ),
                RadioListTile(
                  title: Text("Male"),
                  value: "Male",
                  groupValue: radiovalue,
                  onChanged: (value) {
                    print(value.toString());
                    setState(() {
                      radiovalue = value!.toString();
                    });
                    print(radiovalue);
                  },
                ),
                RadioListTile(
                  title: Text("Female"),
                  value: "Female",
                  groupValue: radiovalue,
                  onChanged: (value) {
                    setState(() {
                      radiovalue = value!.toString();
                    });
                  },
                ),
                signInsignUpButton(
                  context,
                  false,
                  () async {
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text);
                    String UID = FirebaseAuth.instance.currentUser!.uid;
                    await patientRef
                        .doc(UID)
                        .set({
                          'P_Name': _nameController.text,
                          'P_Email': _emailController.text,
                          'P_Password': _passwordController.text,
                          'P_Address': _addressController.text,
                          'P_PhoneNumber': _phoneController.text,
                          'P_Age': _ageController.text,
                          'P_CNIC': _cnicController.text,
                          'P_Gender': radiovalue,
                          "P_id": UID,
                          "role": "patient",
                          "P_Token": "",
                          "status":"Offline"
                        })
                        .then((value) => {
                              print('user created'),
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Sign Up Successful, Please Login',
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
                              ),
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignInScreen()))
                            })
                        .onError(
                          (error, stackTrace) => {
                            print(
                                'Error: ${error.toString()} StackTrace: ${stackTrace.toString()}'),
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Sign Up Failed, Please Try Again',
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
                            ),
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SignInScreen(),
                              ),
                            )
                          },
                        );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
