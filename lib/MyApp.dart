import 'package:flutter/material.dart';
import 'package:one_brain_cell/homePage.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color secondary = Color.fromARGB(255, 210, 185, 253);

    return MaterialApp(
      title: 'One Brain Cell',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color.fromARGB(255, 0, 0, 0),
        secondaryHeaderColor: secondary,
        scaffoldBackgroundColor: Colors.white,
        cardColor: Color.fromARGB(255, 76, 76, 76),
        textTheme: const TextTheme(
          headline1: TextStyle(
              fontSize: 34.0, fontWeight: FontWeight.bold, color: Colors.black),
          headline2: TextStyle(
              fontSize: 26.0, fontWeight: FontWeight.bold, color: Colors.black),
          bodyText1: TextStyle(fontSize: 17, fontFamily: 'Hind'),
          caption:
              TextStyle(fontSize: 17, fontFamily: 'Hind', color: Colors.white),
        ),
        iconTheme: IconThemeData(color: secondary),
      ),
      home: HomePage(),
    );
  }
}
