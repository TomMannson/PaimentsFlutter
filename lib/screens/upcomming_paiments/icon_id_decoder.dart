
import 'package:flutter/material.dart';

Map<int, IconData> mapping = {
  1: Icons.home,
  2: Icons.directions_subway,
  3: Icons.fitness_center,
  4: Icons.directions_car,
  5: Icons.language,
  6: Icons.lightbulb_outline,
  7: Icons.wifi,
  8: Icons.phone_android,

};

IconData getIconForType(int iconType){
  return mapping[iconType];
}