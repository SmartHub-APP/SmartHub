import 'file.dart';
import 'member.dart';
import '../config.dart';

class Transaction {
  int id;
  bool onSelect;
  double price, priceSQFT;
  int status, payStatus;
  double commission;
  String unit, name, projectName, location, developer;
  String description;
  DateTime saleDate, launchDate;
  List<File> documents;
  List<Member> client, agent, appoint;

  Transaction({
    required this.onSelect,
    required this.name,
    required this.projectName,
    required this.price,
    required this.priceSQFT,
    required this.commission,
    required this.payStatus,
    required this.status,
    required this.id,
    required this.unit,
    required this.saleDate,
    required this.agent,
    required this.documents,
    required this.client,
    required this.location,
    required this.developer,
    required this.launchDate,
    required this.description,
    required this.appoint,
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
      client: [],
      appoint: [],
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
      client: [],
      appoint: [],
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
      client: [],
      //List<Member>.from(json["Client"].map((x) => Member.fromJson(x))),
      agent: [],
      //List<Member>.from(json["Agent"].map((x) => Member.fromJson(x))),
      appoint: [],
      //List<Member>.from(json["Appoint"].map((x) => Member.fromJson(x))),
      saleDate: DateTime.parse(json["SaleDate"] ?? ini.timeStart.toString()),
      launchDate: DateTime.parse(json["LaunchDate"] ?? ini.timeStart.toString()),
      documents: [], //List<File>.from(json["Documents"].map((x) => File(fileName: x["FileName"], fileHash: x["FileHash"]))),
    );
  }
}

class TransactionGetRequest {
  String name;
  String projectName;
  int status;
  int payStatus;
  String unit;
  String launchDateStart;
  String launchDateEnd;
  String saleDateStart;
  String saleDateEnd;

  TransactionGetRequest({
    required this.name,
    required this.projectName,
    required this.status,
    required this.payStatus,
    required this.unit,
    required this.launchDateStart,
    required this.launchDateEnd,
    required this.saleDateStart,
    required this.saleDateEnd,
  });
}

class TransactionPostRequest {
  String name;
  String projectName;
  double price;
  double priceSQFT;
  double commission;
  int status;
  int payStatus;
  String unit;
  String location;
  String developer;
  String description;
  String appoint;
  String client;
  String agent;
  String saleDate;
  String launchDate;
  List<File> documents;

  TransactionPostRequest({
    required this.name,
    required this.projectName,
    required this.price,
    required this.priceSQFT,
    required this.commission,
    required this.status,
    required this.payStatus,
    required this.unit,
    required this.location,
    required this.developer,
    required this.description,
    required this.appoint,
    required this.client,
    required this.agent,
    required this.saleDate,
    required this.launchDate,
    required this.documents,
  });

  Map<String, dynamic> toJson() {
    return {
      "Name": name,
      "ProjectName": projectName,
      "Price": price,
      "PriceSQFT": priceSQFT,
      "Commission": commission,
      "Status": status,
      "PayStatus": payStatus,
      "Unit": unit,
      "Location": location,
      "Developer": developer,
      "Description": description,
      "Appoint": appoint,
      "Client": client,
      "Agent": agent,
      "SaleDate": saleDate,
      "LaunchDate": launchDate,
      "Documents": documents.map((e) => e.toJson()).toList(),
    };
  }
}

class TransactionPutRequest {
  int id;
  String name;
  String projectName;
  double price;
  double priceSQFT;
  double commission;
  int status;
  int payStatus;
  String unit;
  String location;
  String developer;
  String description;
  String appoint;
  String client;
  String agent;
  String saleDate;
  String launchDate;
  List<File> documents;

  TransactionPutRequest({
    required this.id,
    required this.name,
    required this.projectName,
    required this.price,
    required this.priceSQFT,
    required this.commission,
    required this.status,
    required this.payStatus,
    required this.unit,
    required this.location,
    required this.developer,
    required this.description,
    required this.appoint,
    required this.client,
    required this.agent,
    required this.saleDate,
    required this.launchDate,
    required this.documents,
  });

  Map<String, dynamic> toJson() {
    return {
      "ID": id,
      "Name": name,
      "ProjectName": projectName,
      "Price": price,
      "PriceSQFT": priceSQFT,
      "Commission": commission,
      "Status": status,
      "PayStatus": payStatus,
      "Unit": unit,
      "Location": location,
      "Developer": developer,
      "Description": description,
      "Appoint": appoint,
      "Client": client,
      "Agent": agent,
      "SaleDate": saleDate,
      "LaunchDate": launchDate,
      "Documents": documents.map((e) => e.toJson()).toList(),
    };
  }
}
