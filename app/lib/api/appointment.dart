import '../config.dart';
import '../object.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AppointmentGetRequest {
  String name;
  String projectName;
  int status;
  String appointTimeStart;
  String appointTimeEnd;

  AppointmentGetRequest({
    required this.name,
    required this.projectName,
    required this.status,
    required this.appointTimeStart,
    required this.appointTimeEnd,
  });
}

class AppointmentEdit {
  int status;
  String projectName;
  String lead;
  String agent;
  String appointTime;

  AppointmentEdit({
    required this.status,
    required this.projectName,
    required this.lead,
    required this.agent,
    required this.appointTime,
  });

  Map<String, dynamic> toJson() {
    return {
      "Status": status,
      "ProjectName": projectName,
      "Lead": lead,
      "Agent": agent,
      "AppointTime": appointTime,
    };
  }
}

Future<List<Appointment>?> getAppointmentList(AppointmentGetRequest req) async {
  SharedPreferences cache = await SharedPreferences.getInstance();

  try {
    http.Response response = await http.get(
      Uri(
        scheme: 'http',
        host: ini.apiServer,
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
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${cache.getString(ini.cacheName.tokenAccess) ?? ''}',
      },
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

Future<String> postAppointment(AppointmentEdit req) async {
  if (req.projectName.isEmpty || req.lead.isEmpty || req.agent.isEmpty || req.appointTime.isEmpty || req.status < 0) {
    return "Invalid Input";
  }

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

Future<String> putAppointment(AppointmentEdit req) async {
  if (req.projectName.isEmpty || req.lead.isEmpty || req.agent.isEmpty || req.appointTime.isEmpty || req.status < 0) {
    return "Invalid Input";
  }

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

Future<String> deleteAppointment(int id) async {
  try {
    http.Response response = await http.delete(
      Uri.parse(ini.apiServer + ini.api.appointment),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({"ID": id}),
    );

    return response.statusCode == 200 ? "" : response.body;
  } catch (_) {
    return "Network Error";
  }
}
