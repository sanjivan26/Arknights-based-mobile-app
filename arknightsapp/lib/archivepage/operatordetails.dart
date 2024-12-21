import './../colorfab.dart';
import 'package:flutter/material.dart';
import './operatorinfo.dart';
import './trait.dart';
import './skills.dart';

class OperatorDetails extends StatelessWidget {
  final dynamic operator;
  const OperatorDetails({super.key, required this.operator});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        dividerTheme: DividerThemeData(
          color: ColorFab.darkAccent,
          thickness: 1,
          indent: 20,
          endIndent: 20,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(operator['name'] ?? 'Operator Details'),
          backgroundColor: ColorFab.offWhite,
        ),
        body: Container(
          color: ColorFab.offWhite,
          child: Column(
            children: [
              OperatorInfo(operator: operator),
              Divider(),
              Trait(operator: operator),
              Divider(),
              Skills(operator: operator,)
            ],
          ),
        ),
      ),
    );
  }
}
