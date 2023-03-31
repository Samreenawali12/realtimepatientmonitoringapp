import 'package:dbtest/Doctor_Panel/pages/Doctor_Pages/docRequest.dart';
import 'package:dbtest/Doctor_Panel/passwordupdate/forgotpassword.dart';
import 'package:dbtest/Patient_Panel/pages/AlarmPage.dart';
import 'package:dbtest/Patient_Panel/pages/Requesteddoc.dart';
import 'package:dbtest/firebase_options.dart';
import 'package:dbtest/screens/signInScreen.dart';
import 'package:dbtest/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'Doctor_Panel/pages/Doctor_Pages/docUpdate.dart';
import 'Doctor_Panel/pages/Doctor_Pages/dochome.dart';
import 'Doctor_Panel/pages/Doctor_Pages/doctorprofile.dart';
import 'Doctor_Panel/pages/routes.dart';
import 'Doctor_Panel/passwordupdate/Updatepass.dart';
import 'Doctor_Panel/passwordupdate/Updatepasspatient.dart';
import 'Patient_Panel/pages/local_notification.dart';

final auth = FirebaseAuth.instance;
//Create a [AndroidNotificationChannel] for heads up notifications
AndroidNotificationChannel? channel;
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
      enableLights: true);
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      ?.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel!);
  NotificationService().initNotification();
  runApp(const MyApp2());
}

class MyApp2 extends StatefulWidget {
  const MyApp2({Key? key}) : super(key: key);

  @override
  State<MyApp2> createState() => _MyApp2State();
}

class _MyApp2State extends State<MyApp2> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  late BuildContext _myBuildContext;

  @override
  void initState() {
    super.initState();
    _myBuildContext = context;
    _configureFirebaseListeners();
  }

  void _configureFirebaseListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // when app is open
      var PatientID = message.data['patientID'];
      String Condition = message.data['Condition'];
      print(Condition);
      print('Got a message whilst in the foreground!');
      var PatientName = message.data['patientName'];
      if (PatientID != null && Condition == "no") {
        NotificationService().showNotification(
            1,
            PatientName,
            "$PatientName has Requested for \n assistance",
            navigatorKey.currentContext!,
            "doctor");
      }
      if (Condition == 'Critical') {
        //navigate
        navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return const Alarm();
            },
          ),
        );
      }
      //on Patient Side to show accepted notification
      var DoctorID = message.data['doctorID'];
      var DoctorName = message.data['doctorName'];
      if (DoctorID != null) {
        NotificationService().showNotification(
            1,
            DoctorName,
            "$DoctorName has accepted your requested for\n assistance",
            navigatorKey.currentContext!,
            'patient');
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      var PatientID = message.data['patientID'];
      if (PatientID.toString().isNotEmpty) {
        navigatorKey.currentState!.push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return docRequest(
                patientID: PatientID,
              );
            },
          ),
        );
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => docRequest(
        //             patientID: PatientID,
        //           )),
        // );
      }
      var DoctorID = message.data['doctorID'];
      if (DoctorID.toString().isNotEmpty) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Requesteddoc(
                    doctorID: DoctorID,
                  )),
        );
      }
    });
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print('Message data: ${message.data}');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
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
        "/": (context) => MyApp(), //by default this page
        MyRoutes.DocHomeR: (context) => DocHome(),
        MyRoutes.DocProfileR: (context) => docProfile(),
        // MyRoutes.DocDashR: (context) => DocDashboard(),
        MyRoutes.DocUpdateR: (context) => UpdateDoc(),
        MyRoutes.Forgotpass: (context) => ForgotPassword(),
        MyRoutes.Updatepass: (context) => ChangePassword(),
        MyRoutes.Updatepasspatient: (context) => ChangePassPatient(),
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
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SignInScreen();
  }
}
