import 'role.dart';

class Member {
  int id;
  Role role;
  String name;
  String account;
  String company;
  String jobTitle;
  String phone;
  String bankCode;
  String bankAccount;

  Map<String, dynamic> toJson() => {
        "ID": id,
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
    required this.role,
    required this.name,
    required this.account,
    required this.phone,
    required this.bankCode,
    required this.bankAccount,
    required this.company,
    required this.jobTitle,
  });
}
