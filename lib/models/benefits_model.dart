import 'package:blackbells/models/establishment_model.dart';

class Benefit {
  Benefit({
    required this.name,
    required this.desc,
    required this.img,
    required this.link,
    required this.uid,
  });

  final String name;
  final String desc;
  final String img;
  final String link;
  final String uid;

  Benefit copyWith({
    Establishment? establishment,
    String? name,
    String? desc,
    String? img,
    String? link,
    String? uid,
  }) =>
      Benefit(
        name: name ?? this.name,
        desc: desc ?? this.desc,
        img: img ?? this.img,
        link: link ?? this.link,
        uid: uid ?? this.uid,
      );

  factory Benefit.fromJson(Map<String, dynamic> json) => Benefit(
        name: json["name"],
        desc: json["desc"],
        img: json["img"],
        link: json["link"],
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "desc": desc,
        "img": img,
        "link": link,
        "uid": uid,
      };
}
