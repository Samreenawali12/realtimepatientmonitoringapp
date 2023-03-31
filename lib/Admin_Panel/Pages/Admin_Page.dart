import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:velocity_x/velocity_x.dart';

class AdminPage extends StatefulWidget {
  AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  // text fields' controllers
  final TextEditingController _A_IdController = TextEditingController();
  final TextEditingController _A_AddressController = TextEditingController();
  final TextEditingController _A_EmailController = TextEditingController();
  final TextEditingController _A_PasswordController = TextEditingController();
  final TextEditingController _A_NameController = TextEditingController();

  final CollectionReference _Admin =
      FirebaseFirestore.instance.collection('Admin');
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> _create([DocumentSnapshot? documentSnapshot]) async {
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
                  controller: _A_NameController,
                  decoration: const InputDecoration(labelText: 'Name'),
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
                  controller: _A_EmailController,
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
                  controller: _A_PasswordController,
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
                  controller: _A_AddressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Create'),
                  onPressed: () async {
                    //final num? aID = num.tryParse(_A_IdController.text);
                    final String name = _A_NameController.text;
                    final String email = _A_EmailController.text;
                    final String address = _A_AddressController.text;
                    final String password = _A_PasswordController.text;
                    final User? user =
                        (await auth.createUserWithEmailAndPassword(
                      email: email,
                      password: password.toString(),
                    ))
                            .user;
                    String UID = FirebaseAuth.instance.currentUser!.uid;
                    if (user != null) {
                      await _Admin.doc(UID).set({
                        "A_Id": UID,
                        "A_Name": name,
                        "A_Email": email,
                        "A_Password": password,
                        "A_Address": address,
                        "A_UID": UID,
                        "role": "admin"
                      });
                      _A_NameController.text = '';
                      _A_EmailController.text = '';
                      _A_AddressController.text = '';
                      _A_PasswordController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _A_IdController.text = documentSnapshot['A_Id'].toString();
      _A_NameController.text = documentSnapshot['A_Name'];
      _A_AddressController.text = documentSnapshot['A_Address'];
      _A_PasswordController.text = documentSnapshot['A_Password'].toString();
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
                  controller: _A_NameController,
                  decoration: const InputDecoration(labelText: 'Name'),
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
                  controller: _A_PasswordController,
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
                  controller: _A_AddressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    final String name = _A_NameController.text;
                    final String email = _A_EmailController.text;
                    final String address = _A_AddressController.text;
                    final String password = _A_PasswordController.text;
                    if (password != null ||
                        email != "" ||
                        address != "" ||
                        name != "") {
                      await FirebaseAuth.instance.currentUser!
                          .updatePassword(password);
                      await _Admin.doc(documentSnapshot!.id).update({
                        "A_Name": name,
                        "A_Password": password,
                        "A_Address": address
                      });

                      _A_NameController.text = '';
                      _A_EmailController.text = '';
                      _A_AddressController.text = '';
                      _A_PasswordController.text = '';
                      Navigator.of(context).pop();
                    }
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _delete(String AdminId) async {
    await _Admin.doc(AdminId).delete();
    await FirebaseAuth.instance.currentUser!.delete();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted an Admin')));
  }

  @override
  Widget build(BuildContext context) {
    //stream builder helps to create persistent connection with firestore DB
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.indigo,
          title: "Admin Panel".text.xl4.bold.color(context.accentColor).make(),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: context.accentColor,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        // drawer: const NavigationDrawer(),

        body: StreamBuilder(
          stream: _Admin.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              final AdminDocs = streamSnapshot.data!.docs;
              return ListView.builder(
                itemCount: AdminDocs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot = AdminDocs[index];
                  return Card(
                    //margin: const EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22)),
                    //elevation: 5,
                    child: ListTile(
                      // onTap: () {
                      //   Navigator.of(context).push(
                      //     MaterialPageRoute(
                      //       builder: (context) => AdminUserPage(AdminDocs[index]),
                      //     ),
                      //   );
                      // },
                      title: Text(
                          "Admin ID:  ${AdminDocs[index]["A_Id"].toString()}"),
                      subtitle:
                          //Text(AdminDocs[index]["A_FirstName"]) ,
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                            "Name:".text.bold.make(),
                            Text(documentSnapshot['A_Name']),
                            "Email:".text.bold.make(),
                            Text(documentSnapshot['A_Email']),
                            "Password:".text.bold.make(),
                            Text(documentSnapshot['A_Password'].toString()),
                            "Address:".text.bold.make(),
                            Text(documentSnapshot['A_Address']),
                          ]),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            //Press this button to edit a single product
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _update(documentSnapshot),
                            ),
                            // This icon button is used to delete a single product
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _delete(documentSnapshot.id),
                            ),
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
// Add new User
        floatingActionButton: FloatingActionButton(
          onPressed: () => _create(),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
