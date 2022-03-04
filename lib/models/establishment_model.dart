import 'package:blackbells/models/user_model.dart';

class Establishment {
  Establishment({
    required this.owner,
    required this.name,
    required this.desc,
    required this.link,
    required this.address,
    required this.gmaplink,
    required this.img,
    required this.uid,
  });

  final UserResumed owner;
  final String name;
  final String desc;
  final String link;
  final String address;
  final String gmaplink;
  final String img;
  final String uid;

  Establishment copyWith({
    UserResumed? user,
    String? name,
    String? desc,
    String? img,
    String? link,
    String? address,
    String? gmaplink,
    DateTime? start,
    DateTime? end,
    String? uid,
  }) =>
      Establishment(
        owner: owner,
        name: name ?? this.name,
        desc: desc ?? this.desc,
        img: img ?? this.img,
        link: link ?? this.link,
        address: address ?? this.address,
        gmaplink: gmaplink ?? this.gmaplink,
        uid: uid ?? this.uid,
      );

  factory Establishment.fromJson(Map<String, dynamic> json) => Establishment(
        owner: UserResumed.fromJson(json["owner"]),
        address: json["address"],
        gmaplink: json["gmaplink"],
        name: json["name"],
        desc: json["desc"],
        img: json["img"],
        link: json["link"],
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "address": address,
        "gmaplink": gmaplink,
        "owner": owner.toJson(),
        "name": name,
        "desc": desc,
        "img": img,
        "link": link,
        "uid": uid,
      };
}
