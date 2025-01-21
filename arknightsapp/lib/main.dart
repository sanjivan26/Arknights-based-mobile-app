import 'package:arknightsapp/theme/themeprovider.dart';
import './archivepage/archivepage.dart';
import './homepage/homepage.dart';
import './toolspge/toolspage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),  
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          home: const MainScreen(),
          theme: themeProvider.themedata, 
        );
      },
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
    const ToolsPage(),
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
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: const Color(0xFF8C8C8C),       
        currentIndex: _selectedIndex,  
        onTap: _onItemTapped,  
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Tools',
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
