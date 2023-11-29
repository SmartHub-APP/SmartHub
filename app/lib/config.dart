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
  isPaid: 0,
  profit: 0,
  price: 0,
  status: 0,
  id: "",
  name: "",
  category: "",
  position: "",
  description: '',
  agent: [],
  imgUrl: [],
  customer: [],
);

Appointment newAppointment = Appointment(
  onSelect: false,
  status: 0,
  lead: Person(name: "", role: ini.preRoles.last),
  agent: Person(name: "", role: ini.preRoles.last),
  appointDate: ini.timeStart,
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
  profitStatus: ["None", "Claimed", "Unclaimed"],
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
    String rngString5 = "$index-${randomString(5)}";
    String rngString15 = "$index-${randomString(15)}";
    return Transaction(
      id: rngString15,
      profit: seed.nextInt(30) + 1,
      isPaid: seed.nextInt(3),
      onSelect: false,
      price: seed.nextInt(100000) + 10000,
      status: seed.nextInt(5) + 1,
      name: "Name - $rngString5",
      category: "Category - $rngString5",
      position: "Position - $rngString15",
      description: "Description - $rngString15-$rngString15",
      agent: List.generate(3, (index) => randomPerson()),
      customer: List.generate(3, (index) => randomPerson()),
      appointment: randomPerson(),
      imgUrl: List.generate(3, (index) => randomPic()),
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
