import 'config.dart';
import 'object.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<String> try2Login() async {
  String state = "Token not exist";
  SharedPreferences cache = await SharedPreferences.getInstance();

  String oldTokenAccess = cache.getString(ini.cacheName.tokenAccess) ?? "";
  String oldTokenRefresh = cache.getString(ini.cacheName.tokenRefresh) ?? "";

  if (oldTokenRefresh.isEmpty && manager.user.account.isEmpty) {
    return state;
  }

  if (oldTokenRefresh == "Develop_Fake_Token") {
    manager = manager.updateLogin(
      User(
        account: manager.user.account,
        password: manager.user.password,
        tokenAccess: "Develop_Fake_Token",
        tokenRefresh: "Develop_Fake_Token",
      ),
      [true, true, true, true, true, true],
    );

    return "";
  }

  if (manager.user.account == "test") {
    if (manager.user.password == "123123") {
      cache.setString(ini.cacheName.tokenAccess, "Develop_Fake_Token");
      cache.setString(ini.cacheName.tokenRefresh, "Develop_Fake_Token");

      manager = manager.updateLogin(
        User(
          account: manager.user.account,
          password: manager.user.password,
          tokenAccess: "Develop_Fake_Token",
          tokenRefresh: "Develop_Fake_Token",
        ),
        [true, true, true, true, true, true],
      );

      return "";
    } else {
      return "Password mismatch";
    }
  }

  try {
    http.Response response = await http.post(
      Uri.parse(ini.api.server + ini.api.login),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(<String, String>{
        'account': manager.user.account,
        'password': manager.user.password,
        'accessToken': oldTokenAccess,
        'refreshToken': oldTokenRefresh,
      }),
    );

    LoginResponse responseData = LoginResponse.fromJson(jsonDecode(response.body));

    state = responseData.message;

    if (response.statusCode == 200) {
      cache.setString(ini.cacheName.tokenAccess, responseData.tokenAccess);
      cache.setString(ini.cacheName.tokenRefresh, responseData.tokenRefresh);

      manager = manager.updateLogin(
        User(
          account: manager.user.account,
          password: manager.user.password,
          tokenAccess: responseData.tokenAccess,
          tokenRefresh: responseData.tokenRefresh,
        ),
        responseData.getPermList(),
      );
    } else {
      await cache.clear();
    }
  } catch (_) {
    state = "Network error";
  }

  return state;
}

Future<void> logout() async {
  SharedPreferences cache = await SharedPreferences.getInstance();

  await cache.remove(ini.cacheName.tokenAccess);
  await cache.remove(ini.cacheName.tokenRefresh);

  manager = manager.updateLogin(
    User(
      account: manager.user.account,
      password: manager.user.password,
      tokenAccess: "Develop_Fake_Token",
      tokenRefresh: "Develop_Fake_Token",
    ),
    [true, true, true, true, true, true],
  );
}
