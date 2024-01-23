import '../config.dart';
import '../object.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
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
  return "${p.phone == null ? "" : "${context.tr('phone')} : ${p.phone}\n"}${context.tr('email')} : ${p.account}";
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
            child: Chip(label: text4(u.value.name), labelPadding: EdgeInsets.zero),
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
      for (var user in users.sublist(1)) {
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

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: text2(message),
      duration: const Duration(seconds: 1),
      action: SnackBarAction(
        label: context.tr('close'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ),
  );
}
