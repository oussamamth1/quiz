import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whizz/src/modules/collection/model/quiz_collection.dart';
import 'package:whizz/src/modules/collection/repository/quiz_collection_repository.dart';
import 'package:whizz/src/modules/quiz/model/media.dart';
import 'package:whizz/src/modules/quiz/model/quiz.dart';

part 'quiz_collection_state.dart';

class QuizCollectionCubit extends Cubit<QuizCollectionState2> {
  QuizCollectionCubit({QuizCollectionRepository? repository})
      : _repository = repository ?? QuizCollectionRepository(),
        super(const QuizCollectionState2()) {
    onGetCollection();
  }

  final QuizCollectionRepository _repository;

  void onGetCollection() {
    emit(state.copyWith(isLoading: true));
    try {
      _repository.listenAllCollections().listen((result) {
        emit(state.copyWith(collections: result));
      });
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      log("Collection $e");
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<List<Quiz>> onGetQuizByCollectionId(String collectionId) async {
    final result = await _repository.collectionByID(collectionId);
    return result;
  }

  Future<void> onCreateNewCollection({
    required String name,
    required Media media,
    required bool isPublic,
  }) async {
    final collection = await _repository.addNewCollection(
      name: name,
      media: media,
      isPublic: isPublic,
    );

    final collections = List<QuizCollection>.from(state.collections)
      ..add(collection);
    emit(state.copyWith(
      collections: collections,
    ));
  }
}
