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

  @override
  Widget build(BuildContext context) {
    bool _isMulticellular = settingsBox.containsKey('multicellular')
        ? settingsBox.get('multicellular')
        : false;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Scrollbar(
            child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            //we can automate making these kinds of buttons
            PageCreator.makeTitle('Settings', context),
            ListTile(
              title: Text('I am multicellular',
                  style: Theme.of(context).textTheme.bodyText1),
              trailing: CupertinoSwitch(
                value: _isMulticellular,
                activeColor: Theme.of(context).secondaryHeaderColor,
                onChanged: (bool value) {
                  setState(() {
                    settingsBox.put('multicellular', value);
                  });
                },
              ),
            ),
          ],
        )),
      ),
    );
  }
}
