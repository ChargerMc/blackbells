import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

class User {
  User({
    required this.img,
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
  final String img;

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
    String? img,
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
        img: img ?? '',
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
        img: json["img"],
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
        "img": img,
      };
}

class UserResumed {
  UserResumed({
    required this.id,
    this.name,
    required this.img,
  });

  final String id;
  final String? name;
  final String img;

  UserResumed copyWith({
    String? id,
    String? name,
    String? img,
  }) =>
      UserResumed(
        id: id ?? this.id,
        name: name ?? this.name,
        img: img ?? this.img,
      );

  factory UserResumed.fromJson(Map<String, dynamic> json) => UserResumed(
        id: json["_id"],
        name: json["name"],
        img: json["img"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "img": img,
      };
}
