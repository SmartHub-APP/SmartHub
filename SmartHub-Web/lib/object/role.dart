class Role {
  int id;
  String name;
  int permission;

  Role({required this.id, required this.name, required this.permission});

  Map<String, dynamic> toJson() => {
        "ID": id,
        "Name": name,
        "Permission": permission,
      };

  factory Role.guest() {
    return Role(
      id: 0,
      name: "Guest",
      permission: 0,
    );
  }

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json["ID"] ?? 0,
      name: json["Name"] ?? "Guest",
      permission: json["Permission"] ?? 0,
    );
  }
}

class RolePostRequest {
  String name;
  int permission;

  RolePostRequest({required this.name, required this.permission});

  Map<String, dynamic> toJson() => {
        "Name": name,
        "Perm": permission,
      };
}
