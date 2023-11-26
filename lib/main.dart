import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:valley/screens/attendance_screen.dart';
import 'package:valley/screens/auth/landing_screen.dart';
import 'package:valley/screens/availability_screen.dart';
import 'package:valley/screens/bulletin_screen.dart';
import 'package:valley/screens/faculty_screen.dart';
import 'package:valley/screens/home_screen.dart';
import 'package:valley/screens/schedule_screen.dart';
import 'package:valley/screens/workload_screen.dart';
import 'package:valley/utils/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          authDomain: 'valley-9b203.firebaseapp.com',
          apiKey: "AIzaSyBYw1II0TSmA-HXeU1NJI1WF2xzyPFIhdQ",
          appId: "1:354930278705:web:4353cd8bf8ccee79173010",
          messagingSenderId: "354930278705",
          projectId: "valley-9b203",
          storageBucket: "valley-9b203.appspot.com"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Valley - Faculty',
      home: const LandingScreen(),
      routes: {
        Routes().landingscreen: (context) => const LandingScreen(),
        Routes().homescreen: (context) => HomeScreen(),
        Routes().facultyscreen: (context) => FacultyScreen(),
        Routes().schedulescreen: (context) => ScheduleScreen(),
        Routes().availabilityscreen: (context) => AvailabilityScreen(),
        Routes().attendancescreen: (context) => const AttendanceScreen(),
        Routes().workloadscreen: (context) => const WorkloadScreen(),
        Routes().facultybulletinscreen: (context) => FacultyBulletinScreen(),
      },
    );
  }
}
