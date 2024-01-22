import '../api.dart';
import '../config.dart';
import '../main.dart';
import '../component/interaction.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController inputAccount = TextEditingController(text: "");
  TextEditingController inputPassword = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return Scaffold(
          appBar: AppBar(
            leading: leadingIcon,
            leadingWidth: uiStyle.leadWidth,
            backgroundColor: Colors.cyan,
            actions: [
              Center(child: text3("${context.tr('settingLanguage')} : ", color: Colors.white)),
              DropdownButtonHideUnderline(
                child: DropdownButton(
                  value: context.locale,
                  dropdownColor: Colors.black54,
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 30,
                  onChanged: (Locale? newValue) {
                    context.setLocale(newValue!);
                  },
                  items: ini.languages.map((lang) {
                    return DropdownMenuItem(
                      value: lang.ref,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 1.w),
                        alignment: Alignment.center,
                        child: text3(lang.langName, color: Colors.white),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          body: Center(
            child: SizedBox(
              width: uiStyle.loginWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    controller: inputAccount,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: context.tr('login_account'),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  TextField(
                    obscureText: true,
                    controller: inputPassword,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: context.tr('login_password'),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    onPressed: () {
                      if (inputAccount.text.isNotEmpty && inputPassword.text.isNotEmpty) {
                        setState(() {
                          EasyLoading.show(status: "${context.tr('login_tabName')} ...");

                          try2Login(inputAccount.text, inputPassword.text).then((value) {
                            EasyLoading.dismiss();

                            if (value.isEmpty) {
                              router.navigateTo(context, ini.urls[0].route, transition: TransitionType.none);
                            } else {
                              alertDialog(context, context.tr('error'), value, context.tr('ok'));
                            }
                          });
                        });
                      } else {
                        alertDialog(
                          context,
                          context.tr('error'),
                          context.tr('error_null'),
                          context.tr('ok'),
                        );
                      }
                    },
                    child: Container(
                      width: 10.w,
                      height: 7.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(border: Border.all(), borderRadius: uiStyle.roundCorner),
                      child: text2(context.tr('login_tabName'), isBold: true),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
