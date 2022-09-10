import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:one_brain_cell/navBarTabs/AddTab.dart';
import 'package:one_brain_cell/navBarTabs/HomeTab.dart';
import 'package:one_brain_cell/navBarTabs/ListsTab.dart';
import 'package:one_brain_cell/navBarTabs/SettingsTab.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _menuNames = ['Home', 'Lists', 'Add', 'Settings'];

  List<Widget> _pages = [HomeTab(), ListsTab(), AddTab(), SettingsTab()];

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
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
            color: Colors.white,
            activeColor: activeColor,
            tabBackgroundColor: Colors.grey.shade900,
            gap: 8,
            tabs: [
              GButton(
                icon: Icons.home,
                text: _menuNames[0],
                iconColor: iconColor,
              ),
              GButton(
                icon: Icons.list,
                text: _menuNames[1],
                iconColor: iconColor,
              ),
              GButton(
                icon: Icons.add,
                text: _menuNames[2],
                iconColor: iconColor,
              ),
              GButton(
                icon: Icons.settings,
                text: _menuNames[3],
                iconColor: iconColor,
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
