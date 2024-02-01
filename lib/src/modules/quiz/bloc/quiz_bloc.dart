import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:whizz/src/common/extensions/extension.dart';
import 'package:whizz/src/modules/quiz/model/answer.dart';
import 'package:whizz/src/modules/quiz/model/media.dart';
import 'package:whizz/src/modules/quiz/model/question.dart';
import 'package:whizz/src/modules/quiz/model/quiz.dart';
import 'package:whizz/src/modules/quiz/repository/quiz_repository.dart';

import 'package:whizz/src/router/app_router.dart';

part 'quiz_state.dart';
part 'quiz_event.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc({QuizRepository? quizRepository})
      : _quizRepository = quizRepository ?? QuizRepository(),
        super(const QuizState()) {
    on(_onQuizTitleChanged);
    on(_onQuizDescriptionChanged);
    on(_onQuizVisibilityChanged);
    on(_onQuizCollectionChanged);
    on(_onQuizMediaChanged);
    on(_onCreateNewQuestion);
    on(_onQuestionMediaChanged);
    on(_onQuestionNameChanged);
    on(_onSelectedQuestionChanged);
    on(_onQuestionDurationChanged);
    on(_onQuestionAnwserChanged);
    on(_onQuestionAnswerStatusChanged);
    on(_onQuestionRemoveCurrent);
    on(_onCreateQuiz);
    on(_onGoToEditScreen);
    on(_onRemoveQuiz);
  }

  final QuizRepository _quizRepository;

  void _onQuizTitleChanged(
    OnQuizTitleChanged event,
    Emitter<QuizState> emit,
  ) {
    final title = event.title;
    emit(
      state.copyWith(
        quiz: state.quiz.copyWith(
          title: title,
        ),
        isValid: title.isNotEmpty && state.quiz.questions.isNotEmpty,
      ),
    );
  }

  void _onQuizDescriptionChanged(
    OnQuizDescriptionChange event,
    Emitter<QuizState> emit,
  ) {
    final description = event.description;
    emit(
      state.copyWith(
        quiz: state.quiz.copyWith(
          description: description,
        ),
      ),
    );
  }

  void _onQuizVisibilityChanged(
    OnQuizVisibilityChanged event,
    Emitter<QuizState> emit,
  ) {
    final visibility = event.visibility == 'private'
        ? QuizVisibility.private
        : QuizVisibility.public;
    emit(
      state.copyWith(
        quiz: state.quiz.copyWith(
          visibility: visibility,
        ),
      ),
    );
  }

  void _onQuizCollectionChanged(
    OnQuizCollectionChanged event,
    Emitter<QuizState> emit,
  ) {
    emit(state.copyWith(
      quiz: state.quiz.copyWith(
        collectionId: event.collectionId,
      ),
    ));
  }

  void _onQuizMediaChanged(
    OnQuizMediaChanged event,
    Emitter<QuizState> emit,
  ) async {
    final context = event.context;
    final result = await context.pushNamed<Media>(RouterPath.media.name);
    if (result?.imageUrl != null) {
      emit(
        state.copyWith(
          quiz: state.quiz.copyWith(
            media: result,
          ),
        ),
      );
    }
  }

  void _onCreateQuiz(
    OnInitialNewQuiz event,
    Emitter<QuizState> emit,
  ) async {
    final l10n = AppLocalizations.of(event.context)!;
    emit(state.copyWith(isLoading: true));
    final quiz = state.quiz;
    try {
      await _quizRepository.createNewQuiz(quiz);
      emit(state.copyWith(isLoading: false));

      // ignore: use_build_context_synchronously
      event.context.showSuccessDialog(title: l10n.quiz_save_action);
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onCreateNewQuestion(
    OnCreateNewQuestion event,
    Emitter<QuizState> emit,
  ) {
    final context = event.context;
    if (event.isInQuizScreen) {
      if (state.quiz.questions.isEmpty) {
        _onCreate(emit);
      }
      context.pushNamed(
        RouterPath.question.name,
        extra: context.read<QuizBloc>(),
      );
    } else {
      _onCreate(emit);
    }
  }

  void _onCreate(Emitter<QuizState> emit) {
    final question = Question(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      answers: List.generate(4, (_) => const Answer.empty()),
    );
    final questions = List<Question>.from(state.quiz.questions)..add(question);
    emit(
      state.copyWith(
        quiz: state.quiz.copyWith(
          questions: questions,
        ),
        index: state.quiz.questions.length,
        isValid: state.quiz.title.isNotEmpty && questions.isNotEmpty,
      ),
    );
  }

  void _onSelectedQuestionChanged(
    OnQuestionSelectedChanged event,
    Emitter<QuizState> emit,
  ) {
    emit(state.copyWith(index: event.index));
  }

  void _onQuestionMediaChanged(
    OnQuestionMediaChanged event,
    Emitter<QuizState> emit,
  ) async {
    final context = event.context;
    final result = await context.pushNamed<Media>(RouterPath.media.name);
    if (result?.imageUrl != null) {
      final updatedList = List<Question>.from(state.quiz.questions);
      updatedList[state.index] = updatedList[state.index].copyWith(
        media: result,
      );

      emit(
        state.copyWith(
          quiz: state.quiz.copyWith(
            questions: updatedList,
          ),
        ),
      );
    }
  }

  void _onQuestionNameChanged(
    OnQuestionNameChanged event,
    Emitter<QuizState> emit,
  ) {
    final name = event.name;
    final updatedList = List<Question>.from(state.quiz.questions);

    updatedList[state.index] = updatedList[state.index].copyWith(
      name: name,
    );

    emit(
      state.copyWith(
        quiz: state.quiz.copyWith(
          questions: updatedList,
        ),
      ),
    );
  }

  void _onQuestionDurationChanged(
    OnQuestionDurationChanged event,
    Emitter<QuizState> emit,
  ) {
    final duration = event.duration;
    final updatedList = List<Question>.from(state.quiz.questions);

    updatedList[state.index] = updatedList[state.index].copyWith(
      duration: duration,
    );

    emit(
      state.copyWith(
        quiz: state.quiz.copyWith(
          questions: updatedList,
        ),
      ),
    );
  }

  void _onQuestionAnwserChanged(
    OnQuestionAnswerChanged event,
    Emitter<QuizState> emit,
  ) {
    final index = event.index;
    final answer = event.answer;

    final updateListQuestion = List<Question>.from(state.quiz.questions);

    final updateListAnswer =
        List<Answer>.from(updateListQuestion[state.index].answers);

    updateListAnswer[index] = updateListAnswer[index].copyWith(
      answer: answer,
    );

    updateListQuestion[state.index] = updateListQuestion[state.index].copyWith(
      answers: updateListAnswer,
    );

    emit(
      state.copyWith(
        quiz: state.quiz.copyWith(questions: updateListQuestion),
      ),
    );
  }

  void _onQuestionAnswerStatusChanged(
    OnQuestionAnswerStatusChanged event,
    Emitter<QuizState> emit,
  ) {
    final index = event.index;

    final updateListQuestion = List<Question>.from(state.quiz.questions);

    final updateListAnswer =
        List<Answer>.from(updateListQuestion[state.index].answers);

    updateListAnswer[index] = updateListAnswer[index].copyWith(
      isCorrect: !updateListAnswer[index].isCorrect,
    );

    updateListQuestion[state.index] = updateListQuestion[state.index].copyWith(
      answers: updateListAnswer,
    );

    emit(
      state.copyWith(
        quiz: state.quiz.copyWith(questions: updateListQuestion),
      ),
    );
  }

  void _onQuestionRemoveCurrent(
    OnRemoveCurrentQuestion event,
    Emitter<QuizState> emit,
  ) {
    emit(
      state.copyWith(
        quiz: state.quiz.copyWith(
          questions: List.from(state.quiz.questions)..removeAt(state.index),
        ),
        index: 0,
      ),
    );
    if (state.quiz.questions.isEmpty) _onCreate(emit);
  }

  void _onGoToEditScreen(
    OnGoToEditScreen event,
    Emitter<QuizState> emit,
  ) {
    emit(
      state.copyWith(
        quiz: event.quiz,
        isValid: event.quiz.title.isNotEmpty,
      ),
    );
  }

  void _onRemoveQuiz(
    OnRemoveQuiz event,
    Emitter<QuizState> emit,
  ) {
    final quiz = event.quiz;
    final context = event.context;

    final l10n = AppLocalizations.of(context)!;

    context.showConfirmDialog(
      title: l10n.delete_title,
      description: l10n.delete_subtitle,
      onNegativeButton: () {},
      onPositiveButton: () async {
        await _quizRepository.removeQuiz(quiz).then((_) {
          context.pop();
        });
      },
    );
  }
}
