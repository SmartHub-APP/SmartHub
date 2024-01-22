import '../config.dart';
import '../object.dart';
import 'interaction.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:easy_localization/easy_localization.dart';

Future<Person> personEdit(BuildContext context, Person inputUser) async {
  bool save = false;
  TextEditingController newName = TextEditingController(text: inputUser.name);
  TextEditingController newPhone = TextEditingController(text: inputUser.phone);
  TextEditingController newEmail = TextEditingController(text: inputUser.account);
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
          account: newEmail.text,
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
                                        account: newEmail.text,
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
