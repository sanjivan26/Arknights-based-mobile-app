import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Skills extends StatefulWidget {
  final dynamic operator;
  final double screenHeight;
  const Skills({super.key, required this.operator, required this.screenHeight});

  @override
  State<Skills> createState() => _SkillsState();
}

class _SkillsState extends State<Skills> {
  int skillLevel = 0;
  RangeValues _currentRange = const RangeValues(0,9);
  late Future<Map<String, dynamic>> _skillsFuture;
  String skillName = "";
  String skillDescription = "";
  int selected = 1;

  @override
  void initState() {
    super.initState();
    _skillsFuture = fetchSkills();

    final operatorSkills = widget.operator['skills'] ?? [];
    if (operatorSkills.isNotEmpty) {
      final defaultSkillId = operatorSkills[skillLevel+1]['skillId'];
      _loadSkillData(defaultSkillId);
    } else {
      skillName = "This character doesn't have skills.";
      skillDescription = "";
    }
  }

  void _loadSkillData(String skillId) {
    _skillsFuture.then((skills) {
      final skillData = skills[skillId];
      if (skillData != null) {
        setState(() {
          skillName = skillData['levels'][skillLevel+1]['name'] ?? '';
          skillDescription = replaceDescription(
            skillData['levels'][skillLevel+1]['description'] ?? '',
            skillData['levels'][skillLevel+1]['blackboard'] ?? [],
          );
        });
      }
    });
  }

  Future<Map<String, dynamic>> fetchSkills() async {
    final url = Uri.parse(
        'https://raw.githubusercontent.com/Kengxxiao/ArknightsGameData_YoStar/refs/heads/main/en_US/gamedata/excel/skill_table.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load skills');
    }
  }

  String replaceDescription(String description, List<dynamic> blackboard) {
    final keyValueMap = {
      for (var item in blackboard) item['key']: item['value']
    };
    keyValueMap.forEach((key, value) {
      var uppr = key.toUpperCase();
      description = description
          .replaceAll('{$key:0%}', value.toString())
          .replaceAll('{$key}', value.toString())
          .replaceAll('{$uppr}', value.toString());
    });
    return description
        .replaceAll(RegExp(r'<\/?>'), '')
        .replaceAll(RegExp(r'<@ba\..{2,7}>'), '')
        .replaceAll(RegExp(r'<\$ba\.[a-zA-Z_]*>'), '');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _skillsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final skills = snapshot.data!;
          final operatorSkills = widget.operator['skills'] ?? [];
          int rarity = 0;
          var rarityValue = widget.operator['rarity'];
          if (rarityValue != null) {
            if (rarityValue is String) {
              rarity =
                  int.tryParse(rarityValue.substring(rarityValue.length - 1)) ??
                      0;
            } else if (rarityValue is int) {
              rarity = rarityValue;
            }
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                height: widget.screenHeight * 0.30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            if (rarity > 2)
                              Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Skills",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                                  )),
                            if (rarity > 2)
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: selected == 1
                                      ? WidgetStateProperty.all(
                                          Theme.of(context)
                                              .colorScheme
                                              .onSecondary)
                                      : WidgetStateProperty.all(
                                          Theme.of(context)
                                              .colorScheme
                                              .onTertiary),
                                ),
                                onPressed: () {
                                  final skillData =
                                      skills[operatorSkills[0]['skillId']];
                                  if (skillData != null) {
                                    setState(() {
                                      skillName = skillData['levels']
                                              [skillLevel+1]['name'] ??
                                          '';
                                      skillDescription = replaceDescription(
                                        skillData['levels'][skillLevel+1]
                                                ['description'] ??
                                            '',
                                        skillData['levels'][skillLevel+1]
                                                ['blackboard'] ??
                                            [],
                                      );
                                      selected = 1;
                                    });
                                  }
                                },
                                child: const Text(
                                  '1',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            if (rarity > 3)
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: selected == 2
                                      ? WidgetStateProperty.all(
                                          Theme.of(context)
                                              .colorScheme
                                              .onSecondary)
                                      : WidgetStateProperty.all(
                                          Theme.of(context)
                                              .colorScheme
                                              .onTertiary),
                                ),
                                onPressed: () {
                                  final skillData =
                                      skills[operatorSkills[1]['skillId']];
                                  if (skillData != null) {
                                    setState(() {
                                      skillName = skillData['levels']
                                              [skillLevel+1]['name'] ??
                                          '';
                                      skillDescription = replaceDescription(
                                        skillData['levels'][skillLevel+1]
                                                ['description'] ??
                                            '',
                                        skillData['levels'][skillLevel+1]
                                                ['blackboard'] ??
                                            [],
                                      );
                                      selected = 2;
                                    });
                                  }
                                },
                                child: const Text(
                                  '2',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            if (rarity > 5)
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: selected == 3
                                      ? WidgetStateProperty.all(
                                          Theme.of(context)
                                              .colorScheme
                                              .onSecondary)
                                      : WidgetStateProperty.all(
                                          Theme.of(context)
                                              .colorScheme
                                              .onTertiary),
                                ),
                                onPressed: () {
                                  final skillData =
                                      skills[operatorSkills[2]['skillId']];
                                  if (skillData != null) {
                                    setState(() {
                                      skillName = skillData['levels']
                                              [skillLevel+1]['name'] ??
                                          '';
                                      skillDescription = replaceDescription(
                                        skillData['levels'][skillLevel+1]
                                                ['description'] ??
                                            '',
                                        skillData['levels'][skillLevel+1]
                                                ['blackboard'] ??
                                            [],
                                      );
                                      selected = 3;
                                    });
                                  }
                                },
                                child: const Text(
                                  '3',
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  skillName,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      skillDescription.isNotEmpty
                                          ? skillDescription
                                          : "No skill description available.",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Range: ${_currentRange.start.toStringAsFixed(1)} - ${_currentRange.end.toStringAsFixed(1)}',
                          style: const TextStyle(fontSize: 20),
                        ),
                        RangeSlider(
                          values: _currentRange,
                          min: 0,
                          max: 100,
                          divisions: 10,
                          labels: RangeLabels(
                            _currentRange.start.toStringAsFixed(1),
                            _currentRange.end.toStringAsFixed(1),
                          ),
                          activeColor: Colors.blue,
                          inactiveColor: Colors.grey.shade300,
                          onChanged: (RangeValues values) {
                            setState(() {
                              _currentRange = values;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Center(child: Text('No data available.'));
        }
      },
    );
  }
}
