import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'favourite_joke_screen.dart';
import 'joke_list_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;


  final List<Widget> _screens = [
    JokesListScreen(type: 'Funny'),
    FavoriteJokesScreen(),
  ];

  void _onMenuItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Jokes App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          PopupMenuButton<int>(
            onSelected: _onMenuItemSelected,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 0, // Index for "Home"
                child: Text('Home'),
              ),
              const PopupMenuItem(
                value: 1, // Index for "Favorites"
                child: Text('Favorites'),
              ),
            ],
            icon: const Icon(Icons.menu), // Menu icon in the AppBar
          ),
        ],
      ),
      body: _screens[_selectedIndex],
    );
  }
}
