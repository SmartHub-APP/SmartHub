import '../config.dart';
import '../object.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

class TransactionEdit {
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

  TransactionEdit({
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
    };
  }
}

Future<List<Transaction>?> getTransactionList(TransactionGetRequest req) async {
  SharedPreferences cache = await SharedPreferences.getInstance();

  try {
    http.Response response = await http.get(
      Uri(
        scheme: 'http',
        host: ini.apiServer,
        port: 25000,
        path: ini.api.transaction,
        queryParameters: {
          "Name": req.name,
          "ProjectName": req.projectName,
          "Status": req.status.toString(),
          "PayStatus": req.payStatus.toString(),
          "Unit": req.unit,
          "LaunchDateStart": req.launchDateStart,
          "LaunchDateEnd": req.launchDateEnd,
          "SaleDateStart": req.saleDateStart,
          "SaleDateEnd": req.saleDateEnd,
        },
      ),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${cache.getString(ini.cacheName.tokenAccess) ?? ''}',
      },
    );

    if (response.statusCode == 200) {
      return List<Transaction>.from(jsonDecode(response.body).map((x) => Transaction.fromJson(x)));
    } else {
      return null;
    }
  } catch (_) {
    return null;
  }
}

Future<String> postTransaction(TransactionEdit req) async {
  if (req.name.isEmpty ||
      req.projectName.isEmpty ||
      req.price <= 0 ||
      req.priceSQFT <= 0 ||
      req.commission < 0 ||
      req.status < 0 ||
      req.payStatus < 0 ||
      req.unit.isEmpty ||
      req.location.isEmpty ||
      req.developer.isEmpty ||
      req.description.isEmpty ||
      req.appoint.isEmpty ||
      req.client.isEmpty ||
      req.agent.isEmpty ||
      req.saleDate.isEmpty ||
      req.launchDate.isEmpty) {
    return "Invalid Input";
  }

  try {
    http.Response response = await http.post(
      Uri.parse(ini.apiServer + ini.api.transaction),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(req.toJson()),
    );

    return response.statusCode == 201 ? "" : response.body;
  } catch (_) {
    return "Network Error";
  }
}

Future<String> putTransaction(TransactionEdit req) async {
  if (req.name.isEmpty ||
      req.projectName.isEmpty ||
      req.price <= 0 ||
      req.priceSQFT <= 0 ||
      req.commission < 0 ||
      req.status < 0 ||
      req.payStatus < 0 ||
      req.unit.isEmpty ||
      req.location.isEmpty ||
      req.developer.isEmpty ||
      req.description.isEmpty ||
      req.appoint.isEmpty ||
      req.client.isEmpty ||
      req.agent.isEmpty ||
      req.saleDate.isEmpty ||
      req.launchDate.isEmpty) {
    return "Invalid Input";
  }

  try {
    http.Response response = await http.put(
      Uri.parse(ini.apiServer + ini.api.transaction),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(req.toJson()),
    );

    return response.statusCode == 200 ? "" : response.body;
  } catch (_) {
    return "Network Error";
  }
}

Future<String> deleteTransaction(int id) async {
  try {
    http.Response response = await http.delete(
      Uri.parse(ini.apiServer + ini.api.transaction),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({"ID": id}),
    );

    return response.statusCode == 200 ? "" : response.body;
  } catch (_) {
    return "Network Error";
  }
}
