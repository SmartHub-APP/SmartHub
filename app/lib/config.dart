import 'object.dart';
import 'dart:math';
import 'tabs/payment.dart';
import 'tabs/product.dart';
import 'tabs/customer.dart';
import 'tabs/dashboard.dart';
import 'tabs/leads_appointment.dart';
import 'package:flutter/material.dart';

Transaction newTransaction = Transaction(
  onSelect: false,
  payStatus: 0,
  commission: 0,
  price: 0,
  status: 2,
  projectName: "",
  id: "",
  unit: "",
  description: '',
  saleDate: DateTime.now(),
  agent: [],
  clients: [],
  documents: [],
  name: '',
);

Appointment newAppointment = Appointment(
  onSelect: false,
  status: 0,
  lead: Person(name: "", role: ini.preRoles.last),
  agent: Person(name: "", role: ini.preRoles.last),
  appointDate: ini.timeStart,
  projectName: '',
);

InitSetting ini = InitSetting(
  api: Api(
    login: "/smarthub/login",
  ),
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
  systemVersion: 'v0.0.9',
  apiServer: "http://mothra.life.nctu.edu.tw:25000",
  user: User(account: '', name: ''),
  icon: const SizedBox(),
  tabPermission: TabPermission(setting: 0, dashboard: 0, customer: 0, product: 0, leadsAppointment: 0, payment: 0),
);

List<Transaction> fakeTransactionGenerator(int amount) {
  Random seed = Random();
  return List.generate(amount, (index) {
    String rngString3 = "$index-${randomString(3)}";
    String rngString10 = "$index-${randomString(10)}";
    return Transaction(
      id: rngString10,
      commission: seed.nextInt(30) + 1,
      payStatus: seed.nextInt(3),
      onSelect: false,
      price: seed.nextInt(100000) + 10000,
      status: seed.nextInt(5) + 1,
      projectName: "ProjectName-$rngString3",
      name: "Name-$rngString3",
      unit: "Unit-$rngString3",
      description: "Description - $rngString10-$rngString10",
      appoint: randomPerson(),
      agent: List.generate(3, (index) => randomPerson()),
      clients: List.generate(3, (index) => randomPerson()),
      documents: List.generate(3, (index) => randomPic()),
      saleDate: DateTime(
        seed.nextInt(23) + 2000,
        seed.nextInt(12) + 1,
        seed.nextInt(25) + 1,
        seed.nextInt(12) + 1,
        seed.nextInt(60) + 1,
      ),
    );
  });
}

String randomPic() {
  var seed = Random();
  double w = (seed.nextInt(5) + 2) * 100;
  double h = (seed.nextInt(5) + 2) * 100;
  return "https://picsum.photos/$w/$h?random=${seed.nextInt(20) + 5}";
}

String randomString(int len) {
  Random seed = Random();
  return String.fromCharCodes(List.generate(len, (index) => seed.nextInt(33) + 89));
}

Person randomPerson() {
  Random seed = Random();
  bool withBank = seed.nextBool();
  return Person(
    name: randomString(5),
    role: ini.preRoles.last,
    phone: seed.nextBool() ? randomString(10) : null,
    email: seed.nextBool() ? randomString(10) : null,
    bankCode: withBank ? (seed.nextInt(900) + 100).toString() : null,
    bankAccount: withBank ? randomString(10) : null,
  );
}

List<Appointment> fakeAppointmentGenerator(int amount) {
  Random seed = Random();
  return List.generate(amount, (index) {
    return Appointment(
      onSelect: false,
      status: seed.nextInt(3) + 1,
      projectName: randomString(5),
      lead: randomPerson(),
      agent: randomPerson(),
      appointDate: DateTime(
        seed.nextInt(23) + 2000,
        seed.nextInt(12) + 1,
        seed.nextInt(25) + 1,
        seed.nextInt(12) + 1,
        seed.nextInt(60) + 1,
      ),
    );
  });
}
