// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:whizz/src/modules/auth/models/user.dart';
import 'package:whizz/src/modules/lobby/model/participant.dart';
import 'package:whizz/src/modules/quiz/model/quiz.dart';

class Lobby {
  const Lobby({
    this.id = '',
    this.participants = const [],
    this.quiz = const Quiz(),
    this.host = AppUser.empty,
    this.top5 = const [],
    this.solo = const [],
    this.code,
    this.isStart = false,
    this.startTime,
    this.isSolo = true,
    this.isHost = true,
    this.isCancelled = false,
  });

  final String id;
  final List<Participant> participants;
  final Quiz quiz;
  final AppUser host;
  final List<Participant> top5;
  final List<Lobby> solo;
  final String? code;
  final bool isStart;
  final DateTime? startTime;
  final bool isSolo;
  final bool isHost;
  final bool isCancelled;

  Lobby copyWith({
    String? id,
    List<Participant>? participants,
    Quiz? quiz,
    AppUser? host,
    List<Participant>? top5,
    List<Lobby>? solo,
    String? code,
    bool? isStart,
    DateTime? startTime,
    bool? isSolo,
    bool? isHost,
    bool? isCancelled,
  }) {
    return Lobby(
      id: id ?? this.id,
      participants: participants ?? this.participants,
      quiz: quiz ?? this.quiz,
      host: host ?? this.host,
      top5: top5 ?? this.top5,
      solo: solo ?? this.solo,
      code: code ?? this.code,
      isStart: isStart ?? this.isStart,
      startTime: startTime ?? this.startTime,
      isSolo: isSolo ?? this.isSolo,
      isHost: isHost ?? this.isHost,
      isCancelled: isCancelled ?? this.isCancelled,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      // 'participants': participants.map((x) => x.toMap()).toList(),
      'quiz': quiz.toMap(),
      'host': host.toMap(),
      'code': code,
      'isStart': isStart,
      'startTime': startTime?.millisecondsSinceEpoch,
      'isSolo': isSolo,
      'isCancelled': isCancelled,
    };
  }

  Map<String, dynamic> toInfomation() {
    return <String, dynamic>{
      'id': id,
      'quiz': quiz.toMap(),
      'host': host.toMap(),
      'code': code,
      'isStart': isStart,
      'startTime': startTime?.millisecondsSinceEpoch,
      'isSolo': isSolo,
      'isCancelled': isCancelled,
    };
  }

  factory Lobby.fromMap(Map<String, dynamic> map) {
    return Lobby(
      id: map['id'] as String,
      // participants: List<Participant>.from(
      //   (map['participants'] as List<dynamic>).map<Participant>(
      //     (x) => Participant.fromMap(x as Map<String, dynamic>),
      //   ),
      // ),
      quiz: Quiz.fromMap(map['quiz'] as Map<String, dynamic>),
      host: AppUser.fromMap(map['host'] as Map<String, dynamic>),
      code: map['code'] != null ? map['code'] as String : null,
      isStart: map['isStart'] as bool,
      startTime: map['startTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['startTime'] as int)
          : null,
      isSolo: map['isSolo'] as bool,
      isCancelled: map['isCancelled'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Lobby.fromJson(String source) =>
      Lobby.fromMap(json.decode(source) as Map<String, dynamic>);
}
