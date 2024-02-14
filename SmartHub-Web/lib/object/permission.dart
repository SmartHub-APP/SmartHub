class User {
  String name;
  String account;

  User({
    required this.name,
    required this.account,
  });
}

/// 1. setting
/// ```
/// 0 : hide
/// 1 : basic
/// 2 : admin
/// 3 : boss
/// ```
/// 2. dashboard
/// ```
/// 0 : hide
/// 1 : basic
/// 2 : admin
/// 3 : boss
/// ```
/// 3. customer
/// ```
/// 0 : hide
/// 1 : basic
/// 2 : admin
/// 3 : boss
/// ```
/// 4. product
/// ```
/// 0 : hide
/// 1 : basic
/// 2 : admin
/// 3 : boss
/// ```
/// 5. leadsAppointment
/// ```
/// 0 : hide
/// 1 : basic
/// 2 : admin
/// 3 : boss
/// ```
/// 6. payment
/// ```
/// 0 : hide
/// 1 : basic
/// 2 : admin
/// 3 : boss
/// ```
class TabPermission {
  int setting;
  int dashboard;
  int customer;
  int product;
  int leadsAppointment;
  int payment;

  TabPermission({
    required this.setting,
    required this.dashboard,
    required this.customer,
    required this.product,
    required this.leadsAppointment,
    required this.payment,
  });
}
