import 'dart:convert';
import '../colorfab.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import './operatortile.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'classmapping.dart';

class ArchiveContent extends StatefulWidget {
  const ArchiveContent({super.key});

  @override
  State<ArchiveContent> createState() => _ArchiveContentState();
}

class _ArchiveContentState extends State<ArchiveContent> {
  late Future<Map<String, dynamic>> _operatorsFuture;
  List<dynamic> _filteredOperators = [];
  String _searchText = '';
  List<String> _selectedClasses = [];
  List<int> _selectedRarities = [];

  @override
  void initState() {
    super.initState();
    _operatorsFuture = fetchOperators();
  }

  Future<Map<String, dynamic>> fetchOperators() async {
    final url = Uri.parse(
        'https://raw.githubusercontent.com/Kengxxiao/ArknightsGameData_YoStar/main/en_US/gamedata/excel/character_table.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load operators');
    }
  }

  void filterOperators(List<dynamic> operators) {
    setState(() {
      _filteredOperators = operators.where((op) {
        final matchesSearch = op['name']
            .toString()
            .toLowerCase()
            .contains(_searchText.toLowerCase());
        final matchesClass = _selectedClasses.isEmpty ||
            _selectedClasses.contains(op['profession']);
        int rarity = 0;
        var rarityValue = op['rarity'];
        rarity =
            int.tryParse(rarityValue.substring(rarityValue.length - 1)) ?? 0;
        final matchesRarity =
            _selectedRarities.isEmpty || _selectedRarities.contains(rarity);
        return matchesSearch && matchesClass && matchesRarity;
      }).toList();
    });
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

          if (_filteredOperators.isEmpty) {
            _filteredOperators = operators;
          }

          return Container(
            color: ColorFab.offWhite,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search Operators...',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    _searchText = value;
                    filterOperators(operators);
                  },
                ),
                const SizedBox(height: 10),
                MultiSelectDialogField<String>(
                  searchHint: "Select Required Classes",
                  selectedItemsTextStyle: TextStyle(color: ColorFab.offBlack),
                  selectedColor: ColorFab.offBlack,
                  items: [
                    MultiSelectItem<String>('PIONEER', 'Vanguard'),
                    MultiSelectItem<String>('WARRIOR', 'Guard'),
                    MultiSelectItem<String>('TANK', 'Defender'),
                    MultiSelectItem<String>('SNIPER', 'Sniper'),
                    MultiSelectItem<String>('MEDIC', 'Medic'),
                    MultiSelectItem<String>('CASTER', 'Caster'),
                    MultiSelectItem<String>('SUPPORT', 'Supporter'),
                    MultiSelectItem<String>('SPECIAL', 'Specialist'),
                  ],
                  title: const Text('Select Classes'),
                  initialValue: _selectedClasses,
                  buttonText: const Text("Select Classes"),
                  onConfirm: (selectedClasses) {
                    setState(() {
                      _selectedClasses = selectedClasses.cast<String>();
                    });
                    filterOperators(operators);
                  },
                ),
                const SizedBox(height: 10),
                Padding(
  padding: const EdgeInsets.symmetric(horizontal: 15),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Padding(
        padding: EdgeInsets.only(right: 8),
        child: Text("Choose Rarity:"),
      ),
      ...List.generate(6, (rarity) {
        return GestureDetector(
          onTap: () {
            setState(() {
              if (_selectedRarities.contains(rarity + 1)) {
                _selectedRarities.remove(rarity + 1);
              } else {
                _selectedRarities.add(rarity + 1);
              }
            });
            filterOperators(operators);
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _selectedRarities.contains(rarity + 1)
                  ? ColorFab.midAccent
                  : Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              (rarity + 1).toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      }),
      GestureDetector(
        onTap: () {
          setState(() {
            _selectedRarities = [];
          });
          filterOperators(operators);
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            "Clear",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    ],
  ),
),

                const SizedBox(height: 10),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 3,
                      mainAxisSpacing: 3,
                      childAspectRatio: 0.825,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    itemCount: _filteredOperators.length,
                    itemBuilder: (context, index) {
                      final operator = _filteredOperators[index];
                      return OperatorTile(operator);
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}
