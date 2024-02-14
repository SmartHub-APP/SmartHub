import '../config.dart';
import '../object/appointment.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Appointment>?> getAppointmentList(AppointmentGetRequest req) async {
  SharedPreferences cache = await SharedPreferences.getInstance();

  try {
    http.Response response = await http.get(
      Uri(
        scheme: 'http',
        host: ini.apiBase,
        port: 25000,
        path: ini.api.appointment,
        queryParameters: {
          'Name': req.name,
          'ProjectName': req.projectName,
          'Status': req.status.toString(),
          'AppointTimeStart': req.appointTimeStart,
          'AppointTimeEnd': req.appointTimeEnd,
        },
      ),
    );

    if (response.statusCode == 200) {
      return List<Appointment>.from(jsonDecode(response.body).map((x) => Appointment.fromJson(x)));
    } else {
      return null;
    }
  } catch (_) {
    return null;
  }
}

Future<String> postAppointment(AppointmentPostRequest req) async {
  try {
    http.Response response = await http.post(
      Uri.parse(ini.apiServer + ini.api.appointment),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(req.toJson()),
    );

    return response.statusCode == 201 ? "" : response.body;
  } catch (_) {
    return "Network Error";
  }
}

Future<String> putAppointment(AppointmentPutRequest req) async {
  try {
    http.Response response = await http.put(
      Uri.parse(ini.apiServer + ini.api.appointment),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(req.toJson()),
    );

    return response.statusCode == 200 ? "" : response.body;
  } catch (_) {
    return "Network Error";
  }
}

Future<String> deleteAppointment(List<int> ids) async {
  try {
    http.Response response = await http.delete(
      Uri.parse(ini.apiServer + ini.api.appointment),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(ids),
    );

    return response.statusCode == 200 ? "" : response.body;
  } catch (_) {
    return "Network Error";
  }
}
