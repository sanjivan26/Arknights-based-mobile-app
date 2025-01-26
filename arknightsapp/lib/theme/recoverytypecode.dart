import 'package:flutter/material.dart';

Color recoveryCode(String rarity) {
  switch (rarity) {
    case 'INCREASE_WITH_TIME':
      return Color.fromARGB(255, 116, 180, 47); 
    case 'INCREASE_WHEN_ATTACK':
      return Color.fromARGB(255, 255, 146, 44); 
    case 'INCREASE_WHEN_TAKEN_DAMAGE':
      return Color.fromARGB(255, 208, 164, 62); 
    default:
      return Color.fromARGB(223, 255, 255, 255);
}
}