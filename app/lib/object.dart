import 'tool.dart';
import 'config.dart';
import 'dart:math';
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

  List<Appointment> fakeData(int amount) {
    Random seed = Random();
    return List.generate(amount, (index) {
      return Appointment(
        onSelect: false,
        status: seed.nextInt(3) + 1,
        projectName: randomString(5),
        lead: randomPerson(),
        agent: randomPerson(),
        appointDate: DateTime(
          seed.nextInt(23) + 2000,
          seed.nextInt(12) + 1,
          seed.nextInt(25) + 1,
          seed.nextInt(12) + 1,
          seed.nextInt(60) + 1,
        ),
      );
    });
  }
}

class Transaction {
  bool onSelect;
  int price, status, payStatus;
  int? priceSQFT;
  double commission;
  String id, unit, name, projectName, location, developer;
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
      id: "",
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
      id: "",
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

  List<Transaction> fakeData(int amount) {
    Random seed = Random();
    return List.generate(amount, (index) {
      String rngString3 = "$index-${randomString(3)}";
      String rngString10 = "$index-${randomString(10)}";
      return Transaction(
        onSelect: false,
        id: rngString10,
        status: seed.nextInt(5) + 1,
        payStatus: seed.nextInt(3),
        commission: seed.nextInt(30) + 1,
        price: seed.nextInt(100000) + 10000,
        priceSQFT: seed.nextInt(100) + 100,
        name: "Name-$rngString3",
        unit: "Unit-$rngString3",
        location: "Location-$rngString3",
        developer: "Developer-$rngString3",
        projectName: "ProjectName-$rngString3",
        description: "Description - $rngString10-$rngString10",
        appoint: randomPerson(),
        agent: List.generate(3, (index) => randomPerson()),
        clients: List.generate(3, (index) => randomPerson()),
        documents: List.generate(3, (index) => randomPic()),
        saleDate: DateTime(
          seed.nextInt(23) + 2000,
          seed.nextInt(12) + 1,
          seed.nextInt(25) + 1,
          seed.nextInt(12) + 1,
          seed.nextInt(60) + 1,
        ),
        launchDate: DateTime(
          seed.nextInt(23) + 2000,
          seed.nextInt(12) + 1,
          seed.nextInt(25) + 1,
          seed.nextInt(12) + 1,
          seed.nextInt(60) + 1,
        ),
      );
    });
  }
}

class Member {
  int id;
  Role role;
  String name;
  String account;
  String? phone;
  String? company;
  String? jobTitle;
  String? bankCode;
  String? bankAccount;

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        id: json["id"],
        role: Role(permission: [], roleName: "test"),
        //ini.preRoles[int.parse(json["role"])],
        name: json["name"],
        company: json["company"],
        jobTitle: json["jobTitle"],
        account: json["account"],
        phone: json["phone"],
        bankCode: json["bankCode"],
        bankAccount: json["bankAccount"],
      );

  Member({
    required this.role,
    required this.name,
    required this.account,
    this.phone,
    this.bankCode,
    this.bankAccount,
    this.company,
    this.jobTitle,
    required this.id,
  });
}

class File {
  String fileName, fileHash;

  File({required this.fileName, required this.fileHash});
}

class Role {
  String roleName;
  List<int> permission;

  Role({required this.roleName, required this.permission});

  factory Role.guest() {
    return Role(roleName: "Guest", permission: [0, 0, 0, 0, 0, 0]);
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
  List<Role> preRoles;

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
    required this.preRoles,
  });
}

class Api {
  String login;
  String member;

  Api({required this.login, required this.member});
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
