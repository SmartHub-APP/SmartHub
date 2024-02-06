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

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json["ID"] ?? 0,
      name: json["Name"] ?? "Guest",
      permission: json["Permission"] ?? 0,
    );
  }
}
