import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class PatientProfile extends StatefulWidget {
  const PatientProfile({Key? key}) : super(key: key);

  @override
  State<PatientProfile> createState() => _PatientProfileState();
}

class _PatientProfileState extends State<PatientProfile> {
  String pUID = '';
  String name = '';
  String address = '';
  String email = '';
  String password = '';
  String gender = '';
  String age = '';
  String phonenumber = '';
  String cnic = '';
  void getData() async {
    User? user = FirebaseAuth.instance.currentUser;
    var vari = FirebaseFirestore.instance
        .collection("Patients")
        .doc(user?.uid)
        .snapshots()
        .listen((vari) {
      if (mounted) {
        setState(() {
          if (vari.data() != null) {
            pUID = vari.data()!['P_id'].toString();
            name = vari.data()!['P_Name'].toString();
            address = vari.data()!['P_Address'].toString();
            email = vari.data()!['P_Email'].toString();
            password = vari.data()!['P_Password'].toString();
            age = vari.data()!['P_Age'].toString();
            phonenumber = vari.data()!['P_PhoneNumber'].toString();
            gender = vari.data()!['P_Gender'].toString();
            cnic = vari.data()!['P_CNIC'].toString();
          }
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  final TextEditingController _P_AddressController = TextEditingController();
  final TextEditingController _P_NameController = TextEditingController();
  final TextEditingController _P_PhoneNumberController =
      TextEditingController();
  final TextEditingController _P_CnicController = TextEditingController();
  final TextEditingController _P_GenderController = TextEditingController();
  final TextEditingController _P_AgeController = TextEditingController();
  bool pnamecontroller = false, ispnamecontroller = false;

  Future<void> _update() async {
    String? radiovalue;
    _P_NameController.text = name;
    _P_AgeController.text = age;
    _P_AddressController.text = address;
    radiovalue = gender;
    _P_CnicController.text = cnic;
    _P_PhoneNumberController.text = phonenumber;

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 10,
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
                  controller: _P_AddressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    final String Name = _P_NameController.text;
                    final String? Gender = radiovalue;
                    final num? Age = num.tryParse(_P_AgeController.text);
                    final String Phonenumber = _P_PhoneNumberController.text;
                    final String Cnic = _P_CnicController.text;
                    final String Address = _P_AddressController.text;
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      await FirebaseFirestore.instance
                          .collection("Patients")
                          .doc(user.uid)
                          .update({
                        "P_Name": Name,
                        "P_Gender": Gender,
                        "P_Age": Age,
                        "P_PhoneNumber": Phonenumber,
                        "P_CNIC": Cnic,
                        "P_Address": Address
                      });
                      _P_NameController.text = '';
                      _P_AddressController.text = '';
                      _P_PhoneNumberController.text = '';
                      _P_AgeController.text = '';
                      _P_GenderController.text = '';
                      _P_CnicController.text = '';
                      getData();
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // backgroundColor: Colors.indigo,
          title: "Profile".text.xl3.bold.color(context.accentColor).make(),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: context.accentColor,
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () => _update(),
                  child: const Icon(
                    Icons.edit,
                    size: 26.0,
                  ),
                )),
          ]),
      body: SafeArea(
        bottom: false,
        child: Column(children: [
          Container(
            height: 200,
            width: 200,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    "assets/Images/patient2-01.png",
                  ),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.center),
            ),
          ),
          Expanded(
              child: VxArc(
            height: 30.0,
            arcType: VxArcType.CONVEY,
            edge: VxEdge.TOP,
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                width: context.screenWidth,
                color: context.cardColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    "Patient Name: "
                        .text
                        .xl
                        .bold
                        .color(context.accentColor)
                        .make()
                        .p8(),
                    Card(
                      elevation: 5,
                      color: context.canvasColor,
                      shape: const StadiumBorder(
                        side: BorderSide(
                          color: Colors.transparent,
                          width: 2.0,
                        ),
                      ),
                      child: Container(
                        height: 50,
                        width: 400,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              name
                                  .text
                                  .xl
                                  .color(context.accentColor)
                                  .make()
                                  .pOnly(top: 2, left: 4),
                            ]),
                      ),
                    ),
                    "Email: "
                        .text
                        .xl
                        .bold
                        .color(context.accentColor)
                        .make()
                        .p8(),
                    Card(
                      elevation: 5,
                      color: context.canvasColor,
                      shape: const StadiumBorder(
                        side: BorderSide(
                          color: Colors.transparent,
                          width: 2.0,
                        ),
                      ),
                      child: Container(
                        height: 50,
                        width: 400,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              email
                                  .text
                                  .xl
                                  .color(context.accentColor)
                                  .make()
                                  .pOnly(top: 2, left: 4),
                            ]),
                      ),
                    ),
                    "Gender: "
                        .text
                        .xl
                        .bold
                        .color(context.accentColor)
                        .make()
                        .p8(),
                    Card(
                      elevation: 5,
                      color: context.canvasColor,
                      shape: const StadiumBorder(
                        side: BorderSide(
                          color: Colors.transparent,
                          width: 2.0,
                        ),
                      ),
                      child: Container(
                        height: 50,
                        width: 400,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              gender
                                  .text
                                  .xl
                                  .color(context.accentColor)
                                  .make()
                                  .pOnly(top: 2, left: 4),
                            ]),
                      ),
                    ),
                    "Age: ".text.xl.bold.color(context.accentColor).make().p8(),
                    Card(
                      elevation: 5,
                      color: context.canvasColor,
                      shape: const StadiumBorder(
                        side: BorderSide(
                          color: Colors.transparent,
                          width: 2.0,
                        ),
                      ),
                      child: Container(
                        height: 50,
                        width: 400,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              age
                                  .text
                                  .xl
                                  .color(context.accentColor)
                                  .make()
                                  .pOnly(top: 2, left: 4),
                            ]),
                      ),
                    ),
                    "Cnic: "
                        .text
                        .xl
                        .bold
                        .color(context.accentColor)
                        .make()
                        .p8(),
                    Card(
                      elevation: 5,
                      color: context.canvasColor,
                      shape: const StadiumBorder(
                        side: BorderSide(
                          color: Colors.transparent,
                          width: 2.0,
                        ),
                      ),
                      child: Container(
                        height: 50,
                        width: 400,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              cnic
                                  .text
                                  .xl
                                  .color(context.accentColor)
                                  .make()
                                  .pOnly(top: 2, left: 4),
                            ]),
                      ),
                    ),
                    "Phonenumber: "
                        .text
                        .xl
                        .bold
                        .color(context.accentColor)
                        .make()
                        .p8(),
                    Card(
                      elevation: 5,
                      color: context.canvasColor,
                      shape: const StadiumBorder(
                        side: BorderSide(
                          color: Colors.transparent,
                          width: 2.0,
                        ),
                      ),
                      child: Container(
                        height: 50,
                        width: 400,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              phonenumber
                                  .text
                                  .xl
                                  .color(context.accentColor)
                                  .make()
                                  .pOnly(top: 2, left: 4),
                            ]),
                      ),
                    ),
                    "Address: "
                        .text
                        .xl
                        .bold
                        .color(context.accentColor)
                        .make()
                        .p8(),
                    Card(
                      elevation: 5,
                      color: context.canvasColor,
                      shape: const StadiumBorder(
                        side: BorderSide(
                          color: Colors.transparent,
                          width: 2.0,
                        ),
                      ),
                      child: Container(
                        height: 50,
                        width: 400,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              address
                                  .text
                                  .xl
                                  .color(context.accentColor)
                                  .make()
                                  .pOnly(top: 2, left: 4),
                            ]),
                      ),
                    ),
                  ],
                ).py32(),
              ),
            ),
          )),
        ]),
      ),
    );
  }
}
