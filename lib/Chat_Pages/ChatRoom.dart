import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class ChatRoom extends StatefulWidget {
  //final Map<String, dynamic>? doctorMap;
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

  final TextEditingController _message = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      _message.clear();
      await _firestore
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .add(messages);
    } else {
      print("Enter some text");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text("doctor"), //doctorMap!['D_Name']
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: size.height / 1.25,
                width: size.width,
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
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: ((context, index) {
                            return Row(
                              mainAxisAlignment: snapshot.data?.docs[index]
                                          ['UserId'] ==
                                      currentUser!.uid
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Card(
                                  color: snapshot.data?.docs[index]['UserId'] ==
                                          currentUser!.uid
                                      ? Color.fromARGB(255, 197, 202, 231)
                                      : Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      snapshot.data?.docs[index]['message'],
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 22),
                                    ),
                                  ),
                                ),
                              ],
                            );
                            // return messages(sizep);
                          }));
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
              Container(
                height: size.height / 10,
                width: size.width,
                alignment: Alignment.center,
                child: Container(
                  height: size.height / 12,
                  width: size.width / 1.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: size.height / 17,
                        width: size.width / 1.3,
                        child: TextField(
                          controller: _message,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          )),
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.send), onPressed: onSendMessage),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
