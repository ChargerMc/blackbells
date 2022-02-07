import 'package:blackbells/models/benefits_model.dart';

class Establishment {
  Establishment({
    required this.owner,
    required this.name,
    this.desc,
    this.img,
    this.link,
    required this.benefits,
    this.address,
    this.gmaplink,
    required this.logo,
    required this.uid,
  });

  final _UserOwner owner;
  final String name;
  final String? desc;
  final String? img;
  final String? link;
  final String? address;
  final String? gmaplink;
  final String logo;
  final List<Benefit> benefits;
  final String uid;

  Establishment copyWith({
    _UserOwner? user,
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
        logo: logo,
        benefits: benefits ?? this.benefits,
        gmaplink: gmaplink ?? this.gmaplink,
        uid: uid ?? this.uid,
      );

  factory Establishment.fromJson(Map<String, dynamic> json) => Establishment(
        owner: _UserOwner.fromJson(json["owner"]),
        address: json["address"],
        benefits: List<Benefit>.from(
            (json['benefits'] as List).map((e) => Benefit.fromJson(e))),
        gmaplink: json["gmaplink"],
        logo: json["logo"],
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
        "logo": logo,
        "desc": desc,
        "img": img,
        "link": link,
        "benefits": List<Benefit>.from(benefits.map((x) => x)),
        "uid": uid,
      };
}

class _UserOwner {
  _UserOwner({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  _UserOwner copyWith({
    String? id,
    String? name,
  }) =>
      _UserOwner(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory _UserOwner.fromJson(Map<String, dynamic> json) => _UserOwner(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}
