import '../config.dart';
import '../object.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';

FrontStyle uiStyle = FrontStyle(
  leadWidth: Device.screenType == ScreenType.mobile ? 25.w : 10.w,
  loginWidth: Device.screenType == ScreenType.mobile ? 80.w : 50.w,
  fontSize1: 16.sp,
  fontSize2: 15.sp,
  fontSize3: 12.sp,
  fontSize4: 11.sp,
  roundCorner: BorderRadius.circular(10),
  roundCorner2: BorderRadius.circular(8),
);

String personInfoMsg(BuildContext context, Person p) {
  String phone = p.phone == null ? "" : "${context.tr('phone')} : ${p.phone}\n";

  return p.email == null ? phone.trimRight() : "$phone${context.tr('email')} : ${p.email}";
}

Text text1(String show, {bool isBold = false, Color color = Colors.black}) {
  return Text(
    show,
    style: TextStyle(fontSize: uiStyle.fontSize1, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: color),
    overflow: TextOverflow.ellipsis,
  );
}

Text text2(String show, {bool isBold = false, Color color = Colors.black}) {
  return Text(
    show,
    style: TextStyle(fontSize: uiStyle.fontSize2, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: color),
    overflow: TextOverflow.ellipsis,
  );
}

Text text3(String show, {bool isBold = false, Color color = Colors.black}) {
  return Text(
    show,
    style: TextStyle(fontSize: uiStyle.fontSize3, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: color),
    overflow: TextOverflow.ellipsis,
  );
}

Text text4(String show, {bool isBold = false, Color color = Colors.black}) {
  return Text(
    show,
    style: TextStyle(fontSize: uiStyle.fontSize4, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: color),
    overflow: TextOverflow.ellipsis,
  );
}

Widget leadingIcon = Center(
  child: text1(manager.systemName, color: Colors.white),
);

Widget userShow(BuildContext context, List<Person> users) {
  return SingleChildScrollView(
    padding: EdgeInsets.zero,
    child: SizedBox(
      width: double.infinity,
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        alignment: WrapAlignment.start,
        children: users.asMap().entries.map((u) {
          return Tooltip(
            message: personInfoMsg(context, u.value),
            child: Chip(label: text3(u.value.name)),
          );
        }).toList(),
      ),
    ),
  );
}

String userShowText(List<Person> users) {
  String ret = "";

  if (users.isNotEmpty) {
    ret = users[0].name;

    if (users.length > 1) {
      for (var user in users) {
        ret += ", ${user.name}";
      }
    }
  }
  return ret;
}

alertDialog(BuildContext context, String header, message, button) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: uiStyle.roundCorner),
        backgroundColor: Colors.white,
        titlePadding: EdgeInsets.zero,
        title: Container(
          alignment: Alignment.centerLeft,
          width: 24.w,
          height: 5.h,
          decoration: const BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          ),
          child: Row(children: [SizedBox(width: 1.w), text3(header, color: Colors.white, isBold: true)]),
        ),
        content: Container(
          alignment: Alignment.center,
          width: 24.w,
          height: 10.h,
          decoration: BoxDecoration(borderRadius: uiStyle.roundCorner),
          child: text3(message),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: EdgeInsets.only(bottom: 4.h),
        actions: [
          ElevatedButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.5.h)),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(borderRadius: uiStyle.roundCorner),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: text3(button, color: Colors.white)),
        ],
      );
    },
  );
}

Future<DateTime> selectSingleDate(BuildContext context, DateTime iniTime) async {
  return await showDatePicker(
        context: context,
        initialDate: iniTime,
        firstDate: ini.timeStart,
        lastDate: DateTime.now(),
      ) ??
      iniTime;
}

Future<TimeOfDay> selectSingleTime(BuildContext context, TimeOfDay iniTime) async {
  return await showTimePicker(
        context: context,
        initialTime: iniTime,
      ) ??
      iniTime;
}

Future<DateTimeRange> selectDateRange(BuildContext context) async {
  return await showDateRangePicker(
        context: context,
        firstDate: ini.timeStart,
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(
                primary: Colors.white,
                onPrimary: Colors.redAccent,
                surface: Colors.black,
                onSurface: Colors.white,
              ),
              dialogBackgroundColor: Colors.blueGrey,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ConstrainedBox(constraints: BoxConstraints(maxWidth: 40.w, maxHeight: 80.h), child: child)],
            ),
          );
        },
      ) ??
      DateTimeRange(start: ini.timeStart, end: DateTime.now());
}

