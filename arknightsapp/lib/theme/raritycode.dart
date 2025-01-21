import 'package:flutter/material.dart';

Color rarityCode(int rarity) {
  switch (rarity) {
    case 1:
      return Color.fromARGB(255, 255, 255, 255); 
    case 2:
      return Color.fromARGB(255, 212, 255, 0); 
    case 3:
      return Color.fromARGB(255, 2, 162, 255); 
    case 4:
      return Color.fromARGB(255, 220, 220, 220); 
    case 5:
      return Color.fromARGB(226, 252, 255, 186); 
    case 6:
      return Color.fromARGB(224, 255, 230, 0);
    default:
      return Color.fromARGB(223, 255, 255, 255);
}
}