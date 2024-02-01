// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Answer extends Equatable {
  const Answer({
    required this.answer,
    this.isCorrect = false,
  });

  const Answer.empty() : this(answer: '');

  final String answer;
  final bool isCorrect;

  @override
  List<Object?> get props => [
        answer,
        isCorrect,
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'answer': answer,
      'isCorrect': isCorrect,
    };
  }

  factory Answer.fromMap(Map<String, dynamic> map) {
    return Answer(
      answer: map['answer'] as String,
      isCorrect: map['isCorrect'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Answer.fromJson(String source) =>
      Answer.fromMap(json.decode(source) as Map<String, dynamic>);

  Answer copyWith({
    String? answer,
    bool? isCorrect,
  }) {
    return Answer(
      answer: answer ?? this.answer,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }
}
