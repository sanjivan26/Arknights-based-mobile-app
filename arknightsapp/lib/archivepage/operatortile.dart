import './../colorfab.dart';
import 'package:flutter/material.dart';
import './operatordetails.dart';
import './imagemapping.dart';

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

    String imagePath = imageMapping[operator['name']] ?? imageMapping['default']!;

    double screenWidth = MediaQuery.of(context).size.width;
    double imageSize = screenWidth * 0.20;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OperatorDetails(operator: operator),
          ),
        );
      },
      child: IntrinsicHeight(
        child: Container(
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            color: ColorFab.lightShadow,
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
                    color: ColorFab.darkAccent,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    imagePath,  
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  operator['name'] ?? 'Unknown Operator',
                  style: const TextStyle(color: ColorFab.offBlack),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
