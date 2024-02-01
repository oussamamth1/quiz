import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whizz/src/common/utils/cache.dart';
import 'package:whizz/src/modules/auth/models/user.dart';
import 'package:whizz/src/modules/auth/repository/auth_repository.dart';
import 'package:whizz/src/modules/collection/model/quiz_collection.dart';
import 'package:whizz/src/modules/collection/repository/quiz_collection_repository.dart';
import 'package:whizz/src/modules/quiz/model/quiz.dart';
import 'package:whizz/src/modules/quiz/repository/quiz_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    InMemoryCache? cache,
    QuizRepository? quizRepository,
    QuizCollectionRepository? collectionRepository,
    AuthenticationRepository? authenticationRepository,
  })  : _cache = cache ?? InMemoryCache(),
        _quizRepository = quizRepository ?? QuizRepository(),
        _collectionRepository =
            collectionRepository ?? QuizCollectionRepository(),
        _authenticationRepository =
            authenticationRepository ?? AuthenticationRepository(),
        super(const ProfileState()) {
    _onGetProfile();
  }

  final InMemoryCache _cache;
  final QuizRepository _quizRepository;
  final QuizCollectionRepository _collectionRepository;
  final AuthenticationRepository _authenticationRepository;

  void _onGetProfile() async {
    emit(state.copyWith(isLoading: true));
    final user = _cache.read<AppUser>(key: 'user');
    _collectionRepository.ownCollection().listen((collections) {
      emit(state.copyWith(
        collections: collections,
      ));
    });

    _quizRepository.fetchAllQuizzes2().listen(
      (quiz) {
        emit(
          state.copyWith(
            user: user,
            quizzies: quiz,
            isLoading: false,
          ),
        );
      },
    );
    _quizRepository.fetchBookmarks().listen((bm) async {
      final newData = <Quiz>[];
      for (final quiz in bm) {
        final data = await _quizRepository.getQuizById(quiz);
        newData.add(data);
      }

      emit(state.copyWith(
        save: newData,
        isLoading: false,
      ));
    });
  }

  Future<void> onEditProfile(String displayName, File? avatar) async {
    emit(state.copyWith(isLoading: true));
    await _authenticationRepository.updateUser(displayName, avatar);
    final user = _cache.read<AppUser>(key: 'user');
    emit(state.copyWith(
      isLoading: false,
      user: user,
    ));
  }

  Future<List<Quiz>> onGetQuizByCollection(String collectionId) async {
    return await _quizRepository.fetchQuizByCollection(collectionId);
  }

  Future<void> onSaveQuiz(
    Quiz quiz, [
    QuizCollection? collection,
  ]) async {
    emit(state.copyWith(isLoading: true));
    await _quizRepository.saveQuiz(quiz, collection);
    emit(state.copyWith(isLoading: false));
  }
}
