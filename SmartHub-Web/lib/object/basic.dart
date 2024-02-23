import 'permission.dart';
import 'package:flutter/cupertino.dart';

// ##### Rooted Setting
class InitSetting {
  int maxPerm;
  int dayOfMonth;
  Api api;
  String separator;
  String apiBase;
  String apiServer;
  DateTime timeStart;
  DateTime timeEnd;
  CacheName cacheName;
  List<int> permModes;
  List<Url> urls;
  List<Lang> languages;
  List<String> transactionStatus;
  List<String> appointmentLeadStatus;
  List<String> commissionStatus;

  InitSetting({
    required this.maxPerm,
    required this.dayOfMonth,
    required this.api,
    required this.separator,
    required this.apiBase,
    required this.apiServer,
    required this.urls,
    required this.timeStart,
    required this.timeEnd,
    required this.cacheName,
    required this.transactionStatus,
    required this.appointmentLeadStatus,
    required this.commissionStatus,
    required this.languages,
    required this.permModes,
  });
}

class Api {
  String role;
  String login;
  String member;
  String statistic;
  String transaction;
  String appointment;

  Api({
    required this.role,
    required this.login,
    required this.member,
    required this.statistic,
    required this.transaction,
    required this.appointment,
  });
}

class Lang {
  String langName;
  Locale ref;

  Lang({required this.langName, required this.ref});
}

class Url {
  String route;
  dynamic content;

  Url({
    required this.route,
    required this.content,
  });
}

class CacheName {
  String name;
  String account;
  String tokenAccess;
  String tokenRefresh;

  CacheName({
    required this.name,
    required this.account,
    required this.tokenAccess,
    required this.tokenRefresh,
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
