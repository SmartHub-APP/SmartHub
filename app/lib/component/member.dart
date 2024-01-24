import 'interaction.dart';
import '../object.dart';
import '../api/member.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:easy_localization/easy_localization.dart';

Future<List<Member>> userEdit(BuildContext context, List<Member> inputUsers) async {
  bool save = false;
  List<Member> edit = List.of(inputUsers);
  List<MemberGET> search = [];
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
                            getMemberList(searchBar.text, "-1").then((value) {
                              setState(() {
                                search = value;
                              });
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
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            search.remove(label);
                                            //edit.add(label);
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
                                  Member(
                                    id: -1,
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