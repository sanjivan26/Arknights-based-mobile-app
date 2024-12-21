import './archivecontent.dart';
import 'package:flutter/material.dart';
import './../colorfab.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({super.key});

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorFab.offWhite,
        title: const Text('Archive'),
      ),
      body: const ArchiveContent(),
    );
  }
}
