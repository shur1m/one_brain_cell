import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:one_brain_cell/navBarTabs/addTab.dart';
import 'package:one_brain_cell/navBarTabs/homeTab.dart';
import 'package:one_brain_cell/navBarTabs/listsTab.dart';
import 'package:one_brain_cell/navBarTabs/settingsTab.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _menuNames = ['Home', 'Lists', 'Add', 'Settings'];
  final List<Widget> _pages = [HomeTab(), ListsTab(), AddTab(), SettingsTab()];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Color iconColor = Colors.white;
    Color activeColor = Theme.of(context).secondaryHeaderColor;

    return Scaffold(
      body: Center(
        child: _pages[_selectedIndex],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 24, top: 10),
          child: GNav(
            padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            iconSize: 18,
            textStyle: TextStyle(fontSize: 14, color: activeColor),
            color: Colors.white,
            activeColor: activeColor,
            tabBackgroundColor: Colors.grey.shade900,
            gap: 8,
            tabs: [
              GButton(
                icon: Icons.home,
                iconColor: iconColor,
                text: _menuNames[0],
              ),
              GButton(
                icon: Icons.list,
                iconColor: iconColor,
                text: _menuNames[1],
              ),
              GButton(
                icon: Icons.add,
                iconColor: iconColor,
                text: _menuNames[2],
              ),
              GButton(
                icon: Icons.settings,
                iconColor: iconColor,
                text: _menuNames[3],
              ),
            ],
            selectedIndex: _selectedIndex,
            onTabChange: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
      ),
    );
  }
}
