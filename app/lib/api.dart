import 'config.dart';
import 'object.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<String> try2Login(String account, password) async {
  SharedPreferences cache = await SharedPreferences.getInstance();

  try {
    http.Response response = await http.post(
      Uri.parse(ini.apiServer + ini.api.login),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(<String, String>{
        'Account': account,
        'Password': password,
        'AccessToken': cache.getString(ini.cacheName.tokenAccess) ?? "",
        'RefreshToken': cache.getString(ini.cacheName.tokenRefresh) ?? "",
      }),
    );

    if (response.statusCode == 200) {
      LoginResponse resp = LoginResponse.fromJson(jsonDecode(response.body));

      cache.setString(ini.cacheName.tokenAccess, resp.tokenAccess);
      cache.setString(ini.cacheName.tokenRefresh, resp.tokenRefresh);

      manager = manager.updateLogin(
        User(
          name: resp.userName,
          account: account,
        ),
        resp.getPerm(),
      );
    } else {
      await cache.clear();

      return response.body;
    }
  } catch (_) {
    return "Network error";
  }

  return "";
}

// ## Future remove
Future<void> logout() async {
  SharedPreferences cache = await SharedPreferences.getInstance();

  await cache.remove(ini.cacheName.tokenAccess);
  await cache.remove(ini.cacheName.tokenRefresh);

  manager = manager.updateLogin(
    User(account: "", name: ""),
    TabPermission(setting: 0, dashboard: 0, customer: 0, product: 0, leadsAppointment: 0, payment: 0),
  );
}
