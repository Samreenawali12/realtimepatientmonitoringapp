import 'package:dbtest/Admin_Panel/Pages/Doctor_Page.dart';
import 'package:dbtest/reuseable_widgets/reuseable_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../signInScreen.dart';

class signUpDoc extends StatefulWidget {
  const signUpDoc({Key? key}) : super(key: key);

  @override
  State<signUpDoc> createState() => _signUpDocState();
}

class _signUpDocState extends State<signUpDoc> {
  CollectionReference DocRef = FirebaseFirestore.instance.collection('Doctors');

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _certificationController =
      TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _institutionController = TextEditingController();
  final TextEditingController _specialityController = TextEditingController();
  final TextEditingController _timingController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  String? radiovalue;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Register DOCTORS',
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
                20, MediaQuery.of(context).size.height * 0.09, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null) {
                      return "This filed is required";
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
                      : TextInputType.emailAddress,
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
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null) {
                      return "This field is required";
                    }
                    return null;
                  },
                  controller: _educationController,
                  obscureText: false,
                  enableSuggestions: !false,
                  autocorrect: !false,
                  cursorColor: Colors.indigo,
                  style: TextStyle(color: Colors.indigo.withOpacity(0.9)),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.book_online,
                      color: Colors.indigo,
                    ),
                    labelText: 'Enter Education',
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
                    }
                    return null;
                  },
                  controller: _institutionController,
                  obscureText: false,
                  enableSuggestions: !false,
                  autocorrect: !false,
                  cursorColor: Colors.indigo,
                  style: TextStyle(color: Colors.indigo.withOpacity(0.9)),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.school_outlined,
                      color: Colors.indigo,
                    ),
                    labelText: 'Enter Institution',
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
                    }
                    return null;
                  },
                  controller: _specialityController,
                  obscureText: false,
                  enableSuggestions: !false,
                  autocorrect: !false,
                  cursorColor: Colors.indigo,
                  style: TextStyle(color: Colors.indigo.withOpacity(0.9)),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.military_tech,
                      color: Colors.indigo,
                    ),
                    labelText: 'Enter Specialization',
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
                    }
                    return null;
                  },
                  controller: _experienceController,
                  obscureText: false,
                  enableSuggestions: !false,
                  autocorrect: !false,
                  cursorColor: Colors.indigo,
                  style: TextStyle(color: Colors.indigo.withOpacity(0.9)),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.import_contacts_outlined,
                      color: Colors.indigo,
                    ),
                    labelText: 'your Experience',
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
                    }
                    return null;
                  },
                  controller: _timingController,
                  obscureText: false,
                  enableSuggestions: !false,
                  autocorrect: !false,
                  cursorColor: Colors.indigo,
                  style: TextStyle(color: Colors.indigo.withOpacity(0.9)),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.timer,
                      color: Colors.indigo,
                    ),
                    labelText: 'your Timing',
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
                    }
                    return null;
                  },
                  controller: _daysController,
                  obscureText: false,
                  enableSuggestions: !false,
                  autocorrect: !false,
                  cursorColor: Colors.indigo,
                  style: TextStyle(color: Colors.indigo.withOpacity(0.9)),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.calendar_month,
                      color: Colors.indigo,
                    ),
                    labelText: 'your Days',
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
                    }
                    return null;
                  },
                  controller: _certificationController,
                  obscureText: false,
                  enableSuggestions: !false,
                  autocorrect: !false,
                  cursorColor: Colors.indigo,
                  style: TextStyle(color: Colors.indigo.withOpacity(0.9)),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.pageview_sharp,
                      color: Colors.indigo,
                    ),
                    labelText: 'your Certification',
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
                ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text);
                      String UID = FirebaseAuth.instance.currentUser!.uid;
                      await DocRef.doc(UID)
                          .set({
                            'D_Name': _nameController.text,
                            'D_Email': _emailController.text,
                            'D_Password': _passwordController.text,
                            'D_Gender': radiovalue,
                            'D_Address': _addressController.text,
                            'D_PhoneNumber': _phoneController.text,
                            'D_Cnic': _cnicController.text,
                            'D_Education': _educationController.text,
                            'D_Certification': _certificationController.text,
                            'D_Experience': _experienceController.text,
                            'D_Institution': _institutionController.text,
                            'D_Specialization': _specialityController.text,
                            'D_Timings': _timingController.text,
                            'D_Days': _daysController.text,
                            "D_id": UID,
                            "role": "doctor",
                            "D_Token": "",
                            "status": "Offline"
                          })
                          .then((value) => {
                                print('doctor created'),
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
                                        builder: (context) => DoctorPage()))
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
                                  builder: (context) => DoctorPage(),
                                ),
                              )
                            },
                          );
                    },
                    child: Text("Register"))
                // signInsignUpButton(
                //   context,
                //   false,

                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
