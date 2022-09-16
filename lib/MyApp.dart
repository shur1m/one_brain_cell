import 'package:flutter/material.dart';
import 'package:one_brain_cell/homePage.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color secondary = Color.fromARGB(255, 210, 185, 253);
    const Color secondaryDarker = Color.fromARGB(255, 155, 120, 216);

    return MaterialApp(
      title: 'One Brain Cell',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color.fromARGB(255, 0, 0, 0),
        secondaryHeaderColor: secondary,
        scaffoldBackgroundColor: Colors.white,
        cardColor: Color.fromARGB(255, 76, 76, 76),
        buttonColor: secondaryDarker,
        listTileTheme: ListTileThemeData(),
        outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100))),
                foregroundColor: MaterialStateProperty.all(secondary))),
        fontFamily: 'Hind',
        textTheme: const TextTheme(
          //titles of pages (big)
          headline1: TextStyle(
              fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),

          //titles of pages (small)
          headline2: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),

          //subtitles of pages
          subtitle1: TextStyle(
              fontSize: 17, color: Color.fromARGB(255, 154, 154, 154)),

          //normal text (listviews and typing)
          bodyText1: TextStyle(fontSize: 16),

          //white version of normal text
          bodyText2: TextStyle(fontSize: 16, color: Colors.white),

          //flashcard front style
          headline5: TextStyle(
              fontSize: 30, color: Colors.black, fontWeight: FontWeight.normal),
          //flashcard back style
          headline6: TextStyle(
              fontSize: 24, color: Colors.black, fontWeight: FontWeight.normal),
        ),
        iconTheme: IconThemeData(color: secondary),
      ),
      home: HomePage(),
    );
  }
}
