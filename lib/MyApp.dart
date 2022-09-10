import 'package:flutter/material.dart';
import 'package:one_brain_cell/HomePage.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'One Brain Cell',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color.fromARGB(255, 0, 0, 0),
        secondaryHeaderColor: Color.fromARGB(255, 210, 185, 253),
        textTheme: const TextTheme(
          headline1: TextStyle(
              fontSize: 36.0, fontWeight: FontWeight.bold, color: Colors.black),
          headline2: TextStyle(
              fontSize: 28.0, fontWeight: FontWeight.bold, color: Colors.black),
          bodyText1: TextStyle(fontSize: 17, fontFamily: 'Hind'),
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: HomePage(),
    );
  }
}
