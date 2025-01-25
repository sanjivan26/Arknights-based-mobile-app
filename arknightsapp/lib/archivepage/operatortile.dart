import 'package:flutter/material.dart';
import './operatordetails.dart';

class OperatorTile extends StatefulWidget {
  final dynamic operator;
  final String opKey;

  const OperatorTile(this.operator, this.opKey, {super.key});

  @override
  State<OperatorTile> createState() => _OperatorTileState();
}

class _OperatorTileState extends State<OperatorTile> {
  @override
  Widget build(BuildContext context) {
    final operator = widget.operator;

    String imagePath = 'assets/avatars/${widget.opKey}.png';
    double screenWidth = MediaQuery.of(context).size.width;
    double imageSize = screenWidth * 0.20;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OperatorDetails(operator: operator, opKey: widget.opKey,),
          ),
        );
      },
      child: IntrinsicHeight(
        child: Container(
          padding: const EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainer,
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
                    color: Theme.of(context).colorScheme.inverseSurface,
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
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inverseSurface),
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