// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'quiz_bloc.dart';

final class QuizState extends Equatable {
  const QuizState({
    this.quiz = const Quiz(),
    this.isLoading = false,
    this.isValid = false,
    this.index = 0,
  });

  final Quiz quiz;
  final bool isLoading;
  final bool isValid;
  final int index;

  @override
  List<Object?> get props => [
        quiz,
        isLoading,
        isValid,
        index,
      ];

  QuizState copyWith({
    Quiz? quiz,
    bool? isLoading,
    bool? isValid,
    int? index,
  }) {
    return QuizState(
      quiz: quiz ?? this.quiz,
      isLoading: isLoading ?? this.isLoading,
      isValid: isValid ?? this.isValid,
      index: index ?? this.index,
    );
  }
}
