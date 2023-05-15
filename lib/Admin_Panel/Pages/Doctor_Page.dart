import 'package:dbtest/screens/doctor/signup_D.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:velocity_x/velocity_x.dart';

class DoctorPage extends StatefulWidget {
  const DoctorPage({Key? key}) : super(key: key);

  @override
  State<DoctorPage> createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  String oldpassword = "";
  // text fields' controllers
  final TextEditingController _D_IdController = TextEditingController();
  final TextEditingController _D_AddressController = TextEditingController();
  final TextEditingController _D_EmailController = TextEditingController();
  final TextEditingController _D_PasswordController = TextEditingController();
  final TextEditingController _D_NameController = TextEditingController();
  final TextEditingController _D_PhoneNumberController =
      TextEditingController();
  final TextEditingController _D_CnicController = TextEditingController();
  final TextEditingController _D_GenderController = TextEditingController();
  final TextEditingController _D_ExperienceController = TextEditingController();
  final TextEditingController _D_EducationController = TextEditingController();
  final TextEditingController _D_TimingController = TextEditingController();
  final TextEditingController _D_DaysController = TextEditingController();
  final TextEditingController _D_InstituteController = TextEditingController();
  final TextEditingController _D_SpecializationController =
      TextEditingController();
  final TextEditingController _D_CertificationController =
      TextEditingController();
  final CollectionReference _Doctors =
      FirebaseFirestore.instance.collection('Doctors');
  FirebaseAuth auth = FirebaseAuth.instance;

  var adminEmail = "";
  var adminPassword = "";

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

