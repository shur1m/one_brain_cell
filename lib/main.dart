import 'package:flutter/material.dart';
import 'package:one_brain_cell/MyApp.dart';
import 'homePage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('settings');
  await Hive.openBox('dir');

  runApp(MyApp());
}
