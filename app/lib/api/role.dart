import '../config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../object/role.dart';

Future<bool> roleExist(RolePostRequest r) async {
  if (r.name.isEmpty) {
    return false;
  }

  await getRoleList().then((roleList) {
    for (var role in roleList) {
      if (role.name == r.name) {
        return true;
      }
    }
  });

  return false;
}

Future<List<Role>> getRoleList() async {
  SharedPreferences cache = await SharedPreferences.getInstance();

  try {
    http.Response response = await http.get(Uri.parse(ini.apiServer + ini.api.role));

    if (response.statusCode == 200) {
      return List<Role>.from(jsonDecode(response.body).map((x) => Role.fromJson(x)));
    } else {
      return [];
    }
  } catch (_) {
    return [];
  }
}

Future<String> postRole(RolePostRequest r) async {
  SharedPreferences cache = await SharedPreferences.getInstance();

  try {
    http.Response response = await http.post(
      Uri.parse(ini.apiServer + ini.api.member),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(r.toJson()),
    );

    return response.statusCode == 201 ? "" : response.body;
  } catch (_) {
    return "Network Error";
  }
}

Future<String> deleteRole(List<int> ids) async {
  SharedPreferences cache = await SharedPreferences.getInstance();

  try {
    http.Response response = await http.delete(
      Uri.parse(ini.apiServer + ini.api.role),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(ids),
    );

    return response.statusCode == 200 ? "" : response.body;
  } catch (_) {
    return "Network Error";
  }
}
