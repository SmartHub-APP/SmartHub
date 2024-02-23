import 'tabs/payment.dart';
import 'tabs/product.dart';
import 'tabs/customer.dart';
import 'tabs/dashboard.dart';
import 'tabs/leads_appointment.dart';
import 'object/ui.dart';
import 'object/basic.dart';
import 'object/permission.dart';
import 'package:flutter/material.dart';

InitSetting ini = InitSetting(
  api: Api(
    role: "/smarthub/role",
    login: "/smarthub/login",
    member: "/smarthub/member",
    statistic: "/smarthub/statistic",
    transaction: "/smarthub/transaction",
    appointment: "/smarthub/appointment",
  ),
  apiBase: "",
  apiServer: "",
  appointmentLeadStatus: ["None", "Upcoming", "Completed", "Canceled"],
  commissionStatus: ["None", "Claimed", "Unclaimed"],
  cacheName: CacheName(
    name: "name",
    account: "account",
    tokenAccess: "tokenAccess",
    tokenRefresh: "tokenRefresh",
  ),
  dayOfMonth: 31,
  languages: [
    Lang(langName: "English", ref: const Locale('en', 'US')),
    Lang(langName: "中文", ref: const Locale('zh', 'TW')),
  ],
  maxPerm: 6,
  permModes: List.generate(4, (index) => index),
  separator: ";",
  timeEnd: DateTime.now(),
  timeStart: DateTime(2000),
  transactionStatus: [
    "None",
    "Completed",
    "Pending Document",
    "Pending Loan",
    "Cancelled",
    "Pending Singing",
  ],
  urls: [
    Url(route: "/dashboard", content: const Dashboard()),
    Url(route: "/customer", content: const Customer()),
    Url(route: "/product", content: const Product()),
    Url(route: "/leadsAppointment", content: const LeadsAppointment()),
    Url(route: "/payment", content: const Payment()),
  ],
);

SystemControl manager = SystemControl(
  systemName: "SmartHub",
  user: User(name: "", account: ""),
  icon: const Icon(Icons.home),
  tabPermission: TabPermission(
    dashboard: 0,
    customer: 0,
    product: 0,
    leadsAppointment: 0,
    payment: 0,
    setting: 0,
  ),
);
