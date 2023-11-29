import '../api.dart';
import '../config.dart';
import '../main.dart';
import '../interaction.dart';
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
              Row(
                  children: ini.languages.map((lang) {
                return InkWell(
                  onTap: () {
                    context.setLocale(lang.ref);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: uiStyle.roundCorner2,
                    ),
                    child: text3(lang.langName),
                  ),
                );
              }).toList()),
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
