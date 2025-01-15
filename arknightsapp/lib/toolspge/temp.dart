import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './../colorfab.dart';

class RecruitSim extends StatefulWidget {
  const RecruitSim({super.key});

  @override
  State<RecruitSim> createState() => _RecruitSimState();
}

class _RecruitSimState extends State<RecruitSim> {
  late Future<Map<String, dynamic>> _recruitsFuture;

  @override
  void initState() {
    super.initState();
    _recruitsFuture = fetchRecruits();
  }

  Future<Map<String, dynamic>> fetchRecruits() async {
    final url = Uri.parse(
        'https://raw.githubusercontent.com/neeia/ak-roster/refs/heads/main/src/data/recruitment.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load recruits');
    }
  }

  final Map<String, List<String>> tags = {
    "Rarity": ["Top Operator", "Senior Operator", "Starter", "Robot"],
    "Position": ["Melee", "Ranged"],
    "Class": [
      "Caster",
      "Defender",
      "Guard",
      "Medic",
      "Sniper",
      "Specialist",
      "Supporter",
      "Vanguard",
    ],
    "Other": [
      "AoE",
      "Crowd-Control",
      "DP-Recovery",
      "DPS",
      "Debuff",
      "Defense",
      "Fast-Redeploy",
      "Healing",
      "Nuker",
      "Shift",
      "Slow",
      "Summon",
      "Support",
      "Survival",
    ],
  };

  final List<String> rarityTags = [];
  final List<String> positionTags = [];
  final List<String> classTags = [];
  final List<String> otherTags = [];

  void toggleTag(List<String> tagList, String tag) {
    setState(() {
      int totalSelectedTags = rarityTags.length +
          positionTags.length +
          classTags.length +
          otherTags.length;

      if (tagList.contains(tag)) {
        tagList.remove(tag);
      } else if (totalSelectedTags < 5) {
        tagList.add(tag);
      }
    });
  }

  Widget buildTagSection(
      String label, List<String> tagList, List<String> tags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: ColorFab.offBlack,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: tags.map((tag) {
            final isSelected = tagList.contains(tag);
            return GestureDetector(
              onTap: () => toggleTag(tagList, tag),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: isSelected ? ColorFab.midAccent : Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? ColorFab.grey : ColorFab.midAccent,
                  ),
                ),
                child: Text(
                  tag,
                  style: TextStyle(color: ColorFab.offWhite),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  List<List<String>> getCombinations(List<String> list) {
    List<List<String>> result = [];
    int n = list.length;

    for (int size = 1; size <= 3; size++) {
      for (int i = 0; i < (1 << n); i++) {
        List<String> combination = [];
        for (int j = 0; j < n; j++) {
          if ((i & (1 << j)) != 0) {
            combination.add(list[j]);
          }
        }
        if (combination.length == size) {
          result.add(combination);
        }
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final finalKey = [
      ...rarityTags,
      ...positionTags,
      ...classTags,
      ...otherTags
    ]..sort();

    final combinations = getCombinations(finalKey);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Recruit Simulator"),
        backgroundColor: ColorFab.offWhite,
      ),
      backgroundColor: ColorFab.offWhite,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    rarityTags.clear();
                    positionTags.clear();
                    classTags.clear();
                    otherTags.clear();
                  });
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(ColorFab.redAccent),
                  foregroundColor: WidgetStateProperty.all(ColorFab.offWhite),
                ),
                child: const Text("Reset Selected Tags"),
              ),
              const SizedBox(height: 10),
              buildTagSection("Based on Rarity", rarityTags, tags["Rarity"]!),
              const SizedBox(height: 10),
              buildTagSection(
                  "Based on Position", positionTags, tags["Position"]!),
              const SizedBox(height: 10),
              buildTagSection("Based on Class", classTags, tags["Class"]!),
              const SizedBox(height: 10),
              buildTagSection("Other Tags", otherTags, tags["Other"]!),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              const Text(
                "Recruitable Operators",
                style: TextStyle(
                  color: ColorFab.offBlack,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Mapping combinations to display matching recruits
              FutureBuilder<Map<String, dynamic>>(
                future: _recruitsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    final recruitsData = snapshot.data!;
                    return Column(
                      children: combinations.map((combination) {
                        final combinationKey = combination.join(',');
                        final recruitsList =
                            recruitsData[combinationKey]?['operators'] ?? [];

                        if (recruitsList.isEmpty) {
                          return SizedBox.shrink();
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              combinationKey,
                              style: const TextStyle(
                                color: ColorFab.offBlack,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ...recruitsList.map((recruit) {
                              return Text(
                                recruit['name'],
                                style: const TextStyle(
                                  color: ColorFab.offBlack,
                                  fontSize: 14,
                                ),
                              );
                            }).toList(),
                          ],
                        );
                      }).toList(),
                    );
                  }
                  return SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
