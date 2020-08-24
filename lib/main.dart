import 'package:breezy_admin_app/screens/auth_screen.dart';
import 'package:breezy_admin_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initApp() async {
    await FirebaseApp.configure(
      name: "Admin app",
      options: FirebaseOptions(googleAppID: "1:44433886400:android:a4fb1a88a0c98c5749b125",apiKey: "AIzaSyBkg1aSXVgyvAydZACMhNVCNp7bsbwyYRc",projectID:"flutter-auth-688f7",));
  }

  @override
  void initState() {
    initApp();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (context, dataSnapshots) {
            if (dataSnapshots.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (dataSnapshots.hasData) {
              return HomeScreen();
            } else {
              return AuthScreen();
            }
          }),
    );
  }
}
