import './archivepage/archivepage.dart';
import './homepage/homepage.dart';
import 'package:flutter/material.dart';
import './colorfab.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;  // Tracks the selected index in the BottomNavigationBar

  // List of pages corresponding to the navigation items
  final List<Widget> _pages = [
    const HomeScreen(),  // Home screen widget
    const ArchivePage(),  // Archive screen widget
  ];

  // Function to handle tab selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;  // Update the selected index when a tab is tapped
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],  // Display the widget based on the selected index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,  // Current selected tab
        onTap: _onItemTapped,  // Set the callback to handle tab switch
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy),
            label: 'Archive',
          ),
        ],
      ),
    );
  }
}
