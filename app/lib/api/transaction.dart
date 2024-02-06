import '../config.dart';
import '../object/transaction.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Transaction>?> getTransactionList(TransactionGetRequest req) async {
  SharedPreferences cache = await SharedPreferences.getInstance();

  try {
    http.Response response = await http.get(
      Uri(
        scheme: 'http',
        host: ini.apiBase,
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

Future<String> postTransaction(TransactionPostRequest req) async {
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

Future<String> putTransaction(TransactionPutRequest req) async {
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
