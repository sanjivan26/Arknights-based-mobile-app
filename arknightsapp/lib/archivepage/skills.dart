import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './../colorfab.dart';

class Skills extends StatefulWidget {
  final dynamic operator;
  const Skills({super.key, required this.operator});

  @override
  State<Skills> createState() => _SkillsState();
}

class _SkillsState extends State<Skills> {
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
      final defaultSkillId = operatorSkills[0]['skillId'];
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
          skillName = skillData['levels'][0]['name'] ?? '';
          skillDescription = replaceDescription(
            skillData['levels'][0]['description'] ?? '',
            skillData['levels'][0]['blackboard'] ?? [],
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
      description = description
          .replaceAll('{$key:0%}', value.toString())
          .replaceAll('{$key}', value.toString());
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
              rarity = int.tryParse(rarityValue.substring(rarityValue.length - 1)) ?? 0;
            } else if (rarityValue is int) {
              rarity = rarityValue;
            }
          }

          return SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: ColorFab.lightShadow,
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (rarity > 2)
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: selected == 1 ? WidgetStateProperty.all(ColorFab.offWhite) : WidgetStateProperty.all(ColorFab.darkShadow),
                          ),
                          onPressed: () {
                            final skillData = skills[operatorSkills[0]['skillId']];
                            if (skillData != null) {
                              setState(() {
                                skillName = skillData['levels'][0]['name'] ?? '';
                                skillDescription = replaceDescription(
                                  skillData['levels'][0]['description'] ?? '',
                                  skillData['levels'][0]['blackboard'] ?? [],
                                );
                                selected = 1;
                              });
                            }
                          },
                          child: const Text('Skill 1'),
                        ),
                      if (rarity > 3)
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: selected == 2 ? WidgetStateProperty.all(ColorFab.offWhite) : WidgetStateProperty.all(ColorFab.darkShadow),
                          ),
                          onPressed: () {
                            final skillData = skills[operatorSkills[1]['skillId']];
                            if (skillData != null) {
                              setState(() {
                                skillName = skillData['levels'][0]['name'] ?? '';
                                skillDescription = replaceDescription(
                                  skillData['levels'][0]['description'] ?? '',
                                  skillData['levels'][0]['blackboard'] ?? [],
                                );
                                selected = 2;
                              });
                            }
                          },
                          child: const Text('Skill 2'),
                        ),
                      if (rarity > 5)
                        ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: selected == 3 ? WidgetStateProperty.all(ColorFab.offWhite) : WidgetStateProperty.all(ColorFab.darkShadow),
                          ),
                          onPressed: () {
                            final skillData = skills[operatorSkills[2]['skillId']];
                            if (skillData != null) {
                              setState(() {
                                skillName = skillData['levels'][0]['name'] ?? '';
                                skillDescription = replaceDescription(
                                  skillData['levels'][0]['description'] ?? '',
                                  skillData['levels'][0]['blackboard'] ?? [],
                                );
                                selected = 3;
                              });
                            }
                          },
                          child: const Text('Skill 3'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    skillName,
                    style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold, color: ColorFab.midAccent),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      skillDescription.isNotEmpty ? skillDescription : "No skill description available.",
                      style: const TextStyle(fontSize: 16, color: ColorFab.darkAccent),
                    ),
                  ),
                ],
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
