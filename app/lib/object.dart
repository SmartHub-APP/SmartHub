import 'package:flutter/cupertino.dart';

// ##### UI
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

// ##### Controller
class SystemControl {
  String apiServer;
  String systemName;
  String systemVersion;
  User user;
  Widget icon;
  TabPermission tabPermission;

  SystemControl updateLogin(User newUser, TabPermission newPerm) {
    return SystemControl(
      systemName: systemName,
      systemVersion: systemVersion,
      user: newUser,
      icon: icon,
      apiServer: apiServer,
      tabPermission: newPerm,
    );
  }

  SystemControl({
    required this.systemName,
    required this.systemVersion,
    required this.user,
    required this.icon,
    required this.apiServer,
    required this.tabPermission,
  });
}

class User {
  String name;
  String account;

  User({
    required this.name,
    required this.account,
  });
}

/// 1. setting
/// ```
/// 0 : hide
/// 1 : basic
/// 2 : admin
/// 3 : boss
/// ```
/// 2. dashboard
/// ```
/// 0 : hide
/// 1 : basic
/// 2 : admin
/// 3 : boss
/// ```
/// 3. customer
/// ```
/// 0 : hide
/// 1 : basic
/// 2 : admin
/// 3 : boss
/// ```
/// 4. product
/// ```
/// 0 : hide
/// 1 : basic
/// 2 : admin
/// 3 : boss
/// ```
/// 5. leadsAppointment
/// ```
/// 0 : hide
/// 1 : basic
/// 2 : admin
/// 3 : boss
/// ```
/// 6. payment
/// ```
/// 0 : hide
/// 1 : basic
/// 2 : admin
/// 3 : boss
/// ```
class TabPermission {
  int setting;
  int dashboard;
  int customer;
  int product;
  int leadsAppointment;
  int payment;

  TabPermission({
    required this.setting,
    required this.dashboard,
    required this.customer,
    required this.product,
    required this.leadsAppointment,
    required this.payment,
  });
}

// ##### API
/// **login result codes**
/// ```
/// 0 : failed to login
/// 1 : login successful
/// 2 : internet unreachable
/// ```
class LoginResponse {
  String userName;
  String tokenAccess;
  String tokenRefresh;
  String permission;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        userName: json["Username"],
        permission: json["Permission"],
        tokenAccess: json["AccessToken"],
        tokenRefresh: json["RefreshToken"],
      );

  TabPermission getPerm() {
    return TabPermission(
      setting: int.parse(permission[0]),
      dashboard: int.parse(permission[1]),
      customer: int.parse(permission[2]),
      product: int.parse(permission[3]),
      leadsAppointment: int.parse(permission[4]),
      payment: int.parse(permission[5]),
    );
  }

  LoginResponse({
    required this.userName,
    required this.tokenAccess,
    required this.tokenRefresh,
    required this.permission,
  });
}

// ##### Data
class DataPoint {
  final String x;
  final double y;

  DataPoint(this.x, this.y);
}

class Appointment {
  bool onSelect;
  String projectName;
  int status;
  Person lead, agent;
  DateTime appointDate;

  Appointment({
    required this.onSelect,
    required this.projectName,
    required this.status,
    required this.lead,
    required this.agent,
    required this.appointDate,
  });
}

class Transaction {
  bool onSelect;
  int price, status, payStatus;
  double commission;
  String id, unit, name, projectName;
  String? description;
  Person? appoint;
  DateTime saleDate;
  List<String> documents;
  List<Person> clients, agent;

  Transaction({
    required this.onSelect,
    required this.name,
    required this.projectName,
    required this.price,
    required this.commission,
    required this.payStatus,
    required this.status,
    required this.id,
    required this.unit,
    required this.saleDate,
    required this.agent,
    required this.documents,
    required this.clients,
    this.description,
    this.appoint,
  });
}

class Person {
  Role role;
  String name;
  String? email;
  String? phone;
  String? bankCode;
  String? bankAccount;

  Person({required this.role, required this.name, this.email, this.phone, this.bankCode, this.bankAccount});
}

class Role {
  String roleName;
  List<int> permission;

  Role({required this.roleName, required this.permission});
}

// ##### Rooted Setting
class InitSetting {
  Api api;
  DateTime timeStart;
  CacheName cacheName;
  List<String> transactionStatus;
  List<String> appointmentLeadStatus;
  List<String> commissionStatus;
  List<Url> urls;
  List<Lang> languages;
  List<Role> preRoles;

  InitSetting({
    required this.api,
    required this.urls,
    required this.timeStart,
    required this.cacheName,
    required this.transactionStatus,
    required this.appointmentLeadStatus,
    required this.commissionStatus,
    required this.languages,
    required this.preRoles,
  });
}

class Api {
  String login;

  Api({required this.login});
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
  String account;
  String password;
  String tokenAccess;
  String tokenRefresh;

  CacheName({
    required this.account,
    required this.password,
    required this.tokenAccess,
    required this.tokenRefresh,
  });
}
