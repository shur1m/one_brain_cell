import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:one_brain_cell/utils/pageCreator.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  Box settingsBox = Hive.box('settings');

  _makeSwitchTile(String text, String settingName) {
    return ListTile(
      title: Text(text, style: Theme.of(context).textTheme.bodyText1),
      trailing: CupertinoSwitch(
        value: settingsBox.get(settingName),
        activeColor: Theme.of(context).secondaryHeaderColor,
        onChanged: (bool value) {
          setState(() {
            settingsBox.put(settingName, value);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Scrollbar(
            child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            //we can automate making these kinds of buttons
            PageCreator.makeTitle('Settings', context),
            _makeSwitchTile('I am multicellular', 'multicellular'),
            _makeSwitchTile('Flashcard flip animation', 'flipAnimation'),
          ],
        )),
      ),
    );
  }
}
