import '../object.dart';
import '../tool.dart';
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
  List<Person> search = [];
  TextEditingController newName = TextEditingController(text: "");
  TextEditingController newPhone = TextEditingController(text: "");
  TextEditingController newEmail = TextEditingController(text: "");
  TextEditingController searchBar = TextEditingController(text: "");
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: uiStyle.roundCorner),
            backgroundColor: Colors.white,
            title: Container(
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black, width: 2))),
              padding: const EdgeInsets.only(bottom: 5),
              child: Column(
                children: [
                  text2(context.tr('search')),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchBar,
                          decoration: InputDecoration(
                            isDense: true,
                            border: const OutlineInputBorder(),
                            labelText: context.tr('search'),
                            icon: const Icon(Icons.people_alt_sharp),
                          ),
                        ),
                      ),
                      SizedBox(width: 0.5.w),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: uiStyle.roundCorner2,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.search),
                          tooltip: context.tr('search'),
                          onPressed: () {
                            setState(() {
                              search = List.generate(3, (index) => randomPerson());
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  if (searchBar.text.isNotEmpty)
                    search.isNotEmpty
                        ? Container(
                            width: 40.w,
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
                                  children: search.map((label) {
                                    return Tooltip(
                                      message: personInfoMsg(context, label),
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            search.remove(label);
                                            edit.add(label);
                                          });
                                        },
                                        child: Chip(label: text3(label.name), avatar: const Icon(Icons.add)),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          )
                        : text3(context.tr('emptySearch')),
                  const Divider(color: Colors.grey),
                  text2(context.tr('add')),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: newName,
                          decoration: InputDecoration(
                            isDense: true,
                            border: const OutlineInputBorder(),
                            labelText: context.tr('userName'),
                          ),
                        ),
                      ),
                      SizedBox(width: 1.w),
                      Expanded(
                        child: TextField(
                          controller: newPhone,
                          decoration: InputDecoration(
                            isDense: true,
                            border: const OutlineInputBorder(),
                            labelText: context.tr('userPhone'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: newEmail,
                          decoration: InputDecoration(
                            isDense: true,
                            border: const OutlineInputBorder(),
                            labelText: context.tr('userEmail'),
                          ),
                        ),
                      ),
                      SizedBox(width: 0.5.w),
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
                            setState(() {
                              if (newName.text.isEmpty) {
                                alertDialog(context, context.tr('error'), context.tr('emptyUser'), context.tr('ok'));
                              } else if (newEmail.text.isEmpty) {
                                alertDialog(context, context.tr('error'), context.tr('emptyEmail'), context.tr('ok'));
                              } else {
                                edit.add(
                                  Person(
                                    name: newName.text,
                                    phone: newPhone.text,
                                    account: newEmail.text,
                                    role: Role.guest(),
                                  ),
                                );
                                newName.text = newPhone.text = newEmail.text = "";
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                ],
              ),
            ),
            content: Container(
              width: 40.w,
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
