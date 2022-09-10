import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import '../utils/PageCreator.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({Key? key}) : super(key: key);

  @override
  _SettingsTabState createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  bool _someSetting = true;

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
            ListTile(
              title: Text('I am multicellular',
                  style: Theme.of(context).textTheme.bodyText1),
              trailing: CupertinoSwitch(
                value: _someSetting,
                activeColor: Theme.of(context).secondaryHeaderColor,
                onChanged: (bool value) {
                  setState(() {
                    _someSetting = value;
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
