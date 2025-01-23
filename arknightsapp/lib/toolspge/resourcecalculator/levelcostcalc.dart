// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class LevelCostCalc extends StatefulWidget {
  const LevelCostCalc({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LevelCostCalcState createState() => _LevelCostCalcState();
}

class _LevelCostCalcState extends State<LevelCostCalc> {
  final rarities = [
    {"label": "6 Star", "value": 6},
    {"label": "5 Star", "value": 5},
    {"label": "4 Star", "value": 4},
    {"label": "3 Star", "value": 3},
    {"label": "2 Star", "value": 2},
    {"label": "1 Star", "value": 1},
  ];

  final elites = [
    {"label": "Elite 0", "value": 0},
    {"label": "Elite 1", "value": 1},
    {"label": "Elite 2", "value": 2},
  ];

  int selectedRarity = 6;
  int startElite = 0;
  int startLevel = 1;
  int endElite = 0;
  int endLevel = 1;

  Map<String, int> calculatedResources = {"lmd": 0, "exp": 0};
  Map<String, dynamic>? costDataObj;

  late TextEditingController startLevelController;
  late TextEditingController endLevelController;

  @override
  void initState() {
    super.initState();
    startLevelController = TextEditingController(text: startLevel.toString());
    endLevelController = TextEditingController(text: endLevel.toString());
    _loadJsonData();
  }

  @override
  void dispose() {
    startLevelController.dispose();
    endLevelController.dispose();
    super.dispose();
  }

  Future<void> _loadJsonData() async {
    try {
      String costData =
          await rootBundle.loadString('assets/data/explmdcost.json');
      setState(() {
        costDataObj = json.decode(costData);
        print(json.encode(
            costDataObj?["maxlvl"]?[selectedRarity - 1]?[startElite] is int));
      });
    } catch (e) {
      print("Error loading JSON data: $e");
    }
  }

  void inputValidifier() {
    FocusScope.of(context).unfocus();

    int getJsonInt(dynamic value) {
      if (value == null) return 1;
      if (value is int) return value;
      if (value is num) return value.toInt();
      return 1;
    }

    int newStartLevel = int.tryParse(startLevelController.text) ?? startLevel;
    int newEndLevel = int.tryParse(endLevelController.text) ?? endLevel;

    final startMaxLevel =
        getJsonInt(costDataObj?["maxlvl"][selectedRarity - 1][startElite]);
    final endMaxLevel =
        getJsonInt(costDataObj?["maxlvl"][selectedRarity - 1][endElite]);

    setState(() {
      if (newStartLevel < 1) {
        newStartLevel = 1;
      } else if (newStartLevel > startMaxLevel) {
        newStartLevel = startMaxLevel;
      }

      if (newEndLevel < 1) {
        newEndLevel = 1;
      } else if (newEndLevel > endMaxLevel) {
        newEndLevel = endMaxLevel;
      }

      if (startElite > endElite) {
        endElite = startElite;
      }

      if (startElite == endElite && startLevel > endLevel) {
        newEndLevel = newStartLevel;
      }

      startLevel = newStartLevel;
      endLevel = newEndLevel;

      startLevelController.text = startLevel.toString();
      endLevelController.text = endLevel.toString();

      resourceCalculator();
    });
  }

  void resourceCalculator() {
    final int rarity = selectedRarity;
    int lmd = 0;
    int exp = 0;
    int curElite = startElite;
    int curLevel = startLevel;

    try {
      int getJsonInt(dynamic value) {
        if (value == null) return 0;
        if (value is int) return value;
        if (value is num) return value.toInt();
        return 0;
      }

      while (curElite < endElite) {
        final maxLevel =
            getJsonInt(costDataObj?["maxlvl"][rarity - 1][curElite]);

        if (curLevel >= maxLevel) {
          final promotionCost =
              getJsonInt(costDataObj?["promotionCost"][rarity - 1][curElite]);
          lmd += promotionCost;
          curElite += 1;
          curLevel = 1;
        } else {
          final expCost =
              getJsonInt(costDataObj?["expCost"][curElite][curLevel - 1]);
          final lmdCost =
              getJsonInt(costDataObj?["lmdCost"][curElite][curLevel - 1]);
          exp += expCost;
          lmd += lmdCost;
          curLevel++;
        }
      }

      while (curLevel < endLevel) {
        final expCost =
            getJsonInt(costDataObj?["expCost"][curElite][curLevel - 1]);
        final lmdCost =
            getJsonInt(costDataObj?["lmdCost"][curElite][curLevel - 1]);
        exp += expCost;
        lmd += lmdCost;
        curLevel++;
      }

      setState(() {
        calculatedResources["lmd"] = lmd;
        calculatedResources["exp"] = exp;
      });
    } catch (error) {
      print("Error during calculation: $error");
      setState(() {
        calculatedResources["lmd"] = 0;
        calculatedResources["exp"] = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: Text(
            "Resource Estimator",
            style:
                TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
          ),
        ),
        body: costDataObj == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text("Choose Operator Rarity",
                        style: TextStyle(
                            fontSize: 16,
                            color:
                                Theme.of(context).colorScheme.inverseSurface)),
                    _buildDropdown(rarities, selectedRarity, (value) {
                      setState(() {
                        selectedRarity = value;
                      });
                      inputValidifier();
                    }),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildEliteLevelInfo(
                            "Starting Stats",
                            startElite,
                            startLevel,
                            (elite, level) {
                              setState(() {
                                startElite = elite;
                                startLevel = level;
                              });
                            },
                            startLevelController,
                          ),
                        ),
                        Container(
                            alignment: Alignment.center,
                            child: Icon(
                              Icons.double_arrow,
                              size: 30.0,
                              color:
                                  Theme.of(context).colorScheme.inverseSurface,
                            )),
                        Expanded(
                          child: _buildEliteLevelInfo(
                            "Ending Stats",
                            endElite,
                            endLevel,
                            (elite, level) {
                              setState(() {
                                endElite = elite;
                                endLevel = level;
                              });
                            },
                            endLevelController,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Required Resources",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.inverseSurface),
                    ),
                    const SizedBox(height: 10),
                    _buildResourceDisplay(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildDropdown(
      List<Map<String, dynamic>> items, int value, Function(int) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonHideUnderline(
          child: DropdownButton2(
            isExpanded: true,
            items: items
                .map((item) => DropdownMenuItem<int>(
                      value: item["value"],
                      child: Text(
                        item["label"],
                        style: TextStyle(
                            fontSize: 16,
                            color:Color(0xFFF2F3F4)),
                      ),
                    ))
                .toList(),
            value: value,
            onChanged: (selectedValue) {
              if (selectedValue != value) {
                onChanged(selectedValue!);
                inputValidifier();
              }
            },
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryFixedDim,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            buttonStyleData: ButtonStyleData(
              height: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryFixedDim,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEliteLevelInfo(
      String label,
      int elite,
      int level,
      Function(int elite, int level) onChanged,
      TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.inverseSurface)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildDropdown(elites, elite, (value) {
                onChanged(value, level);
                inputValidifier();
              }),
              const SizedBox(height: 8),
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: "Level",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final newLevel = int.tryParse(value) ?? level;
                  onChanged(elite, newLevel);
                },
                onSubmitted: (value) {
                  inputValidifier();
                },
                textInputAction: TextInputAction.done,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildResourceDisplay() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryFixedDim,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "LMD: ${calculatedResources["lmd"]}",
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
          Text(
            "EXP: ${calculatedResources["exp"]}",
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
