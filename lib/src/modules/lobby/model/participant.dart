// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:whizz/src/modules/auth/models/user.dart';

class Participant {
  const Participant({
    required this.participant,
     this.score,
  });

  final AppUser participant;
  final int? score;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'participant': participant.toMap(),
      'score': score,
    };
  }

  factory Participant.fromMap(Map<String, dynamic> map) {
    return Participant(
      participant: AppUser.fromMap(map['participant'] as Map<String,dynamic>),
      score: map['score'] != null ? map['score'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Participant.fromJson(String source) =>
      Participant.fromMap(json.decode(source) as Map<String, dynamic>);

  Participant copyWith({
    AppUser? participant,
    int? score,
  }) {
    return Participant(
      participant: participant ?? this.participant,
      score: score ?? this.score,
    );
  }
}
