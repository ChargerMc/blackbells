import 'package:blackbells/models/benefits_model.dart';
import 'package:blackbells/models/user_model.dart';

class Establishment {
  Establishment({
    required this.owner,
    required this.name,
    this.desc,
    this.link,
    required this.benefits,
    this.address,
    this.gmaplink,
    required this.img,
    required this.uid,
  });

  final UserResumed owner;
  final String name;
  final String? desc;
  final String? link;
  final String? address;
  final String? gmaplink;
  final String img;
  final List<Benefit> benefits;
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
    List<Benefit>? benefits,
    String? uid,
  }) =>
      Establishment(
        owner: owner,
        name: name ?? this.name,
        desc: desc ?? this.desc,
        img: img ?? this.img,
        link: link ?? this.link,
        address: address ?? this.address,
        benefits: benefits ?? this.benefits,
        gmaplink: gmaplink ?? this.gmaplink,
        uid: uid ?? this.uid,
      );

  factory Establishment.fromJson(Map<String, dynamic> json) => Establishment(
        owner: UserResumed.fromJson(json["owner"]),
        address: json["address"],
        benefits: List<Benefit>.from(
            (json['benefits'] as List).map((e) => Benefit.fromJson(e))),
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
        "benefits": List<Benefit>.from(benefits.map((x) => x)),
        "uid": uid,
      };
}
