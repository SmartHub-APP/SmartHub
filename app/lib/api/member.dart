import '../config.dart';
import '../object.dart';
import 'dart:convert';
import 'package:sprintf/sprintf.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Member>> getMemberList(String query, String scheme) async {
  if (query == "" || scheme == "") {
    return [];
  }

  SharedPreferences cache = await SharedPreferences.getInstance();

  try {
    http.Response response = await http.get(
      Uri.parse(
        ini.apiServer + ini.api.member + sprintf("?q=%s&s=%s", [query, scheme]),
      ),
    );

    if (response.statusCode == 200) {
      return List<Member>.from(jsonDecode(response.body).map((x) => Member.fromJson(x)));
    } else {
      return [];
    }
  } catch (_) {
    return [];
  }
}
