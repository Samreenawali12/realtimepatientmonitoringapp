import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbtest/Doctor_Panel/pages/Doctor_Pages/D_notificationapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import '../../Doctor_Panel/pages/Doctor_Pages/D_Session.dart';
import '../../theme.dart';

class Alarm extends StatelessWidget {
  const Alarm({super.key});

  static const String _title = 'Flutter Code Sample';

  @override
  Widget build(BuildContext context) {
    final Size = MediaQuery.of(context).size;
    return MaterialApp(
      themeMode: ThemeMode
          .system, //or dark then all will be dark and if light header will be purple
      theme: MyTheme.LightTheme(context),
      darkTheme: MyTheme.DarkTheme(context),
      debugShowCheckedModeBanner: false,
      title: _title,
      home: Scaffold(
        body: Column(children: [
          Row(
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: MyStatefulWidget(),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                height: Size.height / 13,
                width: Size.width / 1,
                padding: EdgeInsets.only(left: Size.width / 7),
                child: Text(
                  "EMERGENCY ALERT",
                  style: TextStyle(
                      color: Color.fromARGB(255, 32, 1, 134),
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
              )
            ],
          ),
          Row(
            children: [
              Container(
                height: Size.height / 13,
                width: Size.width / 1,
                padding: EdgeInsets.only(left: Size.width / 7),
                child: Text(
                  "Emergency Request recieved!\nPatient's Vitals : Not Normal",
                  style: TextStyle(
                      color: Color.fromARGB(255, 62, 61, 66),
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              )
            ],
          ),
          Row(
            children: [
              Container(
                height: Size.height / 2.7,
                width: Size.width / 1,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        "assets/Images/announce.png",
                      ),
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.center),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 80),
                    child: ElevatedButton(
                        onPressed: () {
                          FlutterRingtonePlayer.stop();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => D_Session(),
                            ),
                          );
                        },
                        child: const Text(
                          "Accept",
                          style: TextStyle(fontSize: 20),
                        )),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: ElevatedButton(
                        onPressed: () {
                          // FirebaseFirestore.instance
                          //     .collection("Requests")
                          //     .doc(ruid)
                          //     .update({
                          //   'R_Status': 'cancelled',
                          //   'R_EndTime': DateTime.now().toString(),
                          // });
                          // Navigator.of(context).pushReplacement(
                          //   MaterialPageRoute(
                          //     builder: (context) => docRequest(),
                          //   ),
                          // );
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 185, 0, 0),
                        ),
                        child: const Text(
                          "Decline",
                          style: TextStyle(fontSize: 20),
                        )),
                  )
                ],
              )
            ],
          )
        ]),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(1.5, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticIn,
  ));
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FlutterRingtonePlayer.playAlarm();
  }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final Size = MediaQuery.of(context).size;
    return SlideTransition(
      position: _offsetAnimation,
      child: Padding(
        padding: EdgeInsets.all(30.0),
        child: Container(
          height: Size.height / 4,
          width: Size.width / 1.4,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "assets/Images/alert.png",
                ),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter),
          ),
        ),
      ),
    );
  }
}
