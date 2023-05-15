import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  final user1, user2;
  final String chatRoomId;

  ChatRoom(
      {required this.chatRoomId, required this.user1, required this.user2});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  bool isloading = false;
  String name = '';

  void getData() async {
    User? user = await FirebaseAuth.instance.currentUser;
    // ignore: deprecated_member_use
    var vari = await FirebaseFirestore.instance
        .collection("Patients")
        .doc(user!.uid)
        .get();
    if (mounted)
      setState(() {
        if (vari.data() != null) {
          name = vari.data()!['P_Name'].toString();
        }
      });
  }

  String appBarTitle = '';

  Future<String> getRoleBasedName() async {
    User? user = FirebaseAuth.instance.currentUser;
    var docName = await FirebaseFirestore.instance
        .collection("Doctors")
        .doc(user!.uid)
        .get();

    var patName = await FirebaseFirestore.instance
        .collection("Patients")
        .doc(user.uid)
        .get();

    if (docName.data() != null) {
      return 'Dr. ${docName.data()!['D_Name'].toString()}';
    } else {
      return '${patName.data()!['P_Name'].toString()}';
    }
  }

  @override
  void initState() {
    super.initState();
    getRoleBasedName().then((value) {
      setState(() {
        appBarTitle = value;
      });
    });
  }

  final TextEditingController _message = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _scrollController = ScrollController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser = FirebaseAuth.instance.currentUser!;
  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": name,
        "UserId": currentUser!.uid,
        "message": _message.text,
        "time": FieldValue.serverTimestamp(),
      };
      await _firestore
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .add(messages);

      _message.clear();
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      print("Enter some text");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var name = getRoleBasedName();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appBarTitle,
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1.5,
                blurRadius: 5,
                offset: const Offset(0, 11),
              ),
            ],
            gradient: const LinearGradient(
              colors: [
                Colors.indigo,
                Colors.indigo,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                height: size.height * 0.87,
                width: size.width * 0.95,
                padding: const EdgeInsetsDirectional.only(bottom: 40),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('chatroom')
                      .doc(widget.chatRoomId)
                      .collection('chats')
                      .orderBy("time", descending: false)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.data != null) {
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: ((context, index) {
                          return Row(
                            mainAxisAlignment: snapshot.data?.docs[index]
                                        ['UserId'] ==
                                    currentUser!.uid
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  top: 2,
                                  bottom: 6,
                                  //   left: 10,
                                  //   right: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: snapshot.data?.docs[index]['UserId'] ==
                                          currentUser!.uid
                                      ?  Colors.indigo
                                      : const Color.fromARGB(
                                          255, 234, 233, 233),
                                  borderRadius: snapshot.data?.docs[index]
                                              ['UserId'] ==
                                          currentUser!.uid
                                      ? const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        )
                                      : const BorderRadius.only(
                                          topRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                        ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    snapshot.data?.docs[index]['message'],
                                    style: TextStyle(
                                      color: snapshot.data?.docs[index]
                                                  ['UserId'] ==
                                              currentUser!.uid
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                          // return messages(sizep);
                        }),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ),
          ),
          Container(
            height: size.height / 13,
            width: size.width,
            alignment: Alignment.center,
            child: Container(
              height: size.height / 15,
              width: size.width / 1.1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: size.height / 16,
                    width: size.width / 1.28,
                    child: TextField(
                      controller: _message,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      )),
                    ),
                  ),
                  IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: onSendMessage,
                      iconSize: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
