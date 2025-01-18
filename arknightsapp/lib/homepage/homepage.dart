import './homepagecontent.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import './../theme/themeprovider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          'Home',
          style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.contrast, color: Theme.of(context).colorScheme.inverseSurface),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen:false).toggleTheme();
            },
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        child: const HomePageContent(),
      ),
    );
  }
}
