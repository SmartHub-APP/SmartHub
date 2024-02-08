import 'interaction.dart';
import '../config.dart';
import '../api/member.dart';
import '../object/member.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:easy_localization/easy_localization.dart';

Widget memberTile(
  bool expandMode,
  Member m,
  BuildContext context,
  Function() onTap, {
  bool isDelete = false,
  bool advanced = false,
}) {
  String personIntro = "${m.company.isEmpty ? "" : m.company}"
      "${m.jobTitle.isEmpty ? "" : m.jobTitle}";
  String msg = "${context.tr('email')} : ${m.account.isEmpty ? "N/A" : m.account}\n"
      "${context.tr('phone')} :  ${m.phone.isEmpty ? "N/A" : m.phone}";

  if (advanced) {
    msg += "\n${context.tr('bankCode')} : ${m.bankCode.isEmpty ? "N/A" : m.bankCode}\n"
        "${context.tr('bankAccount')} : ${m.bankAccount.isEmpty ? "N/A" : m.bankAccount}";
  }

  return Tooltip(
    message: msg,
    textStyle: const TextStyle(fontSize: 12, color: Colors.white),
    decoration: BoxDecoration(color: Colors.black, borderRadius: uiStyle.roundCorner2),
    child: Container(
      padding: expandMode ? EdgeInsets.zero : const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black),
        borderRadius: uiStyle.roundCorner2,
      ),
      child: expandMode
          ? TextButton.icon(
              icon: isDelete ? const Icon(Icons.delete) : const Icon(Icons.add),
              onPressed: onTap,
              label: Column(
                children: [
                  personIntro.length > 2 ? text4(personIntro) : const SizedBox(),
                  text3(m.name),
                ],
              ),
            )
          : Column(
              children: [
                personIntro.length > 2 ? text4(personIntro) : const SizedBox(),
                text3(m.name),
              ],
            ),
    ),
  );
}

Future<List<Member>> userEdit(BuildContext context, List<Member> inputUsers, String scheme) async {
  bool save = false;
  List<Member> edit = List.of(inputUsers);
  List<Member> search = [];
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
                            if (searchBar.text.isNotEmpty) {
                              getMemberList(searchBar.text, scheme).then((value) {
                                setState(() {
                                  search = value;
                                });
                              });
                            } else {
                              alertDialog(context, context.tr('error'), context.tr('emptyQuery'), context.tr('ok'));
                            }
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
                                  constraints: BoxConstraints(minHeight: 5.h, maxHeight: 30.h),
                                  child: SingleChildScrollView(
                                    child: Wrap(
                                      spacing: 4,
                                      runSpacing: 4,
                                      alignment: WrapAlignment.center,
                                      children: search.map((m) {
                                        return memberTile(true, m, context, () {
                                          setState(() {
                                            if (alreadyIn(m.account, edit)) {
                                              alertDialog(context, context.tr('error'), context.tr('userExist'), context.tr('ok'));
                                            } else {
                                              search.remove(m);
                                              edit.add(m);
                                            }
                                          });
                                        });
                                      }).toList(),
                                    ),
                                  )),
                            ),
                          )
                        : text3(context.tr('emptySearch')),
                  /*
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
                              } else if (alreadyIn(newEmail.text, edit)) {
                                alertDialog(context, context.tr('error'), context.tr('userExist'), context.tr('ok'));
                              } else {
                                Member newMember = Member(
                                  id: -1,
                                  name: newName.text,
                                  phone: newPhone.text,
                                  account: newEmail.text,
                                  company: "",
                                  jobTitle: "",
                                  bankCode: "",
                                  bankAccount: "",
                                  role: RoleDefault.guest.toRole(),
                                );
                                postMember(newMember, "").then((value) {
                                  if (value.isEmpty) {
                                    setState(() {
                                      edit.add(newMember);
                                      newName.text = newPhone.text = newEmail.text = "";
                                    });
                                  } else {
                                    alertDialog(context, context.tr('error'), value, context.tr('ok'));
                                  }
                                });
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),*/
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
                      return memberTile(
                        true,
                        label,
                        context,
                        () {
                          setState(() {
                            edit.remove(label);
                          });
                        },
                        isDelete: true,
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
                      newName.text = newPhone.text = newEmail.text = searchBar.text = "";
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

bool alreadyIn(String account, List<Member> users) {
  for (Member m in users) {
    if (m.account == account) {
      return true;
    }
  }
  return false;
}
