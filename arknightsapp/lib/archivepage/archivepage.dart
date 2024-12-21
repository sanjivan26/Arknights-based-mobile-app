import 'dart:convert';
import './operatortile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class ArchivePage extends StatefulWidget {
  const ArchivePage({super.key});

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  late Future<Map<String, dynamic>> _operatorsFuture;

  @override
  void initState() {
    super.initState();
    _operatorsFuture = loadOperators();
  }

  Future<Map<String, dynamic>> loadOperators() async {
    final String jsonString = await rootBundle
        .loadString('assets/database/character_table_main.json');
    return json.decode(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _operatorsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final operators = snapshot.data!;

          if (operators.isEmpty) {
            return const Center(child: Text('No operators available'));
          }

          final filteredOperators = operators.entries
              .where((entry) => entry.key.startsWith('char'))
              .toList();

          return Container(
            color: Colors.black,
            padding: const EdgeInsets.all(3.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 3,
                mainAxisSpacing: 3,
                childAspectRatio: 0.825,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              itemCount: filteredOperators.length,
              itemBuilder: (context, index) {
                final operator = filteredOperators[index].value;
                return OperatorTile(operator);
              },
            ),
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}
