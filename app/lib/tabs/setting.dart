import '../config.dart';
import '../interaction.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

settingDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(builder: (context, setSettingState) {
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
                    title: text3(context.tr('settingUserCreate'), isBold: true),
                    children: [
                      SizedBox(height: 2.h),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          width: 150,
                          height: 45,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey),
                            borderRadius: uiStyle.roundCorner2,
                          ),
                          child: text3(context.tr("settingUserCreate")),
                        ),
                      ),
                      SizedBox(height: 1.h),
                      //ListView(),
                      SizedBox(height: 2.h),
                    ],
                  ),
                  ExpansionTile(
                    title: text3(context.tr('settingRoleSetting'), isBold: true),
                    children: [
                      SizedBox(height: 2.h),
                      SizedBox(height: 2.h),
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
}
