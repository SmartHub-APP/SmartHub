import '../config.dart';
import '../api/role.dart';
import '../api/member.dart';
import '../object/role.dart';
import '../object/member.dart';
import '../component/interaction.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SettingDialog extends StatefulWidget {
  const SettingDialog({super.key});

  @override
  State<SettingDialog> createState() => _SettingDialogState();
}

class _SettingDialogState extends State<SettingDialog> {
  TextEditingController newName = TextEditingController();
  TextEditingController newEmail = TextEditingController();
  TextEditingController newPhone = TextEditingController();
  TextEditingController newCompany = TextEditingController();
  TextEditingController newJobTitle = TextEditingController();
  TextEditingController newBankCode = TextEditingController();
  TextEditingController newBankAccount = TextEditingController();
  TextEditingController newRoleName = TextEditingController();
  List<int> newPerms = List.filled(ini.maxPerm, 0);
  List<Role> roleList = [];
  List<Member> memberList = [];

  editPerm(int index) {
    return Expanded(
      child: DropdownButton2(
        underline: const SizedBox(),
        iconStyleData: const IconStyleData(icon: SizedBox()),
        buttonStyleData: const ButtonStyleData(padding: EdgeInsets.zero),
        items: ini.permModes.map((item) => DropdownMenuItem(value: item, child: text3(item.toString()))).toList(),
        onChanged: (newValue) {
          setState(() {
            newPerms[index] = newValue ?? 0;
          });
        },
        value: ini.permModes[newPerms[index]],
      ),
    );
  }

  Future<bool> fetchData() async {
    EasyLoading.show(status: context.tr('loading'));
    roleList = await getRoleList();
    memberList = await getMemberList("**", "-1");
    EasyLoading.dismiss();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchData(),
      builder: (context, snapshot) {
        Widget viewPage = Container();
        if (snapshot.hasData) {
          viewPage = Container(
            alignment: Alignment.topCenter,
            width: 60.w,
            height: 80.h,
            decoration: BoxDecoration(borderRadius: uiStyle.roundCorner),
            child: SingleChildScrollView(
              child: Column(children: [settingLanguage(), settingMember(), settingRole()]),
            ),
          );
        } else if (snapshot.hasError) {
          viewPage = Center(child: Text('${context.tr("error")}\n${snapshot.error}'));
        } else {
          viewPage = loadingData();
        }
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
          content: viewPage,
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
      },
    );
  }

  Widget loadingData() {
    return Container(
      width: 60.w,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          SizedBox(height: 5.h),
          text3(context.tr('loading')),
        ],
      ),
    );
  }

  Widget settingLanguage() {
    return ExpansionTile(
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
    );
  }

  Widget settingMember() {
    return ExpansionTile(
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
                      setState(() {
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
                      setState(() {
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
                              setState(() {
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
          children: const [],
        )
      ],
    );
  }

  Widget settingRole() {
    return ExpansionTile(
      title: text3(context.tr('settingRoleSetting'), isBold: true),
      children: [
        ExpansionTile(
          title: text3(context.tr('settingRoleCreate')),
          children: [
            Row(
              children: [
                SizedBox(width: 1.w),
                Expanded(child: Row(children: [text4("${context.tr('dashboard_tabName')} : "), editPerm(0)])),
                SizedBox(width: 0.5.w),
                Expanded(child: Row(children: [text4("${context.tr('customer_tabName')} : "), editPerm(1)])),
                SizedBox(width: 0.5.w),
                Expanded(child: Row(children: [text4("${context.tr('product_tabName')} : "), editPerm(2)])),
                SizedBox(width: 1.w),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              children: [
                SizedBox(width: 1.w),
                Expanded(child: Row(children: [text4('${context.tr('leadsAppointment_tabName')} : '), editPerm(3)])),
                SizedBox(width: 0.5.w),
                Expanded(child: Row(children: [text4('${context.tr('payment_tabName')} : '), editPerm(4)])),
                SizedBox(width: 0.5.w),
                Expanded(child: Row(children: [text4('${context.tr('setting')} : '), editPerm(5)])),
                SizedBox(width: 1.w),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 1.w),
                Expanded(
                  child: TextField(
                    controller: newRoleName,
                    decoration: InputDecoration(
                      isDense: true,
                      border: const OutlineInputBorder(),
                      labelText: context.tr('userRoleName'),
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
                    icon: const Icon(Icons.cleaning_services_rounded),
                    tooltip: context.tr('clear'),
                    onPressed: () {
                      setState(() {
                        newRoleName.text = "";
                        newPerms = List.filled(ini.maxPerm, 0);
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
                    icon: const Icon(Icons.save_alt),
                    tooltip: context.tr('save'),
                    onPressed: () {
                      setState(() {
                        if (newRoleName.text.isEmpty) {
                          alertDialog(context, context.tr('error'), context.tr('emptyRole'), context.tr('ok'));
                        } else {
                          final newRole = RolePostRequest(
                            name: newRoleName.text,
                            permission: newPerms.fold(0, (previousValue, element) => previousValue * 10 + element),
                          );

                          roleExist(newRole).then((isExist) {
                            if (isExist) {
                              alertDialog(context, context.tr('error'), context.tr('settingRoleExist'), context.tr('ok'));
                            } else {
                              postRole(newRole).then((value) {
                                if (value.isEmpty) {
                                  setState(() {
                                    newRoleName.text = "";
                                    newPerms = List.filled(ini.maxPerm, 0);
                                  });
                                } else {
                                  alertDialog(context, context.tr('error'), value, context.tr('ok'));
                                }
                              });
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
                String permText = roleList[index].permission.toString();
                List<String> permList = List.filled(ini.maxPerm, "0");

                for (var i = 0; i < ini.maxPerm; i++) {
                  if (permText.length > i) {
                    permList[i] = permText[i];
                  }
                }
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 0.5.h, horizontal: 1.h),
                  decoration: BoxDecoration(
                    color: index % 2 == 0 ? Colors.white : Colors.grey[200],
                    border: Border.all(color: Colors.black),
                    borderRadius: uiStyle.roundCorner2,
                  ),
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        text3(roleList[index].name),
                        SizedBox(width: 1.w),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          tooltip: context.tr('delete'),
                          onPressed: () {
                            setState(() {
                              deleteRole([roleList[index].id]).then((value) {
                                if (value.isEmpty) {
                                  fetchData().then((value) => setState(() {}));
                                } else {
                                  alertDialog(context, context.tr('error'), value, context.tr('ok'));
                                }
                              });
                            });
                          },
                        ),
                      ],
                    ),
                    subtitle: Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      alignment: WrapAlignment.center,
                      runAlignment: WrapAlignment.center,
                      children: [
                        "${context.tr('dashboard_tabName')}: ${permList[0]}",
                        "${context.tr('customer_tabName')}: ${permList[1]}",
                        "${context.tr('product_tabName')}: ${permList[2]}",
                        "${context.tr('leadsAppointment_tabName')}: ${permList[3]}",
                        "${context.tr('payment_tabName')}: ${permList[4]}",
                        "${context.tr('setting')}: ${permList[5]}",
                      ].map((e) => Chip(label: text3(e))).toList(),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 1.h),
          ],
        )
      ],
    );
  }
}
