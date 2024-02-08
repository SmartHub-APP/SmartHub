import 'interaction.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

int maxPage = 7;

Widget roleInfo(String perm, BuildContext context) {
  List<String> permList = List.filled(maxPage, "0");

  for (var i = 0; i < maxPage; i++) {
    if (perm.length > i) {
      permList[i] = perm[i];
    }
  }

  return Wrap(
    spacing: 5,
    runSpacing: 5,
    children: [
      Chip(label: text3("${context.tr('dashboard_tabName')}: ${permList[0]}")),
      Chip(label: text3("${context.tr('customer_tabName')}: ${permList[1]}")),
      Chip(label: text3("${context.tr('product_tabName')}: ${permList[2]}")),
      Chip(label: text3("${context.tr('leadsAppointment_tabName')}: ${permList[3]}")),
      Chip(label: text3("${context.tr('payment_tabName')}: ${permList[4]}")),
      Chip(label: text3("${context.tr('setting')}: ${permList[5]}")),
    ],
  );
}
