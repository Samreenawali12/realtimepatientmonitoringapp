import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:fyp_app/Login_Panel/login.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../screens/signInScreen.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}
class _ChangePasswordState extends State<ChangePassword> {
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
        MaterialPageRoute(builder: (context) => const SignInScreen()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: context.accentColor,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Update Your Password",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.indigo,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: ListView(children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
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
                  prefixIcon: const Icon(
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
                    borderSide: const BorderSide(width: 0, style: BorderStyle.none),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                keyboardType: TextInputType.visiblePassword,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            MaterialButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    newPassword = newPasswordController.text;
                    //changePassword();
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      changePassword();
                      FirebaseFirestore.instance
                          .collection("Patients")
                          .doc(user.uid)
                          .update({
                        "P_Password": newPassword,
                      });
                    }
                  });
                }
              },
              color: Colors.indigo,
              child: const Text(
                'Change Password',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
