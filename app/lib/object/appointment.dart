import 'member.dart';
import '../config.dart';

class Appointment {
  bool onSelect;
  String projectName;
  int status;
  Member? lead, agent;
  DateTime appointDate;

  Appointment({
    required this.onSelect,
    required this.status,
    required this.projectName,
    required this.appointDate,
    this.lead,
    this.agent,
  });

  factory Appointment.create() {
    return Appointment(
      onSelect: false,
      status: 0,
      projectName: '',
      appointDate: ini.timeStart,
    );
  }

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      onSelect: false,
      status: json["Status"] ?? 0,
      projectName: json["ProjectName"] ?? "",
      appointDate: DateTime.parse(json["AppointDate"] ?? ini.timeStart.toString()),
      lead: json["Lead"] != null ? Member.fromJson(json["Lead"]) : null,
      agent: json["Agent"] != null ? Member.fromJson(json["Agent"]) : null,
    );
  }
}
