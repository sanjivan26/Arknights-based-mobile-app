import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'classmapping.dart';

class OperatorInfo extends StatefulWidget {
  final dynamic operator;
  final String opKey;
  const OperatorInfo({super.key, required this.operator, required this.opKey});

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

          String imagePath = 'assets/avatars/${widget.opKey}.png';
          double screenWidth = MediaQuery.of(context).size.width;
          double imageSize = screenWidth * 0.20;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceTint,
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: imageSize,
                      height: imageSize,
                      decoration: BoxDecoration(
                        color: Color(0xFFD3D3D3),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.inverseSurface,
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
                  ),
                  const SizedBox(width: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.operator['name'] ?? 'Unknown Operator',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inverseSurface,
                          fontSize: 18,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                      Row(
                        children: List.generate(
                          rarity,
                          (index) => Icon(
                            Icons.star,
                            size: 22,
                            color: Theme.of(context).colorScheme.inverseSurface,
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        classMapping[widget.operator['profession']] ?? '',
                        style: TextStyle(
                            fontSize: 15, color: Theme.of(context).colorScheme.onSurface),
                      ),
                      Text(
                        factionName,
                        style: TextStyle(
                            fontSize: 15, color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }
}
