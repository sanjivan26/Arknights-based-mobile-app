import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import './operatortile.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

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

class ArchiveContent extends StatefulWidget {
  const ArchiveContent({super.key});

  @override
  State<ArchiveContent> createState() => _ArchiveContentState();
}

class _ArchiveContentState extends State<ArchiveContent> {
  late Future<Map<String, dynamic>> _operatorsFuture;
  List<dynamic> _allOperators = [];
  List<dynamic> _filteredOperators = [];
  String _searchText = '';
  List<String> _selectedClasses = [];
  List<int> _selectedRarities = [];
  Timer? _debounceTimer;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _operatorsFuture = fetchOperators();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<Map<String, dynamic>> fetchOperators() async {
  setState(() => _isLoading = true);
  try {
    var cachedData = JsonCache.get('operatorData');

    if (cachedData != null) {
      final parsedData = json.decode(cachedData) as Map<String, dynamic>;
      await _initializeOperators(parsedData);
      return parsedData;
    }

    final url = Uri.parse(
        'https://raw.githubusercontent.com/Kengxxiao/ArknightsGameData_YoStar/main/en_US/gamedata/excel/character_table.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      JsonCache.set('operatorData', response.body);
      final parsedData = json.decode(response.body) as Map<String, dynamic>;
      await _initializeOperators(parsedData);
      return parsedData;
    } else {
      throw Exception('Failed to load operators');
    }
  } finally {
    setState(() => _isLoading = false);
  }
}


  Future<void> _initializeOperators(Map<String, dynamic> data) async {
    _allOperators = data.entries
        .where((entry) => entry.key.startsWith('char'))
        .map((entry) => entry.value)
        .toList();
    
    _allOperators.sort((a, b) => 
      (a['name'] as String).compareTo(b['name'] as String)
    );
    
    _filteredOperators = List.from(_allOperators);
  }

  void filterOperators() {
    if (_isLoading) return;

    if (_searchText.isEmpty && _selectedClasses.isEmpty && _selectedRarities.isEmpty) {
      setState(() {
        _filteredOperators = List.from(_allOperators);
      });
      return;
    }

    final searchLower = _searchText.toLowerCase();
    setState(() {
      _filteredOperators = _allOperators.where((op) {
        if (_searchText.isNotEmpty &&
            !op['name'].toString().toLowerCase().contains(searchLower)) {
          return false;
        }
        
        if (_selectedClasses.isNotEmpty &&
            !_selectedClasses.contains(op['profession'])) {
          return false;
        }

        if (_selectedRarities.isNotEmpty) {
          var rarityValue = op['rarity'];
          int rarity = int.tryParse(rarityValue.substring(rarityValue.length - 1)) ?? 0;
          if (!_selectedRarities.contains(rarity)) {
            return false;
          }
        }

        return true;
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
          return Container(
            color: Theme.of(context).colorScheme.surface,
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
                    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
                    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
                      if (mounted) {
                        _searchText = value;
                        filterOperators();
                      }
                    });
                  },
                ),
                const SizedBox(height: 10),
                MultiSelectDialogField<String>(
                  selectedItemsTextStyle: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
                  selectedColor: Theme.of(context).colorScheme.inverseSurface,
                  backgroundColor: Theme.of(context).colorScheme.onTertiary,
                  checkColor: Theme.of(context).colorScheme.surfaceContainer,

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
                  title: Text('Select Classes',style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface)),
                  initialValue: _selectedClasses,
                  buttonText: Text("Select Classes",style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface)),
                  onConfirm: (selectedClasses) {
                    if (mounted) {
                      _selectedClasses = selectedClasses.cast<String>();
                      filterOperators();
                    }
                  },
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Text("Choose Rarity:",style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),),
                    ),
                    ...List.generate(6, (rarity) {
                      return GestureDetector(
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              if (_selectedRarities.contains(rarity + 1)) {
                                _selectedRarities.remove(rarity + 1);
                              } else {
                                _selectedRarities.add(rarity + 1);
                              }
                            });
                            filterOperators();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: _selectedRarities.contains(rarity + 1)
                                ? Theme.of(context).colorScheme.onSecondary
                                : Theme.of(context).colorScheme.onTertiary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            (rarity + 1).toString(),
                            style: TextStyle(color: Color(0xFFF2F3F4)),
                          ),
                        ),
                      );
                    }),
                    GestureDetector(
                      onTap: () {
                        if (mounted) {
                          setState(() {
                            _selectedRarities = [];
                          });
                          filterOperators();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.error,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Clear",
                          style: TextStyle(color: Color(0xFFF2F3F4)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 3,
                      mainAxisSpacing: 3,
                      childAspectRatio: 0.825,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    itemCount: _filteredOperators.length,
                    cacheExtent: 500,
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: true,
                    itemBuilder: (context, index) {
                      final operator = _filteredOperators[index];
                      return RepaintBoundary(
                        child: OperatorTile(
                          operator,
                          key: ValueKey('operator_${operator['name']}'),
                        ),
                      );
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