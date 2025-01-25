import 'package:flutter/material.dart';
import './operatorinfo.dart';
import './trait.dart';
import './skills.dart';
import './talent.dart';

class OperatorDetails extends StatelessWidget {
  final dynamic operator;
  final String opKey;

  const OperatorDetails({super.key, required this.operator, required this.opKey});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Theme(
      data: Theme.of(context).copyWith(
        dividerTheme: DividerThemeData(
          color: Theme.of(context).colorScheme.inverseSurface,
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            operator['name'] ?? 'Operator Details',
            style: TextStyle(color: Theme.of(context).colorScheme.inverseSurface),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
        ),
        body: Container(
          color: Theme.of(context).colorScheme.surface,
          child: ListView(
            children: [
              OperatorInfo(operator: operator, opKey: opKey),
              Divider(),
              Trait(operator: operator),
              Divider(),
              Skills(operator: operator, screenHeight: screenHeight, screenWidth: screenWidth),
              Divider(),
              Talent(operator: operator),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}

