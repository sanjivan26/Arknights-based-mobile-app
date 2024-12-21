import 'package:flutter/material.dart';
import './operatorinfo.dart';

class OperatorDetails extends StatelessWidget {
  final dynamic operator;
  const OperatorDetails({super.key, required this.operator});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(operator['name'] ?? 'Operator Details'),  
      ),
      body:OperatorInfo(operator: operator), 
    );
  }
}
