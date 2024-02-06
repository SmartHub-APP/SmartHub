import 'permission.dart';
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

class SystemControl {
  String systemName;
  User user;
  Widget icon;
  TabPermission tabPermission;

  SystemControl updateLogin(User newUser, TabPermission newPerm) {
    return SystemControl(
      systemName: systemName,
      user: newUser,
      icon: icon,
      tabPermission: newPerm,
    );
  }

  SystemControl({
    required this.systemName,
    required this.user,
    required this.icon,
    required this.tabPermission,
  });
}
