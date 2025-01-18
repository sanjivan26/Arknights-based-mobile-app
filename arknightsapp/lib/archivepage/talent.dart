import 'package:flutter/material.dart';
import './../colorfab.dart'; 
class Talent extends StatelessWidget {
  final dynamic operator; 

  const Talent({super.key, required this.operator});
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Talents',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).colorScheme.inverseSurface,
            ),
          ),
          SizedBox(height: 3,),
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
                      talent['candidates'][0]['description'] ?? 'No description available',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inverseSurface, 
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
