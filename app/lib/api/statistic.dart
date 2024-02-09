import '../config.dart';
import '../object/statistic.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<Statistic> getStatistic(String from, String to) async {
  SharedPreferences cache = await SharedPreferences.getInstance();

  try {
    http.Response response = await http.get(
      Uri(
        scheme: 'http',
        host: ini.apiBase,
        port: 25000,
        path: ini.api.statistic,
        queryParameters: {'DateStart': from, 'DateEnd': to},
      ),
    );

    if (response.statusCode == 200) {
      return Statistic.fromJson(jsonDecode(response.body));
    } else {
      return Statistic.zero();
    }
  } catch (_) {
    return Statistic.zero();
  }
}
