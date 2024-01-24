import '../config.dart';
import '../object.dart';
import 'dart:convert';
import 'package:sprintf/sprintf.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<MemberGET>> getMemberList(String query, String scheme) async {
  SharedPreferences cache = await SharedPreferences.getInstance();

  try {
    http.Response response = await http.get(
      Uri.parse(ini.apiServer + ini.api.member + sprintf("?q=%s&s=%s", [query, scheme])),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${cache.getString(ini.cacheName.tokenAccess) ?? ""}',
      },
    );

    if (response.statusCode == 200) {
      return List<MemberGET>.from(jsonDecode(response.body).map((x) => MemberGET.fromJson(x)));
    } else {
      return [];
    }
  } catch (_) {
    return [];
  }
}
