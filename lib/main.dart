import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dbtest/Doctor_Panel/pages/Doctor_Pages/docRequest.dart';
import 'package:dbtest/Doctor_Panel/passwordupdate/forgotpassword.dart';
import 'package:dbtest/Patient_Panel/pages/alarm_page.dart';
import 'package:dbtest/Patient_Panel/pages/requested_doc.dart';
import 'package:dbtest/firebase_options.dart';
import 'package:dbtest/screens/doctor/doc_token.dart';
import 'package:dbtest/screens/patient/P_Token.dart';
import 'package:dbtest/screens/signInScreen.dart';
import 'package:dbtest/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:velocity_x/velocity_x.dart';
import 'Admin_Panel/dashboard.dart';
import 'Doctor_Panel/pages/Doctor_Pages/docUpdate.dart';
import 'Doctor_Panel/pages/Doctor_Pages/dochome.dart';
import 'Doctor_Panel/pages/Doctor_Pages/doctorprofile.dart';
import 'Doctor_Panel/pages/routes.dart';
import 'Doctor_Panel/passwordupdate/Updatepass.dart';
import 'Doctor_Panel/passwordupdate/Updatepasspatient.dart';
import 'Patient_Panel/Patient_Dashboard.dart';
import 'Patient_Panel/pages/local_notification.dart';
import 'functions/NotificationAPI.dart';

//Create a [AndroidNotificationChannel] for heads up notifications
AndroidNotificationChannel? channel;
//plugins enable
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
//for context access
final GlobalKey<NavigatorState> navigatorKey2 = GlobalKey<NavigatorState>();
bool isNClicked = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
      playSound: true,
      enableLights: true);
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  flutterLocalNotificationsPlugin
      ?.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel!);
  NotificationService().initNotification();
  //without tap function run
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp2());
}

void cancelRequest(pId) async {
  var patientId = pId;
  var vari = await FirebaseFirestore.instance
      .collection('Patients')
      .doc(patientId)
      .get();

  var ptoken = vari.data()!['P_Token'].toString();
  var data = await FirebaseFirestore.instance
      .collection('Requests')
      .where('D_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .where('P_id', isEqualTo: patientId)
      .where('R_Status', isEqualTo: "Requested")
      .get();
  if (data.docs.isNotEmpty) {
    FirebaseFirestore.instance
        .collection("Requests")
        .doc(data.docs[0]['R_UID'].toString())
        .update({
      'R_Status': 'cancelled',
      'R_EndTime': DateTime.now().toString(),
    });
    sendNotifcation(
        title: "Rejected",
        message:
            "Doctor has rejected your request\n kindly send request to other doctors",
        token: ptoken,
        doctorId: FirebaseAuth.instance.currentUser!.uid,
        doctorName: "name");
  }
}

//without tap
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  var patientID = message.data['patientID'];
  String condition = message.data['Condition'];
  print(condition);
  print('Got a message whilst in the foreground!');
  ///app minimize and terminated (urgent)
  var patientName = message.data['patientName'];
  if (patientID != null && condition != "no") {
    Future.delayed(const Duration(seconds: 10), () {
      if (isNClicked == false) {
        cancelRequest(patientID);
      }
    });
  }
}

class MyApp2 extends StatefulWidget {
  const MyApp2({Key? key}) : super(key: key);

  @override
  State<MyApp2> createState() => _MyApp2State();
}

class _MyApp2State extends State<MyApp2> {
  @override
  void initState() {
    super.initState();
    _configureFirebaseListeners();
  }

