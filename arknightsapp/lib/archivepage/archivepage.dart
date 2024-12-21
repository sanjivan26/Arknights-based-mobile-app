import 'dart:convert';
import '../colorfab.dart';
import 'package:http/http.dart' as http;
import './operatortile.dart';
import 'package:flutter/material.dart';

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
    _operatorsFuture = fetchOperators();
  }

  Future<Map<String, dynamic>> fetchOperators() async {
    final url = Uri.parse('https://raw.githubusercontent.com/Kengxxiao/ArknightsGameData_YoStar/main/en_US/gamedata/excel/character_table.json'); // Replace with your API URL
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load operators');
    }
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
            color: ColorFab.lightBlack,
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
