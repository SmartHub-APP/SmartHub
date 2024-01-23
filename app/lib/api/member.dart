import '../config.dart';
import '../object.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Member>> getMemberList() async {
  SharedPreferences cache = await SharedPreferences.getInstance();

  try {
    http.Response response = await http.get(
      Uri.parse(ini.apiServer + ini.api.member),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${cache.getString(ini.cacheName.tokenAccess) ?? ""}',
      },
    );

    if (response.statusCode == 200) {
      List<Member> resp = (jsonDecode(response.body) as List<dynamic>).map((e) => Member.fromJson(e)).toList();

      return resp;
    } else {
      return [];
    }
  } catch (_) {
    return [];
  }
}
