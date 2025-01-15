// ignore_for_file: empty_catches

import 'dart:convert';
import 'package:flutter/material.dart';
import './../colorfab.dart';
import 'package:http/http.dart' as http;

class RecruitOpDisplay extends StatefulWidget {
  final String id;

  const RecruitOpDisplay({super.key, required this.id});

  @override
  State<RecruitOpDisplay> createState() => _RecruitOpDisplayState();
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

class _RecruitOpDisplayState extends State<RecruitOpDisplay> {
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
    return Text(
      widget.id,
      style: const TextStyle(
        color: ColorFab.offBlack,
        fontSize: 12,
      ),
    );
  }
}
