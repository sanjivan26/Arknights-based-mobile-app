import 'package:flutter/material.dart';

class OperatorDetails extends StatelessWidget {
  // Accepting operator data in the constructor
  final dynamic operator;

  const OperatorDetails({super.key, required this.operator});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(operator['name'] ?? 'Operator Details'),  // Set title to operator's name
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Display operator image (use dynamic image path if needed)
            Image.asset(
              'assets/images/Amiya.jpg',  // You can replace this with operator['image'] if the image is dynamic
              width: 200,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20),
            // Display operator's name
            Text(
              operator['name'] ?? 'Unknown Operator',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            // Display other operator details (you can customize this)
            Text(
              'Class: ${operator['class'] ?? 'N/A'}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Cost: ${operator['cost'] ?? 'N/A'}',
              style: TextStyle(fontSize: 18),
            ),
            // Add more details as needed
          ],
        ),
      ),
    );
  }
}
