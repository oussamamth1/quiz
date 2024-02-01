// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'play_cubit.dart';

class GameState extends Equatable {
  const GameState({
    this.answers = const [],
    this.currentQuestion = 0,
    this.remainTime = -1,
    this.score = 0,
  });

  final List<int?> answers;
  final int currentQuestion;
  final int remainTime;
  final int score;

  GameState copyWith({
    List<int?>? answers,
    int? currentQuestion,
    int? remainTime,
    int? score,
  }) {
    return GameState(
      answers: answers ?? this.answers,
      currentQuestion: currentQuestion ?? this.currentQuestion,
      remainTime: remainTime ?? this.remainTime,
      score: score ?? this.score,
    );
  }

  @override
  List<Object?> get props => [
        answers,
        currentQuestion,
        remainTime,
        score,
      ];
}
