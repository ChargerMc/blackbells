import 'package:blackbells/models/establishment_model.dart';
import 'package:blackbells/models/user_model.dart';

class Event {
  Event({
    required this.user,
    required this.name,
    required this.desc,
    this.img,
    this.link,
    required this.start,
    this.end,
    required this.sponsors,
    required this.uid,
    required this.enrolled,
  });

  final UserResumed user;
  final String name;
  final String desc;
  final String? img;
  final String? link;
  final DateTime start;
  final DateTime? end;
  final List<Establishment> sponsors;
  final String uid;
  final List<UserResumed> enrolled;

  Event copyWith({
    UserResumed? user,
    String? name,
    String? desc,
    String? img,
    String? link,
    DateTime? start,
    DateTime? end,
    List<Establishment>? sponsors,
    List<UserResumed>? enrrolled,
    String? uid,
  }) =>
      Event(
        user: user ?? this.user,
        name: name ?? this.name,
        desc: desc ?? this.desc,
        img: img ?? this.img,
        link: link ?? this.link,
        start: start ?? this.start,
        end: end ?? this.end,
        sponsors: sponsors ?? this.sponsors,
        enrolled: enrolled,
        uid: uid ?? this.uid,
      );

  factory Event.fromJson(Map<String, dynamic> json) => Event(
      user: UserResumed.fromJson(json["user"]),
      name: json["name"],
      desc: json["desc"],
      img: json["img"],
      link: json["link"],
      start: DateTime.parse(json["start"].toString()),
      end: DateTime.tryParse(json["end"].toString()),
      sponsors: List<Establishment>.from(
          json["sponsors"].map((x) => Establishment.fromJson(x))),
      uid: json["uid"],
      enrolled: List<UserResumed>.from(
          json["enrolled"].map((x) => UserResumed.fromJson(x))));

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "desc": desc,
      "img": img,
      "link": link,
      "start": start.toIso8601String(),
      "end": end?.toIso8601String(),
      "sponsors": List<Establishment>.from(sponsors.map((x) => x)),
      "enrolled": List<UserResumed>.from(enrolled.map((x) => x)),
    };
  }
}
