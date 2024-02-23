import 'package:flutter/material.dart';

class Button {
  bool onSelect;
  String name;

  Button({
    required this.onSelect,
    required this.name,
  });
}

class FrontStyle {
  double leadWidth;
  double loginWidth;
  double fontSize1;
  double fontSize2;
  double fontSize3;
  double fontSize4;
  BorderRadius roundCorner;
  BorderRadius roundCorner2;

  FrontStyle({
    required this.leadWidth,
    required this.loginWidth,
    required this.fontSize1,
    required this.fontSize2,
    required this.fontSize3,
    required this.fontSize4,
    required this.roundCorner,
    required this.roundCorner2,
  });
}
