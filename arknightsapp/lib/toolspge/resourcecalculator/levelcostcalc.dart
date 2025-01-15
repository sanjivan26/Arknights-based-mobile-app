import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import './../../colorfab.dart';

class LevelCostCalc extends StatefulWidget {
  const LevelCostCalc({super.key});

  @override
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

  void resourceCalculator() {
    if (endElite < startElite ||
        (endElite == startElite && endLevel < startLevel)) {
      setState(() {
        calculatedResources = {"lmd": 0, "exp": 0};
      });
      return;
    }
    setState(() {
      calculatedResources["lmd"] =
          (endElite - startElite) * 1000 + (endLevel - startLevel) * 50;
      calculatedResources["exp"] =
          (endElite - startElite) * 2000 + (endLevel - startLevel) * 100;
    });
  }

  @override
  void initState() {
    super.initState();
    resourceCalculator();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorFab.offWhite,
      appBar: AppBar(
        backgroundColor: ColorFab.offWhite,
        title: const Text("Resource Estimator"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text("Choose Operator Rarity", style: const TextStyle(fontSize: 16)),
            _buildDropdown(rarities, selectedRarity,
                (value) {
              selectedRarity = value;
              resourceCalculator();
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
                      startElite = elite;
                      startLevel = level;
                      resourceCalculator();
                    },
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: _buildEliteLevelInfo(
                    "Ending Stats",
                    endElite,
                    endLevel,
                    (elite, level) {
                      endElite = elite;
                      endLevel = level;
                      resourceCalculator();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              "Required Resources",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildResourceDisplay(),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(List<Map<String, dynamic>> items,
      int value, Function(int) onChanged) {
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
                        style: const TextStyle(fontSize: 16),
                      ),
                    ))
                .toList(),
            value: value,
            onChanged: (selectedValue) {
              if (selectedValue != value) {
                setState(() {
                  onChanged(selectedValue!); 
                });
                resourceCalculator(); 
              }
            },
            dropdownStyleData: DropdownStyleData(
              maxHeight: 200,
              decoration: BoxDecoration(
                color: ColorFab.lightShadow,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            buttonStyleData: ButtonStyleData(
              height: 50,
              decoration: BoxDecoration(
                color: ColorFab.lightGrey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEliteLevelInfo(String label, int elite, int level,
      Function(int elite, int level) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              _buildDropdown(elites, elite, (value) {
                  onChanged(value, level);
                }),
              const SizedBox(height: 8),
              TextField(
                  decoration: const InputDecoration(
                    labelText: "Level",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    onChanged(elite, int.tryParse(value) ?? level);
                  },
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
        color: ColorFab.darkGrey,
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
