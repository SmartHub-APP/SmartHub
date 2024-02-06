import 'permission.dart';

/// **login result codes**
/// ```
/// 0 : failed to login
/// 1 : login successful
/// 2 : internet unreachable
/// ```
class LoginResponse {
  String userName;
  String tokenAccess;
  String tokenRefresh;
  String permission;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        userName: json["Username"],
        permission: json["Permission"],
        tokenAccess: json["AccessToken"],
        tokenRefresh: json["RefreshToken"],
      );

  TabPermission getPerm() {
    return TabPermission(
      setting: int.parse(permission[0]),
      dashboard: int.parse(permission[1]),
      customer: int.parse(permission[2]),
      product: int.parse(permission[3]),
      leadsAppointment: int.parse(permission[4]),
      payment: int.parse(permission[5]),
    );
  }

  LoginResponse({
    required this.userName,
    required this.tokenAccess,
    required this.tokenRefresh,
    required this.permission,
  });
}
