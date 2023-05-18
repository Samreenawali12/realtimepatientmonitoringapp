import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({Key? key}) : super(key: key);

  @override
  State<AdminProfile> createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  String pUID = '';
  String name = '';
  String address = '';
  String email = '';
  String password = '';
  String gender = '';
  void getData() async {
    User? user = FirebaseAuth.instance.currentUser;
    var vari = await FirebaseFirestore.instance
        .collection("Admin")
        .doc(user?.uid)
        .get();
    if (mounted) {
      setState(() {
        if (vari.data() != null) {
          pUID = vari.data()!['A_Id'].toString();
          name = vari.data()!['A_Name'].toString();
          address = vari.data()!['A_Address'].toString();
          email = vari.data()!['A_Email'].toString();
          password = vari.data()!['A_Password'].toString();
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  final TextEditingController _P_AddressController = TextEditingController();
  final TextEditingController _P_NameController = TextEditingController();
  final TextEditingController _P_PasswordController = TextEditingController();

  Future<void> _update() async {
    _P_NameController.text = name;
    _P_AddressController.text = address;
    _P_PasswordController.text = password;

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
                TextField(
                  controller: _P_NameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _P_AddressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                TextField(
                  controller: _P_PasswordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    final String Name = _P_NameController.text;
                    final String Address = _P_AddressController.text;
                    final String Password = _P_PasswordController.text;
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      await FirebaseFirestore.instance
                          .collection("Admin")
                          .doc(user.uid)
                          .update({
                        "A_Name": Name,
                        "P_Address": Address,
                        "A_Password": Password
                      });
                      _P_NameController.text = '';
                      _P_AddressController.text = '';
                      _P_PasswordController.text = '';
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
                    "assets/Images/admin.webp",
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
                    "Admin Name: "
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
                    "Password: "
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
                              password
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
