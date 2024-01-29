import 'package:sprintf/sprintf.dart';

import 'interaction.dart';
import '../object.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:easy_localization/easy_localization.dart';

Future<bool> makePayment(BuildContext context, List<Transaction> selects) async {
  bool isSuccess = false;
  List<Member> payTo = selects.map((e) => e.agent[0]).toList();
  if (payTo.length != 1) {
    alertDialog(context, context.tr('error'), context.tr('payment_error'), context.tr('ok'));
  } else {
    double total = selects.fold(0, (sum, e) => sum + e.commission * e.price);
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: uiStyle.roundCorner),
              backgroundColor: Colors.white,
              titlePadding: EdgeInsets.zero,
              title: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                ),
                child: text2(context.tr('payment_make')),
              ),
              content: SizedBox(
                width: 30.w,
                height: 30.h,
                child: text3(
                  sprintf(
                    context.tr('payment_summary'),
                    [payTo[0].name, payTo[0].role.name, total, payTo[0].bankCode, payTo[0].bankAccount],
                  ),
                ),
              ),
              actionsAlignment: MainAxisAlignment.center,
              actionsPadding: EdgeInsets.only(bottom: 3.h),
              actions: [
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
                    icon: const Icon(Icons.payments_rounded),
                    tooltip: context.tr('payment_done'),
                    onPressed: () {
                      isSuccess = true;
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
  }

  return isSuccess;
}