  Future<void> _AuthDelete(String str) async {
    String docpassword = '';
    String docemail = '';
    var v =
        await FirebaseFirestore.instance.collection('Doctors').doc(str).get();
    if (v.data() != null) {
      docpassword = v.data()!['D_Password'].toString();
      docemail = v.data()!['D_Email'].toString();
    }
    var result = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: docemail,
      password: docpassword,
    );
    result.user!.delete();
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: adminEmail,
      password: adminPassword,
    );
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    String? radiovalue = '';
    if (documentSnapshot != null) {
      _D_GenderController.text = documentSnapshot['D_Gender'].toString();
      _D_NameController.text = documentSnapshot['D_Name'];
      _D_EmailController.text = documentSnapshot['D_Email'];
      _D_AddressController.text = documentSnapshot['D_Address'];
      _D_PasswordController.text = documentSnapshot['D_Password'].toString();
      oldpassword = documentSnapshot['D_Password'].toString();
      _D_ExperienceController.text = documentSnapshot['D_Experience'];
      _D_TimingController.text = documentSnapshot['D_Timings'];
      _D_DaysController.text = documentSnapshot['D_Days'];
      _D_EducationController.text = documentSnapshot['D_Education'].toString();
      _D_InstituteController.text = documentSnapshot['D_Institution'];
      _D_SpecializationController.text =
          documentSnapshot['D_Specialization'].toString();
      _D_CertificationController.text =
          documentSnapshot['D_Certification'].toString();
      _D_CnicController.text = documentSnapshot['D_Cnic'].toString();
      _D_PhoneNumberController.text =
          documentSnapshot['D_PhoneNumber'].toString();
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return SingleChildScrollView(
            child: Padding(
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
                    controller: _D_NameController,
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
                      } else if (!RegExp(r'^[0][\d]{3}-[\d]{7}$')
                          .hasMatch(value)) {
                        return "invalid phone number";
                      }
                      return null;
                    },
                    controller: _D_PhoneNumberController,
                    decoration:
                        const InputDecoration(labelText: 'Phone Number'),
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
                    controller: _D_CnicController,
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
                    controller: _D_AddressController,
                    decoration: const InputDecoration(labelText: 'Address'),
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null) {
                        return "This field is required";
                      }
                      return null;
                    },
                    controller: _D_DaysController,
                    decoration: const InputDecoration(labelText: 'Days'),
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null) {
                        return "This field is required";
                      }
                      return null;
                    },
                    controller: _D_TimingController,
                    decoration: const InputDecoration(labelText: 'Timings'),
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null) {
                        return "This field is required";
                      }
                      return null;
                    },
                    controller: _D_EducationController,
                    decoration: const InputDecoration(labelText: 'Education'),
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null) {
                        return "This field is required";
                      }
                      return null;
                    },
                    controller: _D_InstituteController,
                    decoration: const InputDecoration(labelText: 'Institution'),
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
                    controller: _D_PasswordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null) {
                        return "This field is required";
                      }
                      return null;
                    },
                    controller: _D_SpecializationController,
                    decoration:
                        const InputDecoration(labelText: 'Specialization'),
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null) {
                        return "This field is required";
                      }
                      return null;
                    },
                    controller: _D_CertificationController,
                    decoration: const InputDecoration(labelText: 'Experience'),
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null) {
                        return "This field is required";
                      }
                      return null;
                    },
                    controller: _D_CertificationController,
                    decoration:
                        const InputDecoration(labelText: 'Certification'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: const Text('Update'),
                    onPressed: () async {
                      final String name = _D_NameController.text;
                      final String gender = _D_GenderController.text;
                      final num? phonenumber =
                          num.tryParse(_D_PhoneNumberController.text);
                      final num? cnic = num.tryParse(_D_CnicController.text);
                      final String email = _D_EmailController.text;
                      final String address = _D_AddressController.text;
                      final num? password =
                          num.tryParse(_D_PasswordController.text);
                      final String specialization =
                          _D_SpecializationController.text;
                      final String timings = _D_TimingController.text;
                      final String experience = _D_ExperienceController.text;
                      final String institute = _D_InstituteController.text;
                      final String education = _D_EducationController.text;
                      final String days = _D_DaysController.text;
                      final String certification =
                          _D_CertificationController.text;
                      //String UID = FirebaseAuth.instance.currentUser!.uid;
                      if (password != null ||
                          email != "" ||
                          address != "" ||
                          name != "") {
                        if (oldpassword != _D_PasswordController.text) {
                          var result = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: _D_EmailController.text,
                            password: oldpassword,
                          );
                          result.user!
                              .updatePassword(_D_PasswordController.text);
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: adminEmail,
                            password: adminPassword,
                          );
                        }
                        await _Doctors.doc(documentSnapshot!.id).update({
                          "D_Name": name,
                          "D_Gender": gender,
                          "D_PhoneNumber": phonenumber,
                          "D_Cnic": cnic,
                          "D_Specialization": specialization,
                          "D_Experience": experience,
                          "D_Education": education,
                          "D_Days": days,
                          "D_Timings": timings,
                          "D_Institution": institute,
                          "D_Password": password,
                          "D_Address": address,
                          "D_Certification": certification
                        });
                        _D_PhoneNumberController.text = '';
                        _D_CnicController.text = '';
                        _D_NameController.text = '';
                        _D_EmailController.text = '';
                        _D_AddressController.text = '';
                        _D_PasswordController.text = '';
                        _D_ExperienceController.text = '';
                        _D_TimingController.text = '';
                        _D_DaysController.text = '';
                        _D_InstituteController.text = '';
                        _D_EducationController.text = '';
                        _D_SpecializationController.text = '';
                        _D_CertificationController.text = '';
                        Navigator.of(context).pop();
                      }
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Future<void> _delete(String DoctorId) async {
    await _AuthDelete(DoctorId);
    await _Doctors.doc(DoctorId).delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted an Doctor')));
  }

  @override
  Widget build(BuildContext context) {
    //stream builder helps to create persistent connection with firestore DB
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.indigo,
          title: "Doctor Panel".text.xl4.bold.color(context.accentColor).make(),
        ),
        body: StreamBuilder(
          stream: _Doctors.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              final DoctorDocs = streamSnapshot.data!.docs;
              return ListView.builder(
                itemCount: DoctorDocs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot = DoctorDocs[index];
                  return Card(
                    //margin: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22)),
                    //elevation: 5,
                    child: ListTile(
                      title: Text(
                          "Doctor ID:  ${DoctorDocs[index]["D_id"].toString()}"),
                      subtitle:
                          //Text(AdminDocs[index]["A_FirstName"]) ,
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                            "Name:".text.bold.make(),
                            Text(documentSnapshot['D_Name']),
                            "Email:".text.bold.make(),
                            Text(documentSnapshot['D_Gender']),
                            "Gender:".text.bold.make(),
                            Text(documentSnapshot['D_PhoneNumber'].toString()),
                            "PhoneNumber:".text.bold.make(),
                            Text(documentSnapshot['D_Cnic'].toString()),
                            "Cnic:".text.bold.make(),
                            Text(documentSnapshot['D_Email']),
                            "Password:".text.bold.make(),
                            Text(documentSnapshot['D_Password'].toString()),
                            "Address:".text.bold.make(),
                            Text(documentSnapshot['D_Address']),
                            "Experience:".text.bold.make(),
                            Text(documentSnapshot['D_Experience']),
                            "Days:".text.bold.make(),
                            Text(documentSnapshot['D_Days']),
                            "Institution:".text.bold.make(),
                            Text(documentSnapshot['D_Institution']),
                            "Education:".text.bold.make(),
                            Text(documentSnapshot['D_Education']),
                            "Certification:".text.bold.make(),
                            Text(documentSnapshot['D_Certification']),
                            "Timings:".text.bold.make(),
                            Text(documentSnapshot['D_Timings']),
                            "Specialization:".text.bold.make(),
                            Text(documentSnapshot['D_Specialization']),
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
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const signUpDoc()));
          },
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
