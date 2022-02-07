import 'package:blackbells/models/establishment_model.dart';

class Event {
  Event({
    required this.user,
    required this.name,
    required this.desc,
    this.img,
    this.link,
    this.start,
    this.end,
    this.sponsors,
    required this.uid,
  });

  final _UserEvent user;
  final String name;
  final String desc;
  final String? img;
  final String? link;
  final DateTime? start;
  final DateTime? end;
  final List<Establishment>? sponsors;
  final String uid;

  Event copyWith({
    _UserEvent? user,
    String? name,
    String? desc,
    String? img,
    String? link,
    DateTime? start,
    DateTime? end,
    List<Establishment>? sponsors,
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
        uid: uid ?? this.uid,
      );

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        user: _UserEvent.fromJson(json["user"]),
        name: json["name"],
        desc: json["desc"],
        img: json["img"],
        link: json["link"],
        start: DateTime.tryParse(json["start"].toString()),
        end: DateTime.tryParse(json["end"].toString()),
        sponsors: List<Establishment>.from(json["sponsors"].map((x) => x)),
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "name": name,
        "desc": desc,
        "img": img,
        "link": link,
        "start": start?.toIso8601String(),
        "end": end?.toIso8601String(),
        "sponsors": List<Establishment>.from(
            sponsors != null ? sponsors!.map((x) => x) : []),
        "uid": uid,
      };
}

class _UserEvent {
  _UserEvent({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  _UserEvent copyWith({
    String? id,
    String? name,
  }) =>
      _UserEvent(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory _UserEvent.fromJson(Map<String, dynamic> json) => _UserEvent(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}
