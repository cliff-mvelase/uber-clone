import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uber/AllScreens/loginscreen.dart';
import 'package:uber/AllScreens/mainscreen.dart';
import 'package:uber/AllScreens/registrationscreen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

DatabaseReference usersRef = FirebaseDatabase.instance.reference().child("users");

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taxi Rider App',
      theme: ThemeData(
        fontFamily: "Brad Bold",
        primarySwatch: Colors.blue,
      ),
      initialRoute: MainScreen.idScreen,
      routes:
      {
        RegistrationScreen.idScreen: (context)=>RegistrationScreen(),
        LoginScreen.idScreen: (context)=>LoginScreen(),
        MainScreen.idScreen: (context)=>MainScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
