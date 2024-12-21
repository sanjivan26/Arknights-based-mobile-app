import './../colorfab.dart';
import 'package:flutter/material.dart';

class OperatorTile extends StatefulWidget {
  final dynamic operator;

  const OperatorTile(this.operator, {super.key});

  @override
  State<OperatorTile> createState() => _OperatorTileState();
}

class _OperatorTileState extends State<OperatorTile> {
  @override
  Widget build(BuildContext context) {
    final operator = widget.operator;

    double screenWidth = MediaQuery.of(context).size.width;
    double imageSize = screenWidth * 0.20;

    return Container(
      padding: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        color: ColorFab.darkGrey,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              border: Border.all(
                color: ColorFab.lightGrey,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                'assets/images/Amiya.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Flexible(
            child: Text(
              operator['name'] ?? 'Unknown Operator',
              style: const TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

