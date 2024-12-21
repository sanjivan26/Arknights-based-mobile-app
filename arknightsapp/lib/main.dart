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
  int _selectedIndex = 0;  

  final List<Widget> _pages = [
    const HomeScreen(), 
    const ArchivePage(),  
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],  
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: ColorFab.offWhite,
        selectedItemColor: ColorFab.offBlack, 
        unselectedItemColor: ColorFab.grey,       
        currentIndex: _selectedIndex,  
        onTap: _onItemTapped,  
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
