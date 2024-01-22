import 'object.dart';
import 'tabs/payment.dart';
import 'tabs/product.dart';
import 'tabs/customer.dart';
import 'tabs/dashboard.dart';
import 'tabs/leads_appointment.dart';
import 'package:flutter/material.dart';

InitSetting ini = InitSetting(
  apiServer: "http://mothra.life.nctu.edu.tw:25000/",
  api: Api(login: "smarthub/login"),
  urls: [
    Url(route: "/dashboard", content: const Dashboard()),
    Url(route: "/customer", content: const Customer()),
    Url(route: "/product", content: const Product()),
    Url(route: "/leads-appointment", content: const LeadsAppointment()),
    Url(route: "/payment", content: const Payment()),
  ],
  timeStart: DateTime(2000, 1, 1),
  cacheName: CacheName(account: 'account', password: 'password', tokenAccess: 'tokenAccess', tokenRefresh: 'tokenRefresh'),
  transactionStatus: ["None", "Completed", "Pending Document", "Pending Loan", "Cancelled", "Pending Signing"],
  appointmentLeadStatus: ["None", "Upcoming", "Completed", "Canceled"],
  commissionStatus: ["None", "Claimed", "Unclaimed"],
  languages: [
    Lang(langName: "English(US)", ref: const Locale('en', 'US')),
    Lang(langName: "中文(繁體)", ref: const Locale('zh', 'TW')),
  ],
  preRoles: [
    Role(roleName: "Boss", permission: [0, 0, 0, 0, 0, 0]),
    Role(roleName: "Admin", permission: [1, 1, 1, 1, 1, 1]),
    Role(roleName: "User", permission: [2, 2, 2, 2, 2, 2]),
    Role(roleName: "Public", permission: [3, 3, 3, 3, 3, 3]),
  ],
);

SystemControl manager = SystemControl(
  systemName: 'SmartHub',
  user: User(account: '', name: ''),
  icon: const SizedBox(),
  tabPermission: TabPermission(setting: 0, dashboard: 0, customer: 0, product: 0, leadsAppointment: 0, payment: 0),
);
