import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbtest/Doctor_Panel/pages/Doctor_Pages/D_History.dart';
import 'package:dbtest/Doctor_Panel/pages/Doctor_Pages/docRequest.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../theme.dart';
import '../../drawer.dart';
import '../routes.dart';

class DocHome extends StatefulWidget {
  const DocHome({super.key});

  @override
  State<DocHome> createState() => _DocHomeState();
}

class _DocHomeState extends State<DocHome> with WidgetsBindingObserver {
  final currentUser = FirebaseAuth.instance;
  User? docID = FirebaseAuth.instance.currentUser!;
  String name = '';
  String email = '';
  void getData() async {
    var vari = await FirebaseFirestore.instance
        .collection('Doctors')
        .doc(docID?.uid)
        .get();
    if (mounted) {
      setState(() {
        if (vari.data() != null) {
          name = vari.data()!['D_Name'].toString();
          email = vari.data()!['D_Email'];
        } else {
          name = "Received Empty Value";
          email = "Received Empty Value";
        }
      });
    }
  }

  //set variable for Connectivity subscription listiner
  StreamSubscription? internetconnection;
  bool isoffline = false;
//for online anf offline status
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    // internetconnection = Connectivity()
    //     .onConnectivityChanged
    //     .listen((ConnectivityResult result) {
    //   // whenevery connection status is changed.
    //   if (result == ConnectivityResult.none) {
    //     //there is no any connection
    //     setState(() {
    //       isoffline = true;
    //     });
    //   } else if (result == ConnectivityResult.mobile) {
    //     //connection is mobile data network
    //     setState(() {
    //       isoffline = false;
    //     });
    //   } else if (result == ConnectivityResult.wifi) {
    //     //connection is from wifi
    //     setState(() {
    //       isoffline = false;
    //     });
    //   }
    // });
    getData();
    super.initState();
    getData();
    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");
  }

  void setStatus(String status) async {
    await _firestore
        .collection('Doctors')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "status": status,
    });
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     setStatus("Online");
  //   } else {
  //     setStatus("Offline");
  //   }
  // }

  bool isloading = false;

  // @override
  // dispose() {
  //   super.dispose();
  //   internetconnection!.cancel();
  //   //cancel internent connection subscription after you are done
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "Home",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: MyTheme.darkbluishColor),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Container(
            //   child: errmsg("No Internet Connection Available", isoffline),
            //   //to show internet connection message on isoffline = true.
            // ),
            const SizedBox(
              height: 30,
              width: 20,
            ),
            Container(
              color: Colors.white,
              //color: Colors.white.withOpacity(0.2),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Welcome Dr $name!",
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: MyTheme.darkbluishColor),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
              width: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                // color: Colors.white.withOpacity(0.2),
                width: size.width / 1,
                height: size.height / 1.8,

                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Colors.indigo.withOpacity(.5),
                            // blurRadius: 10.0, // soften the shadow
                            //spreadRadius: 0.0, //extend the shadow
                            offset: const Offset(
                              2.0, // Move to right 10  horizontally
                              2.0,
                            ))
                      ]),
                      child: Card(
                        color: Colors.indigo,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                            //borderRadius: BorderRadius.circular(10),
                            side: BorderSide(
                                color: MyTheme.darkbluishColor, width: 0)),
                        child: InkWell(
                          onTap: () =>
                              Navigator.pushNamed(context, MyRoutes.DocHomeR),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Image.asset(
                                "assets/Images/home.png",
                                //   height: MediaQuery.of(context).size.height *
                                //      0.20, // 130,
                                width: MediaQuery.of(context).size.width * 0.35,
                                fit: BoxFit.fill,
                              ),
                              //Spacer(),
                              const Text(
                                "Home",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Colors.indigo.withOpacity(.5),
                            // blurRadius: 10.0, // soften the shadow
                            //spreadRadius: 0.0, //extend the shadow
                            offset: const Offset(
                              2.0, // Move to right 10  horizontally
                              2.0,
                            ))
                      ]),
                      child: Card(
                        color: Colors.indigo,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                            side: BorderSide(
                                color: MyTheme.darkbluishColor, width: 0)),
                        child: InkWell(
                          onTap: () => Navigator.pushNamed(
                              context, MyRoutes.DocProfileR),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Image.asset(
                                "assets/Images/profiled.png",
                                //   height: MediaQuery.of(context).size.height *
                                //      0.20, // 130,
                                width: MediaQuery.of(context).size.width * 0.35,
                                fit: BoxFit.fill,
                              ),
                              const Text(
                                "Profile",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Colors.indigo.withOpacity(.5),
                            // blurRadius: 10.0, // soften the shadow
                            //spreadRadius: 0.0, //extend the shadow
                            offset: const Offset(
                              2.0, // Move to right 10  horizontally
                              2.0,
                            ))
                      ]),
                      child: Card(
                        color: Colors.indigo,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                            side: BorderSide(
                                color: MyTheme.darkbluishColor, width: 0)),
                        child: InkWell(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const docRequest(),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Image.asset(
                                "assets/Images/dashb.png",
                                //  height: MediaQuery.of(context).size.height *
                                //    0.20, // 130,
                                width: MediaQuery.of(context).size.width * 0.35,
                                fit: BoxFit.fill,
                              ),
                              const Text(
                                "Requests",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Colors.indigo.withOpacity(.5),
                            // blurRadius: 10.0, // soften the shadow
                            //spreadRadius: 0.0, //extend the shadow
                            offset: const Offset(
                              2.0, // Move to right 10  horizontally
                              2.0,
                            ))
                      ]),
                      child: Card(
                        color: Colors.indigo,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                            side: BorderSide(
                                color: MyTheme.darkbluishColor, width: 0)),
                        child: InkWell(
                          onTap: () =>
                              Navigator.pushNamed(context, MyRoutes.DocUpdateR),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Image.asset(
                                "assets/Images/updatd.png",
                                height: MediaQuery.of(context).size.height *
                                    0.17, // 130,
                                width: MediaQuery.of(context).size.width * 0.35,
                                fit: BoxFit.fill,
                              ),
                              const Text(
                                "Update Profile",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      drawer: const MyDrawer(),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(9.0),
          child: SizedBox(
            height: 80,
            child: Row(
              children: <Widget>[
                Column(
                  children: [
                    IconButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, MyRoutes.DocHomeR),
                        icon: Icon(
                          Icons.home,
                          color: MyTheme.darkbluishColor,
                        )),
                    Text(
                      "Home",
                      style: TextStyle(
                          color: MyTheme.darkbluishColor,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    IconButton(
                        onPressed: () =>
                            // Navigator.pushNamed(context, MyRoutes.DocUpdateR),
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const docRequest(),
                              ),
                            ),
                        icon: Icon(
                          Icons.settings,
                          color: MyTheme.darkbluishColor,
                        )),
                    Text(
                      "Request",
                      style: TextStyle(
                          color: MyTheme.darkbluishColor,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    IconButton(
                        onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const D_History(),
                              ),
                            ),
                        icon: Icon(
                          Icons.history,
                          color: MyTheme.darkbluishColor,
                        )),
                    Text(
                      "History",
                      style: TextStyle(
                          color: MyTheme.darkbluishColor,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                // Divider(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget errmsg(String text, bool show) {
  //   //error message widget.
  //   if (show == true) {
  //     //if error is true then show error message box
  //     return Container(
  //       padding: EdgeInsets.all(10.00),
  //       margin: EdgeInsets.only(bottom: 10.00),
  //       color: Color.fromARGB(255, 122, 8, 0),
  //       child: Row(children: [
  //         Container(
  //           margin: EdgeInsets.only(right: 6.00),
  //           child: Icon(Icons.info, color: Colors.white),
  //         ), // icon for error message

  //         Text(text, style: TextStyle(color: Colors.white)),
  //         //show error message text
  //       ]),
  //     );
  //   } else {
  //     return Container();
  //     //if error is false, return empty container.
  //   }
  // }
}
