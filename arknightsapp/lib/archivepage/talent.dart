import 'package:flutter/material.dart';
class Talent extends StatelessWidget {
  final dynamic operator; 

  const Talent({super.key, required this.operator});
 
  @override
  Widget build(BuildContext context) {

    String replaceDescription(String description, List<dynamic> blackboard) {
    final keyValueMap = {
      for (var item in blackboard) item['key']: item['value']
    };
    keyValueMap.forEach((key, value) {
      var uppr = key.toUpperCase();
      description = description
          .replaceAll('{$key:0%}', value.toString())
          .replaceAll('{$key}', value.toString())
          .replaceAll('{$uppr}', value.toString());
    });
    return description
        .replaceAll(RegExp(r'<\/?>'), '')
        .replaceAll(RegExp(r'<@ba\..{2,7}>'), '')
        .replaceAll(RegExp(r'<\$ba\.dt\.element>'), '')
        .replaceAll(RegExp(r'<\$ba\.[a-zA-Z_]*>'), '');
  }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Talents',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 3),
          if (operator['talents'] != null && operator['talents'].isNotEmpty)
            ...operator['talents'].map<Widget>((talent) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      talent['candidates'][0]['name'] ?? 'Unnamed Talent',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inverseSurface, 
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      replaceDescription((talent['candidates'][0]['description']), (talent['candidates'][0]['blackboard'])),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface, 
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
        ],
      ),
    );
  }
}
