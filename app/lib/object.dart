import 'config.dart';
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
  Member? lead, agent;
  DateTime appointDate;

  Appointment({
    required this.onSelect,
    required this.status,
    required this.projectName,
    required this.appointDate,
    this.lead,
    this.agent,
  });

  factory Appointment.create() {
    return Appointment(
      onSelect: false,
      status: 0,
      projectName: '',
      appointDate: ini.timeStart,
    );
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      onSelect: false,
      status: json["Status"] ?? 0,
      projectName: json["ProjectName"] ?? "",
      appointDate: DateTime.parse(json["AppointDate"] ?? ini.timeStart.toString()),
      lead: json["Lead"] != null ? Member.fromJson(json["Lead"]) : null,
      agent: json["Agent"] != null ? Member.fromJson(json["Agent"]) : null,
    );
  }
}

class Transaction {
  int id;
  bool onSelect;
  int price, status, payStatus;
  int? priceSQFT;
  double commission;
  String unit, name, projectName, location, developer;
  String? description;
  Member? appoint;
  DateTime saleDate, launchDate;
  List<File> documents;
  List<Member> clients, agent;

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
    required this.location,
    required this.developer,
    required this.launchDate,
    this.priceSQFT,
    this.description,
    this.appoint,
  });

  factory Transaction.create() {
    return Transaction(
      onSelect: false,
      price: 0,
      priceSQFT: 0,
      status: 2,
      payStatus: 0,
      commission: 0,
      id: 0,
      unit: "",
      name: "",
      location: "",
      developer: "",
      description: "",
      projectName: "",
      saleDate: DateTime.now(),
      launchDate: DateTime.now(),
      agent: [],
      clients: [],
      documents: [],
    );
  }

  factory Transaction.createCommission(double defaultCommission) {
    return Transaction(
      onSelect: false,
      price: 0,
      priceSQFT: 0,
      status: 2,
      payStatus: 0,
      commission: defaultCommission,
      id: 0,
      unit: "",
      name: "",
      location: "",
      developer: "",
      description: "",
      projectName: "",
      saleDate: DateTime.now(),
      launchDate: DateTime.now(),
      agent: [],
      clients: [],
      documents: [],
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      onSelect: false,
      id: json["ID"] ?? 0,
      name: json["Name"] ?? "",
      projectName: json["ProjectName"] ?? "",
      price: json["Price"] ?? 0,
      priceSQFT: json["PriceSQFT"] ?? 0,
      commission: json["Commission"] ?? 0,
      status: json["Status"] ?? 0,
      payStatus: json["PayStatus"] ?? 0,
      unit: json["Unit"] ?? "",
      location: json["Location"] ?? "",
      developer: json["Developer"] ?? "",
      description: json["Description"] ?? "",
      //appoint: json["Appoint"] != null ? Member.fromJson(json["Appoint"]) : null,
      clients: [],
      //List<Member>.from(json["Clients"].map((x) => Member.fromJson(x))),
      agent: [],
      //List<Member>.from(json["Agent"].map((x) => Member.fromJson(x))),
      saleDate: DateTime.parse(json["SaleDate"] ?? ini.timeStart.toString()),
      launchDate: DateTime.parse(json["LaunchDate"] ?? ini.timeStart.toString()),
      documents: [], //List<File>.from(json["Documents"].map((x) => File(fileName: x["FileName"], fileHash: x["FileHash"]))),
    );
  }
}

class Member {
  int id;
  int status;
  Role role;
  String name;
  String account;
  String? company;
  String? jobTitle;
  String? phone;
  String? bankCode;
  String? bankAccount;

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Status": status,
        "Role": role.toJson(),
        "Name": name,
        "Account": account,
        "Phone": phone,
        "BankCode": bankCode,
        "BankAccount": bankAccount,
        "Company": company,
        "JobTitle": jobTitle,
      };

  Map<String, dynamic> toJsonCreate() => {
        "RoleID": role.id,
        "Status": status,
        "Name": name,
        "Account": account,
        "Phone": phone,
        "BankCode": bankCode,
        "BankAccount": bankAccount,
        "Company": company,
        "JobTitle": jobTitle,
      };

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json["ID"] ?? -1,
      role: Role.fromJson(json["Role"]),
      status: json["Status"] ?? 0,
      name: json["Name"] ?? "",
      account: json["Account"] ?? "",
      phone: json["Phone"] ?? "",
      bankCode: json["BankCode"] ?? "",
      bankAccount: json["BankAccount"] ?? "",
      company: json["Company"] ?? "",
      jobTitle: json["JobTitle"] ?? "",
    );
  }

  Member({
    required this.id,
    required this.status,
    required this.role,
    required this.name,
    required this.account,
    this.phone,
    this.bankCode,
    this.bankAccount,
    this.company,
    this.jobTitle,
  });
}

class File {
  String fileName, fileHash;

  File({required this.fileName, required this.fileHash});
}

class Role {
  int id;
  String name;
  int permission;

  Role({required this.id, required this.name, required this.permission});

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
        "Permission": permission,
      };

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json["ID"] ?? 0,
      name: json["Name"] ?? "Guest",
      permission: json["Permission"] ?? 0,
    );
  }
}

// ##### Rooted Setting
class InitSetting {
  Api api;
  String apiServer;
  DateTime timeStart;
  CacheName cacheName;
  List<String> transactionStatus;
  List<String> appointmentLeadStatus;
  List<String> commissionStatus;
  List<Url> urls;
  List<Lang> languages;

  InitSetting({
    required this.api,
    required this.apiServer,
    required this.urls,
    required this.timeStart,
    required this.cacheName,
    required this.transactionStatus,
    required this.appointmentLeadStatus,
    required this.commissionStatus,
    required this.languages,
  });
}

class Api {
  String login;
  String member;
  String transaction;
  String appointment;

  Api({
    required this.login,
    required this.member,
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
