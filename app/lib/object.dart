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
  String systemName;
  String systemVersion;
  User user;
  Widget icon;
  List<bool> tabPermissions;

  SystemControl updateLogin(User newUser, List<bool> newPerm) {
    return SystemControl(
      systemName: systemName,
      systemVersion: systemVersion,
      user: newUser,
      icon: icon,
      tabPermissions: newPerm,
    );
  }

  SystemControl({
    required this.systemName,
    required this.systemVersion,
    required this.user,
    required this.icon,
    required this.tabPermissions,
  });
}

class User {
  String account;
  String password;
  String tokenAccess;
  String tokenRefresh;

  User({
    required this.account,
    required this.password,
    required this.tokenAccess,
    required this.tokenRefresh,
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

  factory TabPermission.fromJson(Map<String, dynamic> json) => TabPermission(
        setting: json["setting"],
        dashboard: json["dashboard"],
        customer: json["customer"],
        product: json["product"],
        leadsAppointment: json["leadsAppointment"],
        payment: json["payment"],
      );

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
  String tokenAccess;
  String tokenRefresh;
  String message;
  TabPermission permission;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        tokenAccess: json["tokenAccess"],
        tokenRefresh: json["tokenRefresh"],
        message: json["message"],
        permission: TabPermission.fromJson(json["permission"]),
      );

  List<bool> getPermList() {
    List<bool> ret = [true];
    ret.add(permission.customer > 0);
    ret.add(permission.product > 0);
    ret.add(permission.leadsAppointment > 0);
    ret.add(permission.payment > 0);
    ret.add(permission.setting > 0);

    return ret;
  }

  LoginResponse({
    required this.tokenAccess,
    required this.tokenRefresh,
    required this.message,
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
  int status;
  Person lead, agent;
  DateTime appointDate;

  Appointment({
    required this.onSelect,
    required this.status,
    required this.lead,
    required this.agent,
    required this.appointDate,
  });
}

class Transaction {
  bool onSelect;
  int price, status, isPaid;
  double profit;
  String id, name, category, position, description;
  Person? appointment;
  DateTime? saleDate;
  List<String> imgUrl;
  List<Person> agent, customer;

  Transaction({
    required this.onSelect,
    required this.isPaid,
    required this.price,
    required this.status,
    required this.profit,
    required this.id,
    required this.name,
    required this.category,
    required this.position,
    required this.description,
    this.appointment,
    this.saleDate,
    required this.agent,
    required this.imgUrl,
    required this.customer,
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
  API api;
  Url url;
  DateTime timeStart;
  CacheName cacheName;
  List<String> transactionStatus;
  List<String> appointmentLeadStatus;
  List<String> profitStatus;
  List<Lang> languages;
  List<Role> preRoles;

  InitSetting({
    required this.api,
    required this.url,
    required this.timeStart,
    required this.cacheName,
    required this.transactionStatus,
    required this.appointmentLeadStatus,
    required this.profitStatus,
    required this.languages,
    required this.preRoles,
  });
}

class Lang {
  String langName;
  Locale ref;

  Lang({required this.langName, required this.ref});
}

class API {
  String server;
  String login;
  String dashboard;

  API({
    required this.server,
    required this.login,
    required this.dashboard,
  });
}

class Url {
  String login;
  List<TabData> tabData;

  Url({
    required this.login,
    required this.tabData,
  });
}

class TabData {
  String route;
  dynamic content;

  TabData({
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
