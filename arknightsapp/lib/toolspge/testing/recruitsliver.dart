import 'package:flutter/material.dart';
import '../../colorfab.dart';
import 'recruitopdisplay.dart';

class RecruitSliver extends StatelessWidget {
  final Future<Map<String, dynamic>> recruitsFuture;
  final List<List<String>> combinations;

  const RecruitSliver({
    super.key,
    required this.recruitsFuture,
    required this.combinations,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: recruitsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return SliverToBoxAdapter(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          final recruitsData = snapshot.data!;
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final combination = combinations[index];
                final combinationKey = combination.join(',');
                final recruitsList =
                    recruitsData[combinationKey]?['operators'] ?? [];

                if (recruitsList.isEmpty) {
                  return const SizedBox.shrink();
                }

                List<String> recruitIds = recruitsList.map<String>((recruit) {
                  return recruit['id'] as String;
                }).toList();

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: recruitIds.map((id) {
                          return RecruitOpDisplay(id: id);
                        }).toList(),
                      ),
                    ],
                  ),
                );
              },
              childCount: combinations.length,
            ),
          );
        }
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      },
    );
  }
}
