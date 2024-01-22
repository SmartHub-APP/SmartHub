import '../tool.dart';
import '../config.dart';
import '../object.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

Future<Transaction?> transactionCustomer(BuildContext context, Transaction inputTrans) async {
  int currentIndex = 0;
  int editStatus = inputTrans.status;
  int editClaimed = inputTrans.payStatus;
  bool canSave = false;
  DateTime selectDate = inputTrans.saleDate;
  TextEditingController editUnit = TextEditingController(text: inputTrans.unit);
  TextEditingController editPrice = TextEditingController(text: inputTrans.price.toString());
  TextEditingController editCommission = TextEditingController(text: inputTrans.commission.toString());
  TextEditingController editProjectName = TextEditingController(text: inputTrans.projectName);
  TextEditingController editDescription = TextEditingController(text: inputTrans.description);
  List<Person> agents = inputTrans.agent;
  List<Person> clients = inputTrans.clients;
  List<Person> appoint = inputTrans.appoint == null ? [] : [inputTrans.appoint!];
  List<File> documents = inputTrans.documents;
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: uiStyle.roundCorner),
            backgroundColor: Colors.white,
            titlePadding: EdgeInsets.zero,
            content: SizedBox(
                width: 40.w,
                height: 80.h,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          SizedBox(width: 10.w, child: text3("${context.tr('customer_colClient')} : ")),
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              onPressed: () {
                                userEdit(context, clients).then((value) {
                                  setState(() {
                                    clients = value;
                                  });
                                });
                              },
                              child: Container(
                                height: 6.h,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: uiStyle.roundCorner2),
                                child: userShow(context, clients),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 2.h),
                      TextField(
                        controller: editProjectName,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: context.tr('customer_colProject'),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      TextField(
                        controller: editUnit,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: context.tr('customer_colUnit'),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      TextField(
                        controller: editPrice,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: context.tr('customer_colPrice'),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      TextField(
                        controller: editCommission,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: context.tr('payment_colPercent'),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      TextField(
                        controller: editDescription,
                        minLines: 1,
                        maxLines: 10,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: context.tr('customer_colDescription_optional'),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          SizedBox(width: 10.w, child: text3("${context.tr('customer_colStatus')} : ")),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: uiStyle.roundCorner2),
                              child: DropdownButton2(
                                underline: const SizedBox(),
                                iconStyleData: const IconStyleData(icon: SizedBox()),
                                hint: Text(context.tr('customer_selStatus')),
                                buttonStyleData: const ButtonStyleData(padding: EdgeInsets.zero),
                                items: ini.transactionStatus.map((item) => DropdownMenuItem(value: item, child: text3(item))).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    editStatus = ini.transactionStatus.indexWhere((element) => element == newValue);
                                  });
                                },
                                value: ini.transactionStatus[editStatus],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          SizedBox(width: 10.w, child: text3("${context.tr('customer_colDate')} : ")),
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
                          SizedBox(width: 10.w, child: text3("${context.tr('customer_colAgent')} : ")),
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              onPressed: () {
                                userEdit(context, agents).then((value) {
                                  setState(() {
                                    agents = value;
                                  });
                                });
                              },
                              child: Container(
                                height: 6.h,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: uiStyle.roundCorner2),
                                child: userShow(context, agents),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          SizedBox(width: 10.w, child: text3("${context.tr('customer_colAppoint')} : ")),
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              onPressed: () {
                                userEdit(context, appoint, max: 1).then((value) {
                                  setState(() {
                                    appoint = value;
                                  });
                                });
                              },
                              child: Container(
                                height: 6.h,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: uiStyle.roundCorner2),
                                child: userShow(context, appoint),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text3("${context.tr('customer_colDocument')} : "),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: uiStyle.roundCorner2,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.hide_image),
                                    tooltip: context.tr('delete'),
                                    onPressed: () {
                                      setState(() {
                                        documents.removeAt(currentIndex);
                                        if (currentIndex != 0) {
                                          currentIndex--;
                                        }
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 25),
                                if (documents.isNotEmpty) text3("${currentIndex + 1} / ${documents.length}"),
                                const SizedBox(width: 25),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: uiStyle.roundCorner2,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.upload_file),
                                    tooltip: context.tr('upload'),
                                    onPressed: () {
                                      setState(() {
                                        documents.add(randomPic());
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Container(
                        height: 60.h,
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: uiStyle.roundCorner2),
                        child: documents.isEmpty
                            ? Center(child: text2(context.tr('emptyDocument')))
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: currentIndex != 0
                                        ? IconButton(
                                            icon: const Icon(Icons.arrow_back_ios_outlined),
                                            onPressed: () {
                                              setState(() {
                                                currentIndex--;
                                              });
                                            },
                                          )
                                        : const SizedBox(),
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: Image.network(
                                      documents[currentIndex].fileHash,
                                      frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                                        if (wasSynchronouslyLoaded) return child;
                                        return AnimatedOpacity(
                                          opacity: frame == null ? 0 : 1,
                                          duration: const Duration(seconds: 1),
                                          curve: Curves.easeIn,
                                          child: child,
                                        );
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: currentIndex != documents.length - 1
                                        ? IconButton(
                                            icon: const Icon(Icons.arrow_forward_ios_outlined),
                                            onPressed: () {
                                              setState(() {
                                                currentIndex++;
                                              });
                                            },
                                          )
                                        : const SizedBox(),
                                  ),
                                ],
                              ),
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
                      editProjectName.text = editUnit.text = editPrice.text = editCommission.text = editDescription.text = "";
                      editStatus = editClaimed = 0;
                      selectDate = ini.timeStart;
                      appoint = clients = agents = [];
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
                    if (editUnit.text.isEmpty) {
                      alertDialog(
                        context,
                        context.tr('error'),
                        context.tr('emptyClass'),
                        context.tr('ok'),
                      );
                    } else if (editProjectName.text.isEmpty) {
                      alertDialog(
                        context,
                        context.tr('error'),
                        context.tr('emptyName'),
                        context.tr('ok'),
                      );
                    } else if (editPrice.text.isEmpty) {
                      alertDialog(
                        context,
                        context.tr('error'),
                        context.tr('emptyPrice'),
                        context.tr('ok'),
                      );
                    } else if (editCommission.text.isEmpty) {
                      alertDialog(
                        context,
                        context.tr('error'),
                        context.tr('emptyPrice'),
                        context.tr('ok'),
                      );
                    } else if (editStatus == 0) {
                      alertDialog(
                        context,
                        context.tr('error'),
                        context.tr('emptyStatus'),
                        context.tr('ok'),
                      );
                    } else if (editClaimed == 0) {
                      alertDialog(
                        context,
                        context.tr('error'),
                        context.tr('emptyPayStatus'),
                        context.tr('ok'),
                      );
                    } else if (selectDate == ini.timeStart) {
                      alertDialog(
                        context,
                        context.tr('error'),
                        context.tr('emptyDate') + ini.timeStart.toString().substring(0, 10),
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
      ? Transaction(
          onSelect: inputTrans.onSelect,
          id: inputTrans.id,
          price: int.parse(editPrice.text),
          priceSQFT: inputTrans.priceSQFT,
          status: editStatus,
          payStatus: editClaimed,
          commission: double.parse(editCommission.text),
          projectName: editProjectName.text,
          unit: editUnit.text,
          name: inputTrans.name,
          location: inputTrans.location,
          developer: inputTrans.developer,
          description: editDescription.text,
          clients: clients,
          saleDate: selectDate,
          launchDate: inputTrans.launchDate,
          appoint: appoint.isNotEmpty ? appoint[0] : null,
          agent: agents,
          documents: documents,
        )
      : null;
}

Future<Transaction> transactionProduct(BuildContext context, Transaction inputTrans) async {
  int currentIndex = 0;
  int editStatus = inputTrans.status;
  int editClaimed = inputTrans.payStatus;
  bool canSave = false;
  DateTime selectDate = inputTrans.saleDate;
  TextEditingController editUnit = TextEditingController(text: inputTrans.unit);
  TextEditingController editPrice = TextEditingController(text: inputTrans.price.toString());
  TextEditingController editCommission = TextEditingController(text: inputTrans.commission.toString());
  TextEditingController editProjectName = TextEditingController(text: inputTrans.projectName);
  TextEditingController editDescription = TextEditingController(text: inputTrans.description);
  List<Person> agents = inputTrans.agent;
  List<Person> clients = inputTrans.clients;
  List<Person> appoint = inputTrans.appoint == null ? [] : [inputTrans.appoint!];
  List<File> documents = inputTrans.documents;
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: uiStyle.roundCorner),
            backgroundColor: Colors.white,
            titlePadding: EdgeInsets.zero,
            content: SizedBox(
                width: 40.w,
                height: 80.h,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          SizedBox(width: 10.w, child: text3("${context.tr('customer_colClient')} : ")),
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              onPressed: () {
                                userEdit(context, clients).then((value) {
                                  setState(() {
                                    clients = value;
                                  });
                                });
                              },
                              child: Container(
                                height: 6.h,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: uiStyle.roundCorner2),
                                child: userShow(context, clients),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 2.h),
                      TextField(
                        controller: editProjectName,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: context.tr('customer_colProject'),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      TextField(
                        controller: editUnit,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: context.tr('customer_colUnit'),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      TextField(
                        controller: editPrice,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: context.tr('customer_colPrice'),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      TextField(
                        controller: editCommission,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: context.tr('payment_colPercent'),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      TextField(
                        controller: editDescription,
                        minLines: 1,
                        maxLines: 10,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: context.tr('customer_colDescription_optional'),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          SizedBox(width: 10.w, child: text3("${context.tr('customer_colStatus')} : ")),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: uiStyle.roundCorner2),
                              child: DropdownButton2(
                                underline: const SizedBox(),
                                iconStyleData: const IconStyleData(icon: SizedBox()),
                                hint: Text(context.tr('customer_selStatus')),
                                buttonStyleData: const ButtonStyleData(padding: EdgeInsets.zero),
                                items: ini.transactionStatus.map((item) => DropdownMenuItem(value: item, child: text3(item))).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    editStatus = ini.transactionStatus.indexWhere((element) => element == newValue);
                                  });
                                },
                                value: ini.transactionStatus[editStatus],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          SizedBox(width: 10.w, child: text3("${context.tr('customer_colDate')} : ")),
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
                          SizedBox(width: 10.w, child: text3("${context.tr('customer_colAgent')} : ")),
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              onPressed: () {
                                userEdit(context, agents).then((value) {
                                  setState(() {
                                    agents = value;
                                  });
                                });
                              },
                              child: Container(
                                height: 6.h,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: uiStyle.roundCorner2),
                                child: userShow(context, agents),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          SizedBox(width: 10.w, child: text3("${context.tr('customer_colAppoint')} : ")),
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              onPressed: () {
                                userEdit(context, appoint, max: 1).then((value) {
                                  setState(() {
                                    appoint = value;
                                  });
                                });
                              },
                              child: Container(
                                height: 6.h,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: uiStyle.roundCorner2),
                                child: userShow(context, appoint),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text3("${context.tr('customer_colDocument')} : "),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: uiStyle.roundCorner2,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.hide_image),
                                    tooltip: context.tr('delete'),
                                    onPressed: () {
                                      setState(() {
                                        documents.removeAt(currentIndex);
                                        if (currentIndex != 0) {
                                          currentIndex--;
                                        }
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 25),
                                if (documents.isNotEmpty) text3("${currentIndex + 1} / ${documents.length}"),
                                const SizedBox(width: 25),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: uiStyle.roundCorner2,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.upload_file),
                                    tooltip: context.tr('upload'),
                                    onPressed: () {
                                      setState(() {
                                        documents.add(randomPic());
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Container(
                        height: 60.h,
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: uiStyle.roundCorner2),
                        child: documents.isEmpty
                            ? Center(child: text2(context.tr('emptyDocument')))
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: currentIndex != 0
                                        ? IconButton(
                                            icon: const Icon(Icons.arrow_back_ios_outlined),
                                            onPressed: () {
                                              setState(() {
                                                currentIndex--;
                                              });
                                            },
                                          )
                                        : const SizedBox(),
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: Image.network(
                                      documents[currentIndex].fileHash,
                                      frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                                        if (wasSynchronouslyLoaded) return child;
                                        return AnimatedOpacity(
                                          opacity: frame == null ? 0 : 1,
                                          duration: const Duration(seconds: 1),
                                          curve: Curves.easeIn,
                                          child: child,
                                        );
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: currentIndex != documents.length - 1
                                        ? IconButton(
                                            icon: const Icon(Icons.arrow_forward_ios_outlined),
                                            onPressed: () {
                                              setState(() {
                                                currentIndex++;
                                              });
                                            },
                                          )
                                        : const SizedBox(),
                                  ),
                                ],
                              ),
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
                      editProjectName.text = editUnit.text = editPrice.text = editCommission.text = editDescription.text = "";
                      editStatus = editClaimed = 0;
                      selectDate = ini.timeStart;
                      appoint = clients = agents = [];
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
                    if (editUnit.text.isEmpty) {
                      alertDialog(
                        context,
                        context.tr('error'),
                        context.tr('emptyClass'),
                        context.tr('ok'),
                      );
                    } else if (editProjectName.text.isEmpty) {
                      alertDialog(
                        context,
                        context.tr('error'),
                        context.tr('emptyName'),
                        context.tr('ok'),
                      );
                    } else if (editPrice.text.isEmpty) {
                      alertDialog(
                        context,
                        context.tr('error'),
                        context.tr('emptyPrice'),
                        context.tr('ok'),
                      );
                    } else if (editCommission.text.isEmpty) {
                      alertDialog(
                        context,
                        context.tr('error'),
                        context.tr('emptyPrice'),
                        context.tr('ok'),
                      );
                    } else if (editStatus == 0) {
                      alertDialog(
                        context,
                        context.tr('error'),
                        context.tr('emptyStatus'),
                        context.tr('ok'),
                      );
                    } else if (editClaimed == 0) {
                      alertDialog(
                        context,
                        context.tr('error'),
                        context.tr('emptyPayStatus'),
                        context.tr('ok'),
                      );
                    } else if (selectDate == ini.timeStart) {
                      alertDialog(
                        context,
                        context.tr('error'),
                        context.tr('emptyDate') + ini.timeStart.toString().substring(0, 10),
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
      ? Transaction(
          onSelect: inputTrans.onSelect,
          id: inputTrans.id,
          price: int.parse(editPrice.text),
          priceSQFT: inputTrans.priceSQFT,
          status: editStatus,
          payStatus: editClaimed,
          commission: double.parse(editCommission.text),
          projectName: editProjectName.text,
          unit: editUnit.text,
          name: inputTrans.name,
          location: inputTrans.location,
          developer: inputTrans.developer,
          description: editDescription.text,
          clients: clients,
          saleDate: selectDate,
          launchDate: inputTrans.launchDate,
          appoint: appoint.isNotEmpty ? appoint[0] : null,
          agent: agents,
          documents: documents,
        )
      : inputTrans;
}

Future<Transaction> transactionPayment(BuildContext context, Transaction inputTrans) async {
  int currentIndex = 0;
  int editStatus = inputTrans.status;
  int editClaimed = inputTrans.payStatus;
  bool canSave = false;
  DateTime selectDate = inputTrans.saleDate;
  TextEditingController editUnit = TextEditingController(text: inputTrans.unit);
  TextEditingController editPrice = TextEditingController(text: inputTrans.price.toString());
  TextEditingController editCommission = TextEditingController(text: inputTrans.commission.toString());
  TextEditingController editProjectName = TextEditingController(text: inputTrans.projectName);
  TextEditingController editDescription = TextEditingController(text: inputTrans.description);
  List<Person> agents = inputTrans.agent;
  List<Person> clients = inputTrans.clients;
  List<Person> appoint = inputTrans.appoint == null ? [] : [inputTrans.appoint!];
  List<File> documents = inputTrans.documents;
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: uiStyle.roundCorner),
            backgroundColor: Colors.white,
            titlePadding: EdgeInsets.zero,
            content: SizedBox(
                width: 40.w,
                height: 80.h,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          SizedBox(width: 10.w, child: text3("${context.tr('customer_colClient')} : ")),
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              onPressed: () {
                                userEdit(context, clients).then((value) {
                                  setState(() {
                                    clients = value;
                                  });
                                });
                              },
                              child: Container(
                                height: 6.h,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: uiStyle.roundCorner2),
                                child: userShow(context, clients),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 2.h),
                      TextField(
                        controller: editProjectName,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: context.tr('customer_colProject'),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      TextField(
                        controller: editUnit,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: context.tr('customer_colUnit'),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      TextField(
                        controller: editPrice,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: context.tr('customer_colPrice'),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      TextField(
                        controller: editCommission,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: context.tr('payment_colPercent'),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      TextField(
                        controller: editDescription,
                        minLines: 1,
                        maxLines: 10,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: context.tr('customer_colDescription_optional'),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          SizedBox(width: 10.w, child: text3("${context.tr('customer_colStatus')} : ")),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: uiStyle.roundCorner2),
                              child: DropdownButton2(
                                underline: const SizedBox(),
                                iconStyleData: const IconStyleData(icon: SizedBox()),
                                hint: Text(context.tr('customer_selStatus')),
                                buttonStyleData: const ButtonStyleData(padding: EdgeInsets.zero),
                                items: ini.transactionStatus.map((item) => DropdownMenuItem(value: item, child: text3(item))).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    editStatus = ini.transactionStatus.indexWhere((element) => element == newValue);
                                  });
                                },
                                value: ini.transactionStatus[editStatus],
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          SizedBox(width: 10.w, child: text3("${context.tr('customer_colDate')} : ")),
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
                          SizedBox(width: 10.w, child: text3("${context.tr('customer_colAgent')} : ")),
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              onPressed: () {
                                userEdit(context, agents).then((value) {
                                  setState(() {
                                    agents = value;
                                  });
                                });
                              },
                              child: Container(
                                height: 6.h,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: uiStyle.roundCorner2),
                                child: userShow(context, agents),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          SizedBox(width: 10.w, child: text3("${context.tr('customer_colAppoint')} : ")),
                          Expanded(
                            child: TextButton(
                              style: TextButton.styleFrom(padding: EdgeInsets.zero),
                              onPressed: () {
                                userEdit(context, appoint, max: 1).then((value) {
                                  setState(() {
                                    appoint = value;
                                  });
                                });
                              },
                              child: Container(
                                height: 6.h,
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: uiStyle.roundCorner2),
                                child: userShow(context, appoint),
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text3("${context.tr('customer_colDocument')} : "),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: uiStyle.roundCorner2,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.hide_image),
                                    tooltip: context.tr('delete'),
                                    onPressed: () {
                                      setState(() {
                                        documents.removeAt(currentIndex);
                                        if (currentIndex != 0) {
                                          currentIndex--;
                                        }
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 25),
                                if (documents.isNotEmpty) text3("${currentIndex + 1} / ${documents.length}"),
                                const SizedBox(width: 25),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: uiStyle.roundCorner2,
                                  ),
                                  child: IconButton(
                                    icon: const Icon(Icons.upload_file),
                                    tooltip: context.tr('upload'),
                                    onPressed: () {
                                      setState(() {
                                        documents.add(randomPic());
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Container(
                        height: 60.h,
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: uiStyle.roundCorner2),
                        child: documents.isEmpty
                            ? Center(child: text2(context.tr('emptyDocument')))
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: currentIndex != 0
                                        ? IconButton(
                                            icon: const Icon(Icons.arrow_back_ios_outlined),
                                            onPressed: () {
                                              setState(() {
                                                currentIndex--;
                                              });
                                            },
                                          )
                                        : const SizedBox(),
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: Image.network(
                                      documents[currentIndex].fileHash,
                                      frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                                        if (wasSynchronouslyLoaded) return child;
                                        return AnimatedOpacity(
                                          opacity: frame == null ? 0 : 1,
                                          duration: const Duration(seconds: 1),
                                          curve: Curves.easeIn,
                                          child: child,
                                        );
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: currentIndex != documents.length - 1
                                        ? IconButton(
                                            icon: const Icon(Icons.arrow_forward_ios_outlined),
                                            onPressed: () {
                                              setState(() {
                                                currentIndex++;
                                              });
                                            },
                                          )
                                        : const SizedBox(),
                                  ),
                                ],
                              ),
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
                      editProjectName.text = editUnit.text = editPrice.text = editCommission.text = editDescription.text = "";
                      editStatus = editClaimed = 0;
                      selectDate = ini.timeStart;
                      appoint = clients = agents = [];
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
                    if (editUnit.text.isEmpty) {
                      alertDialog(
                        context,
                        context.tr('error'),
                        context.tr('emptyClass'),
                        context.tr('ok'),
                      );
                    } else if (editProjectName.text.isEmpty) {
                      alertDialog(
                        context,
                        context.tr('error'),
                        context.tr('emptyName'),
                        context.tr('ok'),
                      );
                    } else if (editPrice.text.isEmpty) {
                      alertDialog(
                        context,
                        context.tr('error'),
                        context.tr('emptyPrice'),
                        context.tr('ok'),
                      );
                    } else if (editCommission.text.isEmpty) {
                      alertDialog(
                        context,
                        context.tr('error'),
                        context.tr('emptyPrice'),
                        context.tr('ok'),
                      );
                    } else if (editStatus == 0) {
                      alertDialog(
                        context,
                        context.tr('error'),
                        context.tr('emptyStatus'),
                        context.tr('ok'),
                      );
                    } else if (editClaimed == 0) {
                      alertDialog(
                        context,
                        context.tr('error'),
                        context.tr('emptyPayStatus'),
                        context.tr('ok'),
                      );
                    } else if (selectDate == ini.timeStart) {
                      alertDialog(
                        context,
                        context.tr('error'),
                        context.tr('emptyDate') + ini.timeStart.toString().substring(0, 10),
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
      ? Transaction(
          onSelect: inputTrans.onSelect,
          id: inputTrans.id,
          price: int.parse(editPrice.text),
          priceSQFT: inputTrans.priceSQFT,
          status: editStatus,
          payStatus: editClaimed,
          commission: double.parse(editCommission.text),
          projectName: editProjectName.text,
          unit: editUnit.text,
          name: inputTrans.name,
          location: inputTrans.location,
          developer: inputTrans.developer,
          description: editDescription.text,
          clients: clients,
          saleDate: selectDate,
          launchDate: inputTrans.launchDate,
          appoint: appoint.isNotEmpty ? appoint[0] : null,
          agent: agents,
          documents: documents,
        )
      : inputTrans;
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
