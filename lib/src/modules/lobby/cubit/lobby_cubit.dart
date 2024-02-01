// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:whizz/src/common/extensions/extension.dart';
import 'package:whizz/src/modules/lobby/model/lobby.dart';
import 'package:whizz/src/modules/lobby/repository/lobby_repository.dart';
import 'package:whizz/src/modules/quiz/model/answer.dart';
import 'package:whizz/src/modules/quiz/model/question.dart';
import 'package:whizz/src/modules/quiz/model/quiz.dart';
import 'package:whizz/src/modules/quiz/repository/quiz_repository.dart';
import 'package:whizz/src/router/app_router.dart';

part 'lobby_state.dart';

class LobbyCubit extends Cubit<Lobby> {
  LobbyCubit({
    LobbyRepository? lobbyRepository,
    QuizRepository? quizRepository,
  })  : _lobbyRepository = lobbyRepository ?? LobbyRepository(),
        _quizRepository = quizRepository ?? QuizRepository(),
        super(const Lobby());

  final LobbyRepository _lobbyRepository;
  final QuizRepository _quizRepository;

  Future<void> createLobby(
    Quiz quiz, {
    bool isSoloMode = true,
  }) async {
    const uuid = Uuid();
    final id = uuid.v4();

    emit(state.copyWith(
      id: id,
      quiz: quiz,
    ));

    final lobby = await _lobbyRepository.createLobby(
      state,
      isSoloMode: isSoloMode,
    );

    _shuffleAnswer(lobby);

    _lobbyRepository.lobby(lobby).listen((event) {
      emit(event.copyWith(
        quiz: state.quiz,
      ));
    });

    _lobbyRepository.participants(lobby).listen((event) {
      emit(state.copyWith(
        quiz: state.quiz,
        participants: event,
      ));
    });
  }

  void startGame() async {
    await Future.wait([
      _quizRepository.updateNumOfPlayer(state.quiz),
      _lobbyRepository.startGame(state),
    ]);
  }

  void calculateScore(int score) async {
    _lobbyRepository.updateScore(state, score).then((_) => getScores());
    // getScores();
  }

  void getScores() {
    final participants = state.participants;
    participants.sort((a, b) => b.score! - a.score!);
    emit(state.copyWith(
      participants: participants,
    ));
  }

  int getRank() {
    return _lobbyRepository.getRank(state);
  }

  void enterRoom(BuildContext context, String code) {
    _lobbyRepository.enterLobby(code).then((result) {
      if (result == null) {
        context.showErrorSnackBar('Quiz not found');
      } else {
        _lobbyRepository.lobby(result).listen((event) {
          emit(event.copyWith(
            isHost: false,
          ));
        });

        _lobbyRepository.participants(result).listen((event) {
          emit(state.copyWith(
            participants: event,
          ));
        });
        context.pushNamed(
          RouterPath.lobby.name,
          extra: false,
        );
      }
    });
  }

  Future<void> soloHistory() async {
    var lobby = await _lobbyRepository.soloHistory(state);
    // for (var i = 0; i < lobby.length; i++) {
    //   List<Participant> participants = lobby[i].participants;
    //   participants.sort((a, b) => (b.score ?? 0) - (a.score ?? 0));

    // }
    lobby.sort((a, b) =>
        (b.participants[0].score ?? 0) - (a.participants[0].score ?? 0));
    // participant.sort((a, b) => (b.score ?? 0) - (a.score ?? 0));

    emit(state.copyWith(solo: lobby));
  }

  Future<void> rating(bool isClicked, double rating) async {
    if (isClicked) {
      await _quizRepository.rating(state.quiz, rating);
    }
  }

  Future<void> outRoom() async {
    if (state.isHost) {
      await _lobbyRepository.onCancelRoom(state);
      emit(state.copyWith(
        isCancelled: true,
      ));
    } else {
      await _lobbyRepository.onLeaveRoom(state);
    }
  }

  Stream<Lobby> streamData() {
    return _lobbyRepository.lobby(state);
  }

  _shuffleAnswer(Lobby lobby) {
    List<Question> questions = List<Question>.from(lobby.quiz.questions);

    for (int i = 0; i < questions.length; i++) {
      final shuffleAnswer = List<Answer>.from(questions[i].answers)..shuffle();
      questions[i] = questions[i].copyWith(
        answers: shuffleAnswer,
      );
    }

    emit(
      state.copyWith(
        quiz: lobby.quiz.copyWith(
          questions: questions,
        ),
      ),
    );
  }

  void cancel() {
    emit(const Lobby());
  }
}
