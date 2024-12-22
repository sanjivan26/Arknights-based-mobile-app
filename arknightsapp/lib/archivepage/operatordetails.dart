import './../colorfab.dart';
import 'package:flutter/material.dart';
import './operatorinfo.dart';
import './trait.dart';
import './skills.dart';
import './talent.dart';

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
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(),
            itemCount: 4,
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return OperatorInfo(operator: operator);
                case 1:
                  return Trait(operator: operator);
                case 2:
                  return Skills(operator: operator);
                case 3:
                  return Talent(operator: operator);
                default:
                  return SizedBox.shrink(); 
              }
            },
          ),
        ),
      ),
    );
  }
}
