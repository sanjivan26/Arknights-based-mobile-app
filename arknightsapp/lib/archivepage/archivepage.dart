import './archivecontent.dart';
import 'package:flutter/material.dart';

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
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text('Archive', style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surface,
        child: const ArchiveContent()),
    );
  }
}
