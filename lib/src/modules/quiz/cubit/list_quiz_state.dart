// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'list_quiz_cubit.dart';

class ListQuizState extends Equatable {
  const ListQuizState({
    this.quiz = const [],
    this.isLoading = false,
    this.errorMessage = '',
  });

  final List<Quiz> quiz;
  final bool isLoading;
  final String errorMessage;

  @override
  List<Object> get props => [
        quiz,
        isLoading,
        errorMessage,
      ];

  ListQuizState copyWith({
    List<Quiz>? quiz,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ListQuizState(
      quiz: quiz ?? this.quiz,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
