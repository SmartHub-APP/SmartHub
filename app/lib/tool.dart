import 'dart:math';
import 'config.dart';
import 'object.dart';

File randomPic() {
  var seed = Random();
  double w = (seed.nextInt(5) + 2) * 100;
  double h = (seed.nextInt(5) + 2) * 100;
  return File(fileName: randomString(10), fileHash: "https://picsum.photos/$w/$h?random=${seed.nextInt(20) + 5}");
}

String randomString(int len) {
  Random seed = Random();
  return String.fromCharCodes(List.generate(len, (index) => seed.nextInt(33) + 89));
}

Member randomPerson() {
  Random seed = Random();
  bool withBank = seed.nextBool();
  return Member(
    id: -1,
    status: 1,
    name: randomString(5),
    role: RoleDefault.guest.toRole(),
    account: randomString(10),
    phone: seed.nextBool() ? randomString(10) : null,
    bankCode: withBank ? (seed.nextInt(900) + 100).toString() : null,
    bankAccount: withBank ? randomString(10) : null,
  );
}
