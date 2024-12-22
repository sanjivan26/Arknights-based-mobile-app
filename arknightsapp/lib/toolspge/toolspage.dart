import 'package:flutter/material.dart';
import './../colorfab.dart';

class ToolsPage extends StatelessWidget {
  const ToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Tools"),
          backgroundColor: ColorFab.offWhite,
        ),
        body: Container(
          decoration: BoxDecoration(color: ColorFab.offWhite),
          child: Column(
            children: [Container(
              
            )],
          ),
        ),
    );
  }
}