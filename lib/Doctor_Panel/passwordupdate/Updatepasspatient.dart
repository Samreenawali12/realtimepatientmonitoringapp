import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbtest/screens/signInScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:mychatapp/pages/Patient_Pages/signin_p.dart';

class ChangePassPatient extends StatefulWidget {
  ChangePassPatient({Key? key}) : super(key: key);

  @override
  _ChangePassPatientState createState() => _ChangePassPatientState();
}

class _ChangePassPatientState extends State<ChangePassPatient> {
  //String passw = '';
  final _formKey = GlobalKey<FormState>();

  var newPassword = "";

  final newPasswordController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    newPasswordController.dispose();
    super.dispose();
  }

  final currentUser = FirebaseAuth.instance.currentUser;
  changePassword() async {
    try {
      await currentUser!.updatePassword(newPassword);
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            'Your Password has been Changed. Login again !',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reset Password",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.indigo[200],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: ListView(children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: TextFormField(
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
                controller: newPasswordController,
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
                  hintText: 'new password',
                  labelStyle: TextStyle(color: Colors.indigo.withOpacity(0.9)),
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
            ),
            SizedBox(
              height: 20,
            ),
            MaterialButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    newPassword = newPasswordController.text;
                    changePassword();
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      FirebaseFirestore.instance
                          .collection("Doctors")
                          .doc(user.uid)
                          .update({
                        "D_Password": newPassword,
                      });
                    }
                  });
                }
              },
              child: Text(
                'Change Password',
                style: TextStyle(fontSize: 18.0),
              ),
              color: Colors.indigo[200],
            ),
          ]),
        ),
      ),
    );
  }
}
