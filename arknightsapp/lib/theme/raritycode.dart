import 'package:flutter/material.dart';

Color rarityCode(int rarity) {
  switch (rarity) {
    case 1:
      return Color.fromARGB(255, 255, 255, 255); 
    case 2:
      return Color.fromARGB(255, 212, 255, 0); 
    case 3:
      return Color.fromARGB(255, 68, 186, 255); 
    case 4:
      return Color.fromARGB(255, 213, 213, 213); 
    case 5:
      return Color.fromARGB(255, 252, 255, 196); 
    case 6:
      return Color.fromARGB(223, 255, 187, 0);
    default:
      return Color.fromARGB(223, 255, 255, 255);
}
}