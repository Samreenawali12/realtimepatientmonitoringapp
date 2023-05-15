import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:velocity_x/velocity_x.dart';

class PatientPage extends StatefulWidget {
  const PatientPage({Key? key}) : super(key: key);

  @override
  State<PatientPage> createState() => _PatientPageState();
}

class _PatientPageState extends State<PatientPage> {
  var adminEmail = "";
  var adminPassword = "";
  String oldpassword = "";

  void getData() async {
    User? AdminID = FirebaseAuth.instance.currentUser!;
    var vari = await FirebaseFirestore.instance
        .collection('Admin')
        .doc(AdminID.uid)
        .get();

    setState(() {
      if (vari.data() != null) {
        adminEmail = vari.data()!['A_Email'].toString();
        adminPassword = vari.data()!['A_Password'].toString();
      }
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  // text fields' controllers
  final TextEditingController _P_IdController = TextEditingController();
  final TextEditingController _P_AddressController = TextEditingController();
  final TextEditingController _P_EmailController = TextEditingController();
  final TextEditingController _P_PasswordController = TextEditingController();
  final TextEditingController _P_NameController = TextEditingController();
  final TextEditingController _P_PhoneNumberController =
      TextEditingController();
  final TextEditingController _P_CnicController = TextEditingController();
  final TextEditingController _P_GenderController = TextEditingController();
  final TextEditingController _P_AgeController = TextEditingController();

  final CollectionReference _Patients =
      FirebaseFirestore.instance.collection('Patients');
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<void> _create() async {
    String? radiovalue = '';
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                  controller: _P_NameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 4),
                      child: Text(
                        "Gender",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 60, 1, 114)),
                      ),
                    ),
                  ],
                ),
                RadioListTile(
                  title: const Text("Male"),
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
                  title: const Text("Female"),
                  value: "Female",
                  groupValue: radiovalue,
                  onChanged: (value) {
                    setState(() {
                      radiovalue = value!.toString();
                    });
                  },
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
                  controller: _P_EmailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null) {
                      return "This field is required";
                    }
                    return null;
                  },
                  controller: _P_AgeController,
                  decoration: const InputDecoration(labelText: 'Age'),
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
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _P_PasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
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
                  controller: _P_PhoneNumberController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
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
                  controller: _P_CnicController,
                  decoration: const InputDecoration(labelText: 'Cnic'),
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null) {
                      return "This field is required";
                    }
                    return null;
                  },
                  controller: _P_AddressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Create'),
                  onPressed: () async {
                    final num? pID = num.tryParse(_P_IdController.text);
                    final String name = _P_NameController.text;
                    final String gender = _P_GenderController.text;
                    final num? age = num.tryParse(_P_AgeController.text);
                    final String phonenumber = _P_PhoneNumberController.text;
                    final String cnic = _P_CnicController.text;
                    final String email = _P_EmailController.text;
                    final String address = _P_AddressController.text;
                    final num? password =
                        num.tryParse(_P_PasswordController.text);
                    final User? user =
                        (await auth.createUserWithEmailAndPassword(
                      email: email,
                      password: password.toString(),
                    ))
                            .user;
                    String UID = FirebaseAuth.instance.currentUser!.uid;
                    if (user != null) {
                      await _Patients.doc(UID).set({
                        "P_id": UID,
                        "P_Name": name,
                        "P_Gender": gender,
                        "P_Age": age,
                        "P_PhoneNumber": phonenumber,
                        "P_CNIC": cnic,
                        "P_Email": email,
                        "P_Password": password,
                        "P_Address": address,
                        "role": "patient"
                      });
                      _P_PhoneNumberController.text = '';
                      _P_CnicController.text = '';
                      _P_NameController.text = '';
                      _P_EmailController.text = '';
                      _P_AddressController.text = '';
                      _P_PasswordController.text = '';
                      _P_AgeController.text = '';
                      _P_GenderController.text = '';

                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _AuthDelete(String str) async {
    String patpassword = '';
    String patemail = '';
    var v =
        await FirebaseFirestore.instance.collection('Patients').doc(str).get();
    if (v.data() != null) {
      patpassword = v.data()!['P_Password'].toString();
      patemail = v.data()!['P_Email'].toString();
    }
    var result = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: patemail,
      password: patpassword,
    );
    result.user!.delete();
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: adminEmail,
      password: adminPassword,
    );
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    String? radiovalue;
    if (documentSnapshot != null) {
      radiovalue = documentSnapshot['P_Gender'].toString();
      _P_NameController.text = documentSnapshot['P_Name'];
      _P_EmailController.text = documentSnapshot['P_Email'];
      _P_AddressController.text = documentSnapshot['P_Address'];
      _P_PasswordController.text = documentSnapshot['P_Password'].toString();
      _P_AgeController.text = documentSnapshot['P_Age'].toString();
      _P_CnicController.text = documentSnapshot['P_CNIC'].toString();
      _P_PhoneNumberController.text =
          documentSnapshot['P_PhoneNumber'].toString();
      oldpassword = documentSnapshot['P_Password'].toString();
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                  controller: _P_NameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        "Gender",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 60, 1, 114)),
                      ),
                    ),
                  ],
                ),
                RadioListTile(
                  title: const Text("Male"),
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
                  title: const Text("Female"),
                  value: "Female",
                  groupValue: radiovalue,
                  onChanged: (value) {
                    setState(() {
                      radiovalue = value!.toString();
                    });
                  },
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null) {
                      return "This field is required";
                    }
                    return null;
                  },
                  controller: _P_AgeController,
                  decoration: const InputDecoration(labelText: 'Age'),
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
                  controller: _P_PhoneNumberController,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
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
                  controller: _P_CnicController,
                  decoration: const InputDecoration(labelText: 'Cnic'),
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null) {
                      return "This field is required";
                    }
                    return null;
                  },
                  controller: _P_EmailController,
                  decoration: const InputDecoration(labelText: 'Email'),
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
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _P_PasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null) {
                      return "This field is required";
                    }
                    return null;
                  },
                  controller: _P_AddressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    //final num? pID = num.tryParse(_P_IdController.text);
                    final String name = _P_NameController.text;
                    final String? gender = radiovalue;
                    final String password = _P_PasswordController.text;
                    //final String email = _P_EmailController.text;
                    final num? age = num.tryParse(_P_AgeController.text);
                    final String phonenumber = _P_PhoneNumberController.text;
                    final String cnic = _P_CnicController.text;
                    final String address = _P_AddressController.text;

                    if (name != "") {
                      if (oldpassword != _P_PasswordController.text) {
                        var result = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                          email: _P_EmailController.text,
                          password: oldpassword,
                        );
                        result.user!.updatePassword(_P_PasswordController.text);
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                          email: adminEmail,
                          password: adminPassword,
                        );
                      }
                      await _Patients.doc(documentSnapshot!.id).update({
                        "P_Name": name,
                        "P_Gender": gender,
                        "P_Age": age,
                        "P_PhoneNumber": phonenumber,
                        "P_Password": password,
                        "P_CNIC": cnic,
                        "P_Address": address
                      });
                      _P_NameController.text = '';
                      _P_AddressController.text = '';
                      _P_PhoneNumberController.text = '';
                      _P_AgeController.text = '';
                      _P_EmailController.text = '';
                      _P_PasswordController.text = '';
                      _P_GenderController.text = '';
                      _P_CnicController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _delete(String PatientId) async {
    await _Patients.doc(PatientId).delete();
    await _AuthDelete(PatientId);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted an Patient')));
  }

  @override
  Widget build(BuildContext context) {
    //stream builder helps to create persistent connection with firestore DB
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.indigo,
          title:
              "Patient Panel".text.xl4.bold.color(context.accentColor).make(),
        ),
        body: StreamBuilder(
          stream: _Patients.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              final PatientDocs = streamSnapshot.data!.docs;
              return ListView.builder(
                itemCount: PatientDocs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot = PatientDocs[index];
                  return Card(
                    //margin: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22)),
                    //elevation: 5,
                    child: ListTile(
                      title: Text(
                          "Patient ID:  ${PatientDocs[index]["P_id"].toString()}"),
                      subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            "Name:".text.bold.make(),
                            Text(documentSnapshot['P_Name']),
                            "Email:".text.bold.make(),
                            Text(documentSnapshot['P_Email']),
                            "Gender:".text.bold.make(),
                            Text(documentSnapshot['P_Gender'].toString()),
                            "Age:".text.bold.make(),
                            Text(documentSnapshot['P_Age'].toString()),
                            "PhoneNumber:".text.bold.make(),
                            Text(documentSnapshot['P_PhoneNumber'].toString()),
                            "Cnic:".text.bold.make(),
                            Text(documentSnapshot['P_CNIC'].toString()),
                            "Password:".text.bold.make(),
                            Text(documentSnapshot['P_Password'].toString()),
                            "Address:".text.bold.make(),
                            Text(documentSnapshot['P_Address']),
                          ]),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            // Press this button to edit a single product
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _update(documentSnapshot),
                            ),
                            // This icon button is used to delete a single product
                            IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _delete(documentSnapshot.id)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
// Add new product
        floatingActionButton: FloatingActionButton(
          onPressed: () => _create(),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