Future<Appointment> appointmentData(BuildContext context, Appointment input) async {
  int editStatus = input.status;
  bool canSave = false;
  DateTime selectDate = input.appointDate;
  TimeOfDay selectTime = TimeOfDay(hour: input.appointDate.hour, minute: input.appointDate.minute);
  List<Person> lead = [input.lead];
  List<Person> agent = [input.agent];
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
                                userEdit(context, lead, max: 1).then((value) {
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
                                userEdit(context, agent, max: 1).then((value) {
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
                    } else if (lead.isEmpty) {
                      alertDialog(
                        context,
                        context.tr('error'),
                        context.tr('emptyLeads'),
                        context.tr('ok'),
                      );
                    } else if (agent.isEmpty) {
                      alertDialog(
                        context,
                        context.tr('error'),
                        context.tr('emptyAgent'),
                        context.tr('ok'),
                      );
                    } else {
                      canSave = true;
                      Navigator.pop(context);
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

  return canSave
      ? Appointment(
          onSelect: input.onSelect,
          lead: lead[0],
          agent: agent[0],
          status: editStatus,
          projectName: input.projectName,
          appointDate: DateTime(
            selectDate.year,
            selectDate.month,
            selectDate.day,
            selectTime.hour,
            selectTime.minute,
          ),
        )
      : input;
}

Future<Person> personEdit(BuildContext context, Person inputUser) async {
  bool save = false;
  TextEditingController newName = TextEditingController(text: inputUser.name);
  TextEditingController newPhone = TextEditingController(text: inputUser.phone);
  TextEditingController newEmail = TextEditingController(text: inputUser.email);
  TextEditingController newBankCode = TextEditingController(text: inputUser.bankCode);
  TextEditingController newBankAccount = TextEditingController(text: inputUser.bankAccount);
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: uiStyle.roundCorner),
            backgroundColor: Colors.white,
            content: SizedBox(
              width: 20.w,
              height: 45.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: newName,
                    decoration: InputDecoration(
                      isDense: true,
                      border: const OutlineInputBorder(),
                      labelText: context.tr('userName'),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  TextField(
                    controller: newPhone,
                    decoration: InputDecoration(
                      isDense: true,
                      border: const OutlineInputBorder(),
                      labelText: context.tr('userPhone'),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  TextField(
                    controller: newEmail,
                    decoration: InputDecoration(
                      isDense: true,
                      border: const OutlineInputBorder(),
                      labelText: context.tr('userEmail'),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  TextField(
                    controller: newBankCode,
                    decoration: InputDecoration(
                      isDense: true,
                      border: const OutlineInputBorder(),
                      labelText: context.tr('userBankCode'),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  TextField(
                    controller: newBankAccount,
                    decoration: InputDecoration(
                      isDense: true,
                      border: const OutlineInputBorder(),
                      labelText: context.tr('userBankAccount'),
                    ),
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
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
                      newName.text = newPhone.text = newEmail.text = newBankCode.text = newBankAccount.text = "";
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
                    save = true;
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          );
        },
      );
    },
  );

  return save
      ? Person(
          name: newName.text,
          phone: newPhone.text,
          email: newEmail.text,
          bankCode: newBankCode.text,
          bankAccount: newBankAccount.text,
          role: inputUser.role,
        )
      : inputUser;
}

Future<List<Person>> userEdit(BuildContext context, List<Person> inputUsers, {int max = -1}) async {
  bool save = false;
  List<Person> edit = List.of(inputUsers);
  TextEditingController newName = TextEditingController(text: "");
  TextEditingController newPhone = TextEditingController(text: "");
  TextEditingController newEmail = TextEditingController(text: "");
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: uiStyle.roundCorner),
            backgroundColor: Colors.white,
            title: edit.length < max || max == -1
                ? Column(
                    children: [
                      TextField(
                        controller: newName,
                        decoration: InputDecoration(
                          isDense: true,
                          border: const OutlineInputBorder(),
                          labelText: context.tr('userName'),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      TextField(
                        controller: newPhone,
                        decoration: InputDecoration(
                          isDense: true,
                          border: const OutlineInputBorder(),
                          labelText: context.tr('userPhone'),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      TextField(
                        controller: newEmail,
                        decoration: InputDecoration(
                          isDense: true,
                          border: const OutlineInputBorder(),
                          labelText: context.tr('userEmail'),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(child: max == -1 ? text3("${context.tr('total')} : ${edit.length}") : text3("${edit.length} / $max")),
                          SizedBox(width: 2.5.w),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                              borderRadius: uiStyle.roundCorner2,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.add),
                              tooltip: context.tr('add'),
                              onPressed: () {
                                if (newName.text.isNotEmpty) {
                                  setState(() {
                                    edit.add(
                                      Person(
                                        name: newName.text,
                                        phone: newPhone.text == "" ? null : newPhone.text,
                                        email: newEmail.text == "" ? null : newEmail.text,
                                        role: ini.preRoles.last,
                                      ),
                                    );
                                    newPhone.text = newEmail.text = newName.text = "";
                                  });
                                } else {
                                  alertDialog(
                                    context,
                                    context.tr('error'),
                                    context.tr('emptyName'),
                                    context.tr('ok'),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Center(child: text3("${edit.length} / $max")),
            content: Container(
              width: 20.w,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: uiStyle.roundCorner2,
              ),
              constraints: BoxConstraints(minHeight: 5.h, maxHeight: 60.h),
              child: SingleChildScrollView(
                padding: EdgeInsets.zero,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(5),
                  child: Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    alignment: WrapAlignment.center,
                    children: edit.map((label) {
                      return Tooltip(
                        message: personInfoMsg(context, label),
                        child: Chip(
                          label: text3(label.name),
                          onDeleted: () {
                            setState(() {
                              edit.remove(label);
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
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
                      edit.clear();
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
                    save = true;
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          );
        },
      );
    },
  );

  return save ? edit : inputUsers;
}
