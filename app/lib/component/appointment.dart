import 'package:smarthub/api/appointment.dart';

import 'interaction.dart';
import '../config.dart';
import '../object/member.dart';
import '../object/appointment.dart';
import '../component/member.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:easy_localization/easy_localization.dart';

Future<String> appointmentData(BuildContext context, Appointment input, bool isNew) async {
  int editStatus = input.status;
  DateTime selectDate = input.appointDate;
  TimeOfDay selectTime = TimeOfDay(hour: input.appointDate.hour, minute: input.appointDate.minute);
  List<Member> lead = input.lead;
  List<Member> agent = input.agent;
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: uiStyle.roundCorner),
            backgroundColor: Colors.white,
            titlePadding: EdgeInsets.zero,
            content: Container(
                width: 20.w,
                height: 45.h,
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          SizedBox(width: 10.w, child: text3("${context.tr('leadsAppointment_colStatus')} : ")),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: uiStyle.roundCorner2),
                              child: DropdownButton2(
                                underline: const SizedBox(),
                                iconStyleData: const IconStyleData(icon: SizedBox()),
                                hint: Text(context.tr('customer_selStatus')),
                                buttonStyleData: const ButtonStyleData(padding: EdgeInsets.zero),
                                items: ini.appointmentLeadStatus.map((item) => DropdownMenuItem(value: item, child: text3(item))).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    editStatus = ini.appointmentLeadStatus.indexWhere((element) => element == newValue);
                                  });
                                },
                                value: ini.appointmentLeadStatus[editStatus],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          SizedBox(width: 10.w, child: text3("${context.tr('leadsAppointment_colDate')} : ")),
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              onPressed: () {
                                selectSingleDate(context, selectDate).then((value) {
                                  setState(() {
                                    selectDate = value;
                                  });
                                });
                              },
                              child: Container(
                                height: 6.h,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 1.w),
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: uiStyle.roundCorner2),
                                child: text3("${selectDate.year}/${selectDate.month}/${selectDate.day}"),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          SizedBox(width: 10.w, child: text3("${context.tr('leadsAppointment_colTime')} : ")),
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              onPressed: () {
                                selectSingleTime(context, selectTime).then((value) {
                                  setState(() {
                                    selectTime = value;
                                  });
                                });
                              },
                              child: Container(
                                height: 6.h,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 1.w),
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: uiStyle.roundCorner2),
                                child: text3("${selectTime.hour.toString().padLeft(2, "0")}:${selectTime.minute.toString().padLeft(2, "0")}"),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          SizedBox(width: 10.w, child: text3("${context.tr('leadsAppointment_colAgent')} : ")),
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              onPressed: () {
                                userEdit(context, lead, "-1").then((value) {
                                  setState(() {
                                    lead = value;
                                  });
                                });
                              },
                              child: Container(
                                height: 6.h,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 1.w),
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: uiStyle.roundCorner2),
                                child: userShow(context, lead),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          SizedBox(width: 10.w, child: text3("${context.tr('leadsAppointment_colLeads')} : ")),
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              onPressed: () {
                                userEdit(context, agent, "-1").then((value) {
                                  setState(() {
                                    agent = value;
                                  });
                                });
                              },
                              child: Container(
                                height: 6.h,
                                alignment: Alignment.centerLeft,
                                padding: EdgeInsets.only(left: 1.w),
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: uiStyle.roundCorner2),
                                child: userShow(context, agent),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )),
            actionsAlignment: MainAxisAlignment.center,
            actionsPadding: EdgeInsets.only(bottom: 3.h),
            actions: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  border: Border.all(color: Colors.grey),
                  borderRadius: uiStyle.roundCorner2,
                ),
                child: IconButton(
                  icon: const Icon(Icons.cleaning_services_rounded),
                  tooltip: context.tr('clear'),
                  onPressed: () {
                    setState(() {
                      editStatus = 0;
                      selectDate = ini.timeStart;
                      lead = agent = [];
                    });
                  },
                ),
              ),
              SizedBox(width: 1.w),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: uiStyle.roundCorner2,
                ),
                child: IconButton(
                  icon: const Icon(Icons.close),
                  tooltip: context.tr('close'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(width: 1.w),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: uiStyle.roundCorner2,
                ),
                child: IconButton(
                  icon: const Icon(Icons.save_alt_sharp),
                  tooltip: context.tr('save'),
                  onPressed: () {
                    if (editStatus == 0) {
                      alertDialog(
                        context,
                        context.tr('error'),
                        context.tr('emptyStatus'),
                        context.tr('ok'),
                      );
                    } else {
                      if (isNew) {
                        postAppointment(
                          AppointmentPostRequest(
                            payStatus: editStatus,
                            projectName: input.projectName,
                            lead: lead.map((e) => e.id).join(ini.separator),
                            agent: agent.map((e) => e.id).join(ini.separator),
                            appointTime: "${selectDate.year}-${selectDate.month}-${selectDate.day} ${selectTime.hour}:${selectTime.minute}:00",
                          ),
                        ).then((value) {
                          if (value.isEmpty) {
                            Navigator.pop(context);
                          } else {
                            alertDialog(context, context.tr('error'), value, context.tr('ok'));
                          }
                        });
                      } else {
                        putAppointment(
                          AppointmentPutRequest(
                            id: input.id,
                            payStatus: editStatus,
                            projectName: input.projectName,
                            lead: lead.map((e) => e.id).join(ini.separator),
                            agent: agent.map((e) => e.id).join(ini.separator),
                            appointTime: "${selectDate.year}-${selectDate.month}-${selectDate.day} ${selectTime.hour}:${selectTime.minute}:00",
                          ),
                        ).then((value) {
                          if (value.isEmpty) {
                            Navigator.pop(context);
                          } else {
                            alertDialog(context, context.tr('error'), value, context.tr('ok'));
                          }
                        });
                      }
                    }
                  },
                ),
              ),
            ],
          );
        },
      );
    },
  );

  return "";
}
