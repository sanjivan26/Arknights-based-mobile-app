import 'package:arknightsapp/archivepage/imagemapping.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './../colorfab.dart';

class OperatorInfo extends StatefulWidget {
  final dynamic operator;
  const OperatorInfo({super.key, required this.operator});

  @override
  State<OperatorInfo> createState() => _OperatorInfoState();
}

class _OperatorInfoState extends State<OperatorInfo> {
  late Future<Map<String, dynamic>> _factionsFuture;

  @override
  void initState() {
    super.initState();
    _factionsFuture = fetchFactions();
  }

  Future<Map<String, dynamic>> fetchFactions() async {
    final url = Uri.parse(
        'https://raw.githubusercontent.com/Kengxxiao/ArknightsGameData_YoStar/refs/heads/main/en_US/gamedata/excel/handbook_team_table.json');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load factions');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _factionsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final factions = snapshot.data!;

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

          String factionName = factions[widget.operator['nationId']]
                  ?['powerName'] ??
              factions[widget.operator['groupId']]?['powerName'] ??
              factions[widget.operator['teamId']]?['powerName'] ??
              'Unknown Faction';

          String imagePath =
              imageMapping[widget.operator['name']] ?? imageMapping['default']!;
          double screenWidth = MediaQuery.of(context).size.width;
          double imageSize = screenWidth * 0.20;

          return Container(
            margin: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: ColorFab.lightShadow,
              borderRadius:
                  BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: ColorFab.darkAccent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(75),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(75),
                    child: Image.asset(
                      imagePath,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Container(
                  constraints: BoxConstraints(minHeight: 40, maxHeight: 90),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.operator['name'] ?? 'Unknown Operator',
                          style: TextStyle(
                            color: ColorFab.darkAccent,
                            fontSize: 18,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: List.generate(
                          rarity,
                          (index) => Icon(
                            Icons.star,
                            size: 22,
                            color: ColorFab.darkAccent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.operator['profession'] ?? '',
                        style: TextStyle(fontSize: 15, color: ColorFab.darkAccent),
                      ),
                      Text(
                        factionName,
                        style: TextStyle(fontSize: 15, color: ColorFab.darkAccent),
                      ),
                    ],
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
