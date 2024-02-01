import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whizz/src/modules/quiz/model/quiz.dart';
import 'package:whizz/src/modules/quiz/repository/quiz_repository.dart';

part 'list_quiz_state.dart';

class ListQuizCubit extends Cubit<ListQuizState> {
  ListQuizCubit({QuizRepository? repository})
      : _repository = repository ?? QuizRepository(),
        super(const ListQuizState()) {
    getListQuiz();
  }

  final QuizRepository _repository;

  void getListQuiz() {
    emit(state.copyWith(isLoading: true));
    _repository.fetchListQuizzes().listen((event) {
      emit(state.copyWith(
        quiz: event,
        isLoading: false,
      ));
    });
  }
}
