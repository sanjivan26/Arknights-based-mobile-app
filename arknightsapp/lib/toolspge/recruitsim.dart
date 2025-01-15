import 'package:arknightsapp/toolspge/recruitopdisplay.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as math;
import './../colorfab.dart';
import 'operatordisplay.dart';

class RecruitSim extends StatefulWidget {
  const RecruitSim({super.key});

  @override
  State<RecruitSim> createState() => _RecruitSimState();
}

class _RecruitSimState extends State<RecruitSim> {
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

  late Future<Map<String, dynamic>> _recruitsFuture;
  Map<String, dynamic>? _recruitsData;
  List<Map<String, dynamic>> _currentResults = [];
  Set<String> selectedTags = {};

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
      _recruitsData = json.decode(response.body);
      return _recruitsData!;
    } else {
      throw Exception('Failed to load recruits');
    }
  }

  void _toggleTag(String tag) {
    setState(() {
      if (selectedTags.contains(tag)) {
        selectedTags.remove(tag);
      } else if (selectedTags.length < 5) {
        selectedTags.add(tag);
      }
      _updateResults();
    });
  }

  List<List<String>> _getCombinations(List<String> list) {
    if (list.isEmpty) return [];

    List<List<String>> result = [];
    int n = list.length;

    for (int size = 1; size <= math.min(3, n); size++) {
      for (int i = 0; i < (1 << n); i++) {
        int bits = i.toRadixString(2).split('1').length - 1;
        if (bits != size) continue;

        List<String> combination = [];
        for (int j = 0; j < n; j++) {
          if ((i & (1 << j)) != 0) {
            combination.add(list[j]);
          }
        }
        result.add(combination);
      }
    }
    return result;
  }

  void _updateResults() {
    if (_recruitsData == null) return;

    final List<String> tagsList = selectedTags.toList()..sort();
    final combinations = _getCombinations(tagsList);

    List<Map<String, dynamic>> newResults = [];

    for (var combination in combinations) {
      final combinationKey = combination.join(',');
      if (_recruitsData!.containsKey(combinationKey)) {
        final recruitsList =
            _recruitsData![combinationKey]['operators'] as List;
        if (recruitsList.isNotEmpty) {
          newResults.add({
            'key': combinationKey,
            'recruitIds':
                recruitsList.map<String>((r) => r['id'] as String).toList(),
          });
        }
      }
    }

    setState(() {
      _currentResults = newResults;
    });
  }

  Widget _buildTagSection(String label, List<String> availableTags) {
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
          children: availableTags.map((tag) {
            final isSelected = selectedTags.contains(tag);
            return GestureDetector(
              onTap: () => _toggleTag(tag),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recruit Simulator"),
        backgroundColor: ColorFab.offWhite,
      ),
      backgroundColor: ColorFab.offWhite,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _recruitsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedTags.clear();
                            _updateResults();
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(ColorFab.redAccent),
                          foregroundColor:
                              MaterialStateProperty.all(ColorFab.offWhite),
                        ),
                        child: const Text("Reset Selected Tags"),
                      ),
                      const SizedBox(height: 10),
                      _buildTagSection("Based on Rarity", tags["Rarity"]!),
                      const SizedBox(height: 10),
                      _buildTagSection("Based on Position", tags["Position"]!),
                      const SizedBox(height: 10),
                      _buildTagSection("Based on Class", tags["Class"]!),
                      const SizedBox(height: 10),
                      _buildTagSection("Other Tags", tags["Other"]!),
                      if (_currentResults.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        const Text(
                          "Recruitable Operators",
                          style: TextStyle(
                            color: ColorFab.offBlack,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index >= _currentResults.length) return null;

                    final result = _currentResults[index];
                    final combinationKey = result['key'] as String;
                    final recruitIds = result['recruitIds'] as List<String>;

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Column(
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
                          const SizedBox(height: 4),
                          ...recruitIds.map((id) => Text(
                                id,
                                style: const TextStyle(
                                  color: ColorFab.offBlack,
                                  fontSize: 12,
                                ),
                              )),
                        ],
                      ),
                    );
                  },
                  childCount: _currentResults.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
