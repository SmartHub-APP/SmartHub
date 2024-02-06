import 'role.dart';

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