  void _configureFirebaseListeners() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // when app is open and notifcation is received by Patient
      if (message.data['From'] == "Patient") {
        var patientID = message.data['patientID'];
        String condition = message.data['Condition'];
        print(condition);
        print('Got a message whilst in the foreground!');
        var patientName = message.data['patientName'];
        if (patientID != null && condition == "no") {
          NotificationService().showNotification(
              1,
              patientName,
              "$patientName has Requested for \n assistance",
              navigatorKey2.currentContext!,
              "doctor");
        }
        if (condition == 'Critical') {
          //navigate
          navigatorKey2.currentState!.push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                return Alarm(message: message);
              },
            ),
          );
        }
      } else {
        //on Patient Side to show accepted notification
        var DoctorID = message.data['doctorID'];
        var DoctorName = message.data['doctorName'];
        if (DoctorID != null) {
          NotificationService().showNotification(
              1,
              DoctorName,
              message.notification!.body.toString(),
              navigatorKey2.currentContext!,
              'patient');
        }
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      var PatientID = message.data['patientID'];
      //app was minimized and then user taped on the notification
      if (PatientID.toString().isNotEmpty) {
        isNClicked = true;
        navigatorKey2.currentState!.push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return docRequest(
                patientID: PatientID,
              );
            },
          ),
        );
      }
      var doctorID = message.data['doctorID'];
      if (doctorID.toString().isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Requesteddoc(
                    doctorID: doctorID,
                  )),
        );
      }
    });
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      //terminated then user taped on the notification
      var patientId = message!.data['patientID'];
      if (patientId.toString().isNotEmpty) {
        isNClicked = true;
        navigatorKey2.currentState!.push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return docRequest(
                patientID: patientId,
              );
            },
          ),
        );
      }
      var doctorID = message.data['doctorID'];
      if (doctorID.toString().isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Requesteddoc(
                    doctorID: doctorID,
                  )),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey2,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false, // to remove debug tag
      //light theme and dark theme
      themeMode: ThemeMode
          .system, //or dark then all will be dark and if light header will be purple
      theme: MyTheme.LightTheme(context),
      darkTheme: MyTheme.DarkTheme(context),
      initialRoute: "/",
      routes: {
        //"/": (context) => const Alarm(),
        "/": (context) => const MyApp(), //by default this page
        MyRoutes.DocHomeR: (context) => const DocHome(),
        MyRoutes.DocProfileR: (context) => const docProfile(),
        // MyRoutes.DocDashR: (context) => DocDashboard(),
        MyRoutes.DocUpdateR: (context) => const UpdateDoc(),
        MyRoutes.Forgotpass: (context) => const ForgotPassword(),
        MyRoutes.Updatepass: (context) => const ChangePassword(),
        MyRoutes.Updatepasspatient: (context) => const ChangePassPatient(),
      },
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // notification();
    super.initState();
    checkAuth();
  }

  Widget? screen;

  bool isloading = false;

  checkAuth() async {
    if (FirebaseAuth.instance.currentUser == null) {
      setState(() {
        screen = const SignInScreen();
      });
      return;
    } else {
      var userId = FirebaseAuth.instance.currentUser!.uid;
      print(userId);

      var doctors = await FirebaseFirestore.instance
          .collection('Doctors')
          .where('D_id', isEqualTo: userId)
          .get();

      var patients = await FirebaseFirestore.instance
          .collection('Patients')
          .where('P_id', isEqualTo: userId)
          .get();

      var admins = await FirebaseFirestore.instance
          .collection('Admin')
          .where('A_UID', isEqualTo: userId)
          .get();

      if (patients.docs.isNotEmpty) {
        PHandleToken().insertToken();
        setState(() {
          screen = const PatientDashboardPage();
        });
        return;
      } else if (doctors.docs.isNotEmpty) {
        DHandleToken().insertToken();
        setState(() {
          screen = const DocHome();
        });
        return;
      } else if (admins.docs.isNotEmpty) {
        setState(() {
          screen = const aDashboardPage();
        });
        return;
      }
    }
    setState(() {
      screen = const SignInScreen();
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return screen == null
        ? Scaffold(
            body: Center(
              child: Container(
                padding: const EdgeInsets.only(top: 450.0, left: 10),
                height: MediaQuery.of(context).size.height, // 120,
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        "assets/Images/logo-01.png",
                      ),
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.center),
                ),
                child: Text(
                  "   Welcome to \n        RTHMS",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width / 15,
                      fontWeight: FontWeight.bold,
                      color: context.accentColor),
                ),
              ),
            ),
            // body: const Center(
            //     child: CircularProgressIndicator(),
            //   ),
          )
        : screen!; // SignInScreen();
  }
}
