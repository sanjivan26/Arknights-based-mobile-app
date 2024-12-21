import 'package:flutter/material.dart';
import './imagemapping.dart';

class OperatorDetails extends StatelessWidget {
  final dynamic operator;

  const OperatorDetails({super.key, required this.operator});

  @override
  Widget build(BuildContext context) {

    String imagePath = imageMapping[operator['name']] ?? imageMapping['default']!;

    return Scaffold(
      appBar: AppBar(
        title: Text(operator['name'] ?? 'Operator Details'),  
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,  
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            Text(
              operator['name']!,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
