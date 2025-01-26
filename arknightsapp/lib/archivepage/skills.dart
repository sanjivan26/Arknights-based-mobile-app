import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Skills extends StatefulWidget {
  final dynamic operator;
  final double screenHeight;
  final double screenWidth;

  const Skills(
      {super.key,
      required this.operator,
      required this.screenHeight,
      required this.screenWidth});

  @override
  State<Skills> createState() => _SkillsState();
}

class _SkillsState extends State<Skills> {
  int skillLevel = 0;
  late Future<Map<String, dynamic>> _skillsFuture;
  String skillName = "";
  String skillDescription = "";
  int selected = 1;
  int maxSkillLevel = 1;

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
      maxSkillLevel = skillData['levels'].length;
      if (skillData != null && mounted) {
        setState(() {
          skillName = skillData['levels'][skillLevel]['name'] ?? '';
          skillDescription = replaceDescription(
            skillData['levels'][skillLevel]['description'] ?? '',
            skillData['levels'][skillLevel]['blackboard'] ?? [],
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
        .replaceAll(RegExp(r'<\$ba\.dt\.element>'), '')
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

          return ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: widget.screenHeight * 0.3,
              minHeight: 0,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (rarity > 2)
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Skills",
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  if (rarity > 2)
                                    SizedBox(
                                      height: widget.screenHeight * 0.045,
                                      child: ElevatedButton(
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
                                          if (operatorSkills.isNotEmpty &&
                                              operatorSkills.length > 0) {
                                            final skillId = operatorSkills[0]
                                                    ['skillId']
                                                .toString();
                                            final skillData = skills[skillId];
                                            if (skillData != null) {
                                              final levels =
                                                  skillData['levels'];
                                              if (skillLevel < maxSkillLevel) {
                                                setState(() {
                                                  skillName = levels[skillLevel]
                                                          ?['name'] ??
                                                      '';
                                                  skillDescription =
                                                      replaceDescription(
                                                    levels[skillLevel]
                                                            ?['description'] ??
                                                        '',
                                                    levels[skillLevel]
                                                            ?['blackboard'] ??
                                                        [],
                                                  );
                                                  selected = 1;
                                                });
                                              }
                                            }
                                          }
                                        },
                                        child: const Text('1',
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ),
                                    ),
                                  if (rarity > 3)
                                    SizedBox(
                                      height: widget.screenHeight * 0.045,
                                      child: ElevatedButton(
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
                                          if (operatorSkills.isNotEmpty &&
                                              operatorSkills.length > 1) {
                                            final skillId = operatorSkills[1]
                                                    ['skillId']
                                                .toString();
                                            final skillData = skills[skillId];
                                            if (skillData != null) {
                                              final levels =
                                                  skillData['levels'];
                                              if (skillLevel < maxSkillLevel) {
                                                setState(() {
                                                  skillName = levels[skillLevel]
                                                          ?['name'] ??
                                                      '';
                                                  skillDescription =
                                                      replaceDescription(
                                                    levels[skillLevel]
                                                            ?['description'] ??
                                                        '',
                                                    levels[skillLevel]
                                                            ?['blackboard'] ??
                                                        [],
                                                  );
                                                  selected = 2;
                                                });
                                              }
                                            }
                                          }
                                        },
                                        child: const Text('2',
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ),
                                    ),
                                  if (rarity > 5)
                                    SizedBox(
                                      height: widget.screenHeight * 0.045,
                                      child: ElevatedButton(
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
                                          if (operatorSkills.isNotEmpty &&
                                              operatorSkills.length > 2) {
                                            final skillId = operatorSkills[2]
                                                    ['skillId']
                                                .toString();
                                            final skillData = skills[skillId];
                                            if (skillData != null) {
                                              final levels =
                                                  skillData['levels'];
                                              if (skillLevel < maxSkillLevel) {
                                                setState(() {
                                                  skillName = levels[skillLevel]
                                                          ?['name'] ??
                                                      '';
                                                  skillDescription =
                                                      replaceDescription(
                                                    levels[skillLevel]
                                                            ?['description'] ??
                                                        '',
                                                    levels[skillLevel]
                                                            ?['blackboard'] ??
                                                        [],
                                                  );
                                                  selected = 3;
                                                });
                                              }
                                            }
                                          }
                                        },
                                        child: const Text('3',
                                            style:
                                                TextStyle(color: Colors.black)),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Text(
                              "S${skillLevel > 6 ? 7 : skillLevel + 1}M${skillLevel > 6 ? skillLevel % 6 : 0}",
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 25),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        skillName,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                      ),
                                      Text(
                                        skillDescription.isNotEmpty
                                            ? skillDescription
                                            : "No skill description available.",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                        ),
                                        softWrap: true,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                                child: SliderTheme(
                                  data: SliderThemeData(
                                    activeTrackColor:
                                        Theme.of(context).colorScheme.onSurface,
                                    inactiveTrackColor:
                                        Theme.of(context).colorScheme.surfaceTint,
                                    thumbColor: Theme.of(context)
                                        .colorScheme
                                        .inverseSurface,
                                  ),
                                  child: Slider(
                                    label: "Level",
                                    value: skillLevel.toDouble(),
                                    onChanged: (value) {
                                      setState(() {
                                        skillLevel = value.toInt();
                                        if (skillLevel >= maxSkillLevel) {
                                          skillLevel = maxSkillLevel - 1;
                                        }
                                      });
                                      final operatorSkills =
                                          widget.operator['skills'] ?? [];
                                      if (operatorSkills.isNotEmpty) {
                                        final skillId =
                                            operatorSkills[selected - 1]
                                                ['skillId'];
                                        _loadSkillData(skillId);
                                      }
                                    },
                                    min: 0,
                                    max: (maxSkillLevel - 1).toDouble(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
