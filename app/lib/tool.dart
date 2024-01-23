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

Person randomPerson() {
  Random seed = Random();
  bool withBank = seed.nextBool();
  return Person(
    name: randomString(5),
    role: ini.preRoles.last,
    account: randomString(10),
    phone: seed.nextBool() ? randomString(10) : null,
    bankCode: withBank ? (seed.nextInt(900) + 100).toString() : null,
    bankAccount: withBank ? randomString(10) : null,
  );
}
