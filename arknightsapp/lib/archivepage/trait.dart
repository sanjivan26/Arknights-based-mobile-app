import 'package:flutter/material.dart';

class Trait extends StatelessWidget {
  final Map<String, dynamic> operator;
  const Trait({super.key, required this.operator});

  @override
  Widget build(BuildContext context) {
    String description = (operator['description'])
        .replaceAll(RegExp(r'<\/?>'), '')
        .replaceAll(RegExp(r'<@ba\..{2,7}>'), '')
        .replaceAll(RegExp(r'<\@ba\.[a-zA-Z_]*>'), '')
        .replaceAll(RegExp(r'<\@ba\.dt\.element>'), '')
        .replaceAll(RegExp(r'(to\s)?\{[A-Za-z_]+(:0%)?\}[\s]?'), '');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Trait',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Text(
            description,
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
