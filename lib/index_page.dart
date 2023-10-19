import 'package:batu_tambang/auth_and_setting/pages/setting_page.dart';
import 'package:flutter/material.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> halaman = [
      const SettingPage(),
      const SettingPage(),
    ];

    return Scaffold(
      bottomNavigationBar: MediaQuery.of(context).size.width < 640
          ? BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              iconSize: 24,
              selectedItemColor: Colors.green[900],
              selectedIconTheme: const IconThemeData(color: Colors.green),
              onTap: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              currentIndex: _selectedIndex,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home, color: Colors.teal.shade700),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person, color: Colors.teal.shade700),
                  label: 'Profile',
                ),
              ],
            )
          : null,
      body: Row(
        children: [
          if (MediaQuery.of(context).size.width >= 640)
            NavigationRail(
              labelType: NavigationRailLabelType.all,
              selectedLabelTextStyle: const TextStyle(
                  color: Colors.black87, fontWeight: FontWeight.bold),
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              selectedIndex: _selectedIndex,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home, color: Colors.teal.shade700),
                  label: const Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person, color: Colors.teal.shade700),
                  label: const Text('Profile'),
                ),
              ],
            ),
          Expanded(child: halaman[_selectedIndex]),
        ],
      ),
    );
  }
}
