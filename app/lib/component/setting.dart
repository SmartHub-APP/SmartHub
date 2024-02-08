import 'role.dart';
import 'interaction.dart';
import '../config.dart';
import '../api/role.dart';
import '../api/member.dart';
import '../object/role.dart';
import '../object/member.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

settingDialog(BuildContext context) {
  List<Role> roleList = [];
  List<Member> memberList = [];

  getRoleList().then((fetchRoleList) {
    roleList = fetchRoleList;
    getMemberList("**", "-1").then((fetchMemberList) {
      memberList = fetchMemberList;

      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setSettingState) {
            TextEditingController newName = TextEditingController();
            TextEditingController newEmail = TextEditingController();
            TextEditingController newPhone = TextEditingController();
            TextEditingController newCompany = TextEditingController();
            TextEditingController newJobTitle = TextEditingController();
            TextEditingController newBankCode = TextEditingController();
            TextEditingController newBankAccount = TextEditingController();
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: uiStyle.roundCorner),
              backgroundColor: Colors.white,
              titlePadding: EdgeInsets.zero,
              title: Container(
                alignment: Alignment.centerLeft,
                width: 40.w,
                height: 7.h,
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.white70, width: 2),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                ),
                child: Center(child: text2(context.tr('setting'), color: Colors.white)),
              ),
              content: Container(
                alignment: Alignment.topCenter,
                width: 60.w,
                height: 80.h,
                decoration: BoxDecoration(borderRadius: uiStyle.roundCorner),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ExpansionTile(
                        title: text3(context.tr('settingLanguage'), isBold: true),
                        children: [
                          SizedBox(height: 2.h),
                          Wrap(
                            spacing: 10,
                            runSpacing: 5,
                            alignment: WrapAlignment.center,
                            children: ini.languages.map((lang) {
                              return InkWell(
                                onTap: () {
                                  context.setLocale(lang.ref);
                                },
                                child: Container(
                                  width: 150,
                                  height: 45,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: uiStyle.roundCorner2,
                                  ),
                                  child: text3(lang.langName),
                                ),
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 2.h),
                        ],
                      ),
                      ExpansionTile(
                        title: text3(context.tr('settingUserSetting'), isBold: true),
                        children: [
                          ExpansionTile(
                            title: text3(context.tr('settingUserCreate')),
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: 1.w),
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
                                  SizedBox(width: 0.5.w),
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
                                  SizedBox(width: 1.w),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              Row(
                                children: [
                                  SizedBox(width: 1.w),
                                  Expanded(
                                    child: TextField(
                                      controller: newCompany,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        border: const OutlineInputBorder(),
                                        labelText: context.tr('userCompany'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 0.5.w),
                                  Expanded(
                                    child: TextField(
                                      controller: newPhone,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        border: const OutlineInputBorder(),
                                        labelText: context.tr('userJobTitle'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 1.w),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              Row(
                                children: [
                                  SizedBox(width: 1.w),
                                  Expanded(
                                    child: TextField(
                                      controller: newBankCode,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        border: const OutlineInputBorder(),
                                        labelText: context.tr('userBankCode'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 0.5.w),
                                  Expanded(
                                    child: TextField(
                                      controller: newBankAccount,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        border: const OutlineInputBorder(),
                                        labelText: context.tr('userBankAccount'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 1.w),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              Row(
                                children: [
                                  SizedBox(width: 1.w),
                                  /*
                              DropdownButton2(
                                  underline: const SizedBox(),
                                  iconStyleData: const IconStyleData(icon: SizedBox()),
                                  hint: Text(context.tr('customer_selStatus')),
                                  buttonStyleData: const ButtonStyleData(padding: EdgeInsets.zero),
                                  items: ini.transactionStatus.map((item) => DropdownMenuItem(value: item, child: text3(item))).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      searchStatus = ini.transactionStatus.indexWhere((element) => element == newValue);
                                    });
                                  },
                                  value: ini.transactionStatus[searchStatus],
                                ),
                              */
                                  SizedBox(width: 0.5.w),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: uiStyle.roundCorner2,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.cleaning_services_rounded),
                                      tooltip: context.tr('clear'),
                                      onPressed: () {
                                        setSettingState(() {
                                          newName.text = newPhone.text = newEmail.text = "";
                                          newCompany.text = newJobTitle.text = newBankCode.text = newBankAccount.text = "";
                                        });
                                      },
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
                                      icon: const Icon(Icons.save_alt),
                                      tooltip: context.tr('save'),
                                      onPressed: () {
                                        setSettingState(() {
                                          if (newName.text.isEmpty) {
                                            alertDialog(context, context.tr('error'), context.tr('emptyUser'), context.tr('ok'));
                                          } else if (newEmail.text.isEmpty) {
                                            alertDialog(context, context.tr('error'), context.tr('emptyEmail'), context.tr('ok'));
                                          }

                                          Member newMember = Member(
                                            id: -1,
                                            name: newName.text,
                                            phone: newPhone.text,
                                            account: newEmail.text,
                                            company: newCompany.text,
                                            jobTitle: newJobTitle.text,
                                            bankCode: newBankCode.text,
                                            bankAccount: newBankAccount.text,
                                            role: RoleDefault.guest.toRole(),
                                          );

                                          if (memberExist(newMember)) {
                                            alertDialog(context, context.tr('error'), context.tr('userExist'), context.tr('ok'));
                                          } else {
                                            postMember(newMember, "").then((value) {
                                              if (value.isEmpty) {
                                                setSettingState(() {
                                                  newName.text = newPhone.text = newEmail.text = "";
                                                  newCompany.text = newJobTitle.text = newBankCode.text = newBankAccount.text = "";
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
                                  SizedBox(width: 1.w),
                                ],
                              ),
                              SizedBox(height: 1.h)
                            ],
                          ),
                          ExpansionTile(
                            title: text3(context.tr('settingUserList')),
                            children: [],
                          )
                        ],
                      ),
                      ExpansionTile(
                        title: text3(context.tr('settingRoleSetting'), isBold: true),
                        children: [
                          ExpansionTile(
                            title: text3(context.tr('settingRoleCreate')),
                            children: [
                              Row(
                                children: [
                                  SizedBox(width: 1.w),
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
                                  SizedBox(width: 0.5.w),
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
                                  SizedBox(width: 1.w),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              Row(
                                children: [
                                  SizedBox(width: 1.w),
                                  Expanded(
                                    child: TextField(
                                      controller: newCompany,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        border: const OutlineInputBorder(),
                                        labelText: context.tr('userCompany'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 0.5.w),
                                  Expanded(
                                    child: TextField(
                                      controller: newPhone,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        border: const OutlineInputBorder(),
                                        labelText: context.tr('userJobTitle'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 1.w),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              Row(
                                children: [
                                  SizedBox(width: 1.w),
                                  Expanded(
                                    child: TextField(
                                      controller: newBankCode,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        border: const OutlineInputBorder(),
                                        labelText: context.tr('userBankCode'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 0.5.w),
                                  Expanded(
                                    child: TextField(
                                      controller: newBankAccount,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        border: const OutlineInputBorder(),
                                        labelText: context.tr('userBankAccount'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 1.w),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              Row(
                                children: [
                                  SizedBox(width: 1.w),
                                  /*
                              DropdownButton2(
                                  underline: const SizedBox(),
                                  iconStyleData: const IconStyleData(icon: SizedBox()),
                                  hint: Text(context.tr('customer_selStatus')),
                                  buttonStyleData: const ButtonStyleData(padding: EdgeInsets.zero),
                                  items: ini.transactionStatus.map((item) => DropdownMenuItem(value: item, child: text3(item))).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      searchStatus = ini.transactionStatus.indexWhere((element) => element == newValue);
                                    });
                                  },
                                  value: ini.transactionStatus[searchStatus],
                                ),
                              */
                                  SizedBox(width: 0.5.w),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: uiStyle.roundCorner2,
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.cleaning_services_rounded),
                                      tooltip: context.tr('clear'),
                                      onPressed: () {
                                        setSettingState(() {
                                          newName.text = newPhone.text = newEmail.text = "";
                                          newCompany.text = newJobTitle.text = newBankCode.text = newBankAccount.text = "";
                                        });
                                      },
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
                                      icon: const Icon(Icons.save_alt),
                                      tooltip: context.tr('save'),
                                      onPressed: () {
                                        setSettingState(() {
                                          if (newName.text.isEmpty) {
                                            alertDialog(context, context.tr('error'), context.tr('emptyUser'), context.tr('ok'));
                                          } else if (newEmail.text.isEmpty) {
                                            alertDialog(context, context.tr('error'), context.tr('emptyEmail'), context.tr('ok'));
                                          }

                                          Member newMember = Member(
                                            id: -1,
                                            name: newName.text,
                                            phone: newPhone.text,
                                            account: newEmail.text,
                                            company: newCompany.text,
                                            jobTitle: newJobTitle.text,
                                            bankCode: newBankCode.text,
                                            bankAccount: newBankAccount.text,
                                            role: RoleDefault.guest.toRole(),
                                          );

                                          if (memberExist(newMember)) {
                                            alertDialog(context, context.tr('error'), context.tr('userExist'), context.tr('ok'));
                                          } else {
                                            postMember(newMember, "").then((value) {
                                              if (value.isEmpty) {
                                                setSettingState(() {
                                                  newName.text = newPhone.text = newEmail.text = "";
                                                  newCompany.text = newJobTitle.text = newBankCode.text = newBankAccount.text = "";
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
                                  SizedBox(width: 1.w),
                                ],
                              ),
                              SizedBox(height: 1.h)
                            ],
                          ),
                          ExpansionTile(
                            title: text3(context.tr('settingRoleList')),
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                itemCount: roleList.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.h),
                                    decoration: BoxDecoration(
                                      color: index % 2 == 0 ? Colors.white : Colors.grey[200],
                                      border: Border.all(color: Colors.black),
                                      borderRadius: uiStyle.roundCorner2,
                                    ),
                                    child: ListTile(
                                      title: text3(roleList[index].name),
                                      subtitle: roleInfo(roleList[index].permission.toString(), context),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: 1.h),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actionsPadding: EdgeInsets.only(bottom: 2.h),
              actions: [
                ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h)),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: uiStyle.roundCorner)),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: text3(context.tr('save'), color: Colors.white),
                ),
              ],
            );
          });
        },
      );
    });
  });
}
