import 'member.dart';
import '../config.dart';

class Appointment {
  int id;
  bool onSelect;
  String projectName;
  int status;
  List<Member> lead, agent;
  DateTime appointDate;

  Appointment({
    required this.id,
    required this.onSelect,
    required this.status,
    required this.projectName,
    required this.appointDate,
    required this.lead,
    required this.agent,
  });

  factory Appointment.create() {
    return Appointment(
      id: 0,
      onSelect: false,
      status: 0,
      projectName: '',
      appointDate: ini.timeStart,
      lead: [],
      agent: [],
    );
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json["ID"] ?? 0,
      onSelect: false,
      status: json["Status"] ?? 0,
      projectName: json["ProjectName"] ?? "",
      appointDate: DateTime.parse(json["AppointTime"] ?? ini.timeStart.toString()),
      lead: [],
      //json["Lead"] != null ? Member.fromJson(json["Lead"]) : null,
      agent: [],
      //json["Agent"] != null ? Member.fromJson(json["Agent"]) : null,
    );
  }
}

class AppointmentGetRequest {
  int status;
  String name;
  String projectName;
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

class AppointmentPostRequest {
  int payStatus;
  String projectName;
  String lead;
  String agent;
  String appointTime;

  AppointmentPostRequest({
    required this.payStatus,
    required this.projectName,
    required this.lead,
    required this.agent,
    required this.appointTime,
  });

  Map<String, dynamic> toJson() {
    return {
      "Status": payStatus,
      "ProjectName": projectName,
      "Lead": lead,
      "Agent": agent,
      "AppointTime": appointTime,
    };
  }
}

class AppointmentPutRequest {
  int id;
  int payStatus;
  String projectName;
  String lead;
  String agent;
  String appointTime;

  AppointmentPutRequest({
    required this.id,
    required this.payStatus,
    required this.projectName,
    required this.lead,
    required this.agent,
    required this.appointTime,
  });

  Map<String, dynamic> toJson() {
    return {
      "ID": id,
      "Status": payStatus,
      "ProjectName": projectName,
      "Lead": lead,
      "Agent": agent,
      "AppointTime": appointTime,
    };
  }
}
