import 'package:arknightsapp/theme/raritycode.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math' as math;
import '../../../colorfab.dart';
import './../../archivepage/operatortile.dart';

class JsonCache {
  static final Map<String, String> _cache = {};

  static String? get(String key) {
    return _cache[key];
  }

  static void set(String key, String jsonString) {
    _cache[key] = jsonString;
  }

  static void clear() {
    _cache.clear();
  }
}

class RecruitSim extends StatefulWidget {
  const RecruitSim({super.key});

  @override
  State<RecruitSim> createState() => _RecruitSimState();
}

class _RecruitSimState extends State<RecruitSim> {
  late Future<Map<String, dynamic>> _operatorsFuture;
  bool _isLoading = false;

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
    _operatorsFuture = fetchOperators();
  }

  Future<Map<String, dynamic>> fetchOperators() async {
    setState(() => _isLoading = true);
    try {
      var cachedData = JsonCache.get('operatorData');

      if (cachedData != null) {
        final parsedData = json.decode(cachedData) as Map<String, dynamic>;
        return parsedData;
      }

      final url = Uri.parse(
          'https://raw.githubusercontent.com/Kengxxiao/ArknightsGameData_YoStar/main/en_US/gamedata/excel/character_table.json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        JsonCache.set('operatorData', response.body);
        final parsedData = json.decode(response.body) as Map<String, dynamic>;
        return parsedData;
      } else {
        throw Exception('Failed to load operators');
      }
    } finally {
      setState(() => _isLoading = false);
    }
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
    final keyList = combinations
        .where(
            (combination) => _recruitsData!.containsKey(combination.join(',')))
        .map((e) => e.join(','));
    final List<String> sortedKeyList = keyList.toList()
      ..sort((a, b) {
        final guaranteesA = (_recruitsData![a]["guarantees"] as List).isEmpty
            ? 0
            : (_recruitsData![a]["guarantees"] as List).first;
        final guaranteesB = (_recruitsData![b]["guarantees"] as List).isEmpty
            ? 0
            : (_recruitsData![b]["guarantees"] as List).first;
        return guaranteesB.compareTo(guaranteesA);
      });

    setState(() {
      _currentResults = sortedKeyList.map((combinationKey) {
        final recruitsList =
            _recruitsData![combinationKey]['operators'] as List;
        return {
          'key': combinationKey,
          'recruitIds':
              recruitsList.map<String>((r) => r['id'] as String).toList(),
        };
      }).toList();
    });
  }

  Widget _buildTagSection(String label, List<String> availableTags) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.inverseSurface,
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
                  color: isSelected
                      ? Theme.of(context).colorScheme.onSecondary
                      : Theme.of(context).colorScheme.onTertiary,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? ColorFab.grey : ColorFab.midAccent,
                  ),
                ),
                child: Text(
                  tag,
                  style: TextStyle(color: Color(0xFF181818)),
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
        title: Text(
          "Recruit Simulator",
          style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: FutureBuilder<Map<String, dynamic>>(
        future: _recruitsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              _isLoading) {
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
                          backgroundColor: WidgetStateProperty.all(
                              Theme.of(context).colorScheme.onError),
                          foregroundColor:
                              WidgetStateProperty.all(ColorFab.offWhite),
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
                        Text(
                          "Recruitable Operators",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inverseSurface,
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
                    final confirmedRarity =
                        _recruitsData![combinationKey]["guarantees"].isEmpty
                            ? 0
                            : _recruitsData![combinationKey]["guarantees"][0];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const SizedBox(width: 5),
                              if (confirmedRarity != 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: rarityCode(confirmedRarity),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        confirmedRarity == 0
                                            ? ''
                                            : confirmedRarity.toString(),
                                        style: TextStyle(
                                          color: Color(0xFF181818),
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(
                                        Icons.star,
                                        size: 14,
                                        color: Color(0xFF181818),
                                      ),
                                    ],
                                  ),
                                ),
                              const SizedBox(width: 5),
                              Text(
                                combinationKey,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inverseSurface,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          FutureBuilder<Map<String, dynamic>>(
                            future: _operatorsFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              if (snapshot.hasError) {
                                return Text('Error loading operators');
                              }
                              final operatorsData = snapshot.data!;
                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: (recruitIds.length / 4)
                                    .ceil(), 
                                itemBuilder: (context, rowIndex) {
                                  final startIndex = rowIndex * 4;
                                  final endIndex = math.min(
                                      startIndex + 4, recruitIds.length);
                                  final rowItemCount = endIndex - startIndex;

                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: List.generate(
                                        4,
                                        (columnIndex) {
                                          if (columnIndex < rowItemCount) {
                                            final index =
                                                startIndex + columnIndex;
                                            final operatorId = recruitIds[index];
                                            final operator =
                                                operatorsData[operatorId];

                                            return Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 3),
                                                child: OperatorTile(
                                                  operator, 
                                                  operatorId,
                                                  key: ValueKey(operatorId),
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 3),
                                                child: Container(
                                                  height:
                                                      100, // Set a fixed height for the placeholder
                                                  color: Colors
                                                      .transparent, // Make it invisible
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
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
