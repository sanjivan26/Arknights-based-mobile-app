import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OperatorDisplay extends StatefulWidget {
  final List<dynamic> recruitableOperators;

  const OperatorDisplay({super.key, required this.recruitableOperators});

  @override
  State<OperatorDisplay> createState() => _OperatorDisplayState();
}

class JsonCache {
  static final Map<String, String> _cache = {};

  static String? get(String key) {
    return _cache[key];
  }

  static void set(String key, dynamic jsonData) {
    _cache[key] = jsonEncode(jsonData);
  }

  static void clear() {
    _cache.clear();
  }
}

class _OperatorDisplayState extends State<OperatorDisplay> {
  late Future<Map<String, dynamic>> _operatorsFuture;

  @override
  void initState() {
    super.initState();
    _operatorsFuture = fetchOperators();
  }

  Future<Map<String, dynamic>> fetchOperators() async {
    var cachedData = JsonCache.get('operatorData');

    if (cachedData != null) {
      try {
        return json.decode(cachedData) as Map<String, dynamic>;
      } catch (e) {
        print('Error decoding cached data: $e');
      }
    }

    final url = Uri.parse(
        'https://raw.githubusercontent.com/Kengxxiao/ArknightsGameData_YoStar/main/en_US/gamedata/excel/character_table.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final parsedData = json.decode(response.body);
      JsonCache.set('operatorData', response.body);
      return parsedData as Map<String, dynamic>;
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
          final operators = snapshot.data!.entries
              .where((entry) => entry.key.startsWith('char'))
              .map((entry) => entry.value)
              .toList();

          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(), 
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
              childAspectRatio: 0.825,
            ),
            shrinkWrap: true, 
            itemCount: widget.recruitableOperators.length,
            itemBuilder: (context, index) {
              return Text(
                  'Recruitable Operator ID: ${widget.recruitableOperators[index]["id"]}');
            },
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}
