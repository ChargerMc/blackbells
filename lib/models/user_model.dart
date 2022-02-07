import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

class User {
  User({
    required this.enabled,
    required this.online,
    required this.phonenumber,
    this.name,
    required this.email,
    required this.bloodtype,
    required this.gender,
    required this.role,
    required this.uid,
  });

  final String? name;
  final String email;
  final String? bloodtype;
  final String gender;
  final String role;
  bool enabled;
  final bool online;
  final String phonenumber;
  final String uid;

  static User copyWith({
    String? name,
    String? email,
    String? bloodtype,
    String? gender,
    String? role,
    bool? enabled,
    bool? online,
    String? phonenumber,
    String? uid,
  }) =>
      User(
        name: name ?? '',
        email: email ?? '',
        bloodtype: bloodtype ?? '',
        gender: gender ?? '',
        role: role ?? '',
        uid: uid ?? '',
        enabled: enabled ?? false,
        online: enabled ?? false,
        phonenumber: phonenumber ?? '',
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"],
        email: json["email"],
        bloodtype: json["bloodtype"],
        gender: json["gender"],
        role: json["role"],
        uid: json["uid"],
        enabled: json["enabled"],
        online: json["online"],
        phonenumber: json["phonenumber"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "bloodtype": bloodtype,
        "gender": gender,
        "role": role,
        "enabled": enabled,
        "phonenumber": phonenumber,
      };
}
