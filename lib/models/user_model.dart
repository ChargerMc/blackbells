import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

class User {
  User({
    required this.img,
    required this.enabled,
    required this.online,
    required this.phonenumber,
    required this.name,
    required this.email,
    required this.bloodtype,
    required this.gender,
    required this.role,
    required this.uid,
    required this.cubiccapacity,
    required this.color,
    required this.birthday,
    required this.allergies,
    required this.motorcycle,
  });

  String name;
  String email;
  String bloodtype;
  String gender;
  final String role;
  bool enabled;
  final bool online;
  String phonenumber;
  final String uid;
  String img;
  String cubiccapacity;
  String allergies;
  DateTime birthday;
  String color;
  String motorcycle;

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
    String? cubiccapacity,
    String? allergies,
    String? color,
    String? motorcycle,
    DateTime? birthday,
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
        cubiccapacity: cubiccapacity ?? '',
        allergies: allergies ?? '',
        birthday: birthday ?? DateTime.now(),
        color: color ?? '',
        motorcycle: motorcycle ?? '',
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"] ?? '',
        email: json["email"],
        bloodtype: json["bloodtype"] ?? '',
        gender: json["gender"],
        role: json["role"],
        uid: json["uid"],
        enabled: json["enabled"],
        online: json["online"],
        img: json["img"],
        phonenumber: json["phonenumber"].toString(),
        allergies: json["allergies"],
        birthday: DateTime.parse(json["birthday"]),
        color: json["color"],
        cubiccapacity: json["cubiccapacity"],
        motorcycle: json["motorcycle"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "bloodtype": bloodtype,
        "gender": gender,
        "role": role,
        "id": uid,
        "enabled": enabled,
        "online": online,
        "img": img,
        "phonenumber": phonenumber,
        "allergies": allergies,
        "birthday": birthday.toIso8601String(),
        "color": color,
        "cubiccapacity": cubiccapacity,
        "motorcycle": motorcycle,
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
