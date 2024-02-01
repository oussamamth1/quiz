// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'quiz_collection_cubit.dart';

sealed class QuizCollectionState {
  const QuizCollectionState();
}

class QuizCollectionInitial implements QuizCollectionState {
  const QuizCollectionInitial();
}

class QuizCollectionLoading implements QuizCollectionState {
  const QuizCollectionLoading();
}

class QuizCollectionSuccess implements QuizCollectionState {
  const QuizCollectionSuccess(this.collections);

  final List<QuizCollection> collections;
}

class QuizCollectionError implements QuizCollectionState {
  const QuizCollectionError(this.message);

  final String message;
}

class QuizCollectionState2 extends Equatable {
  const QuizCollectionState2({
    this.collections = const [],
    this.isLoading = false,
    this.error,
  });

  final bool isLoading;
  final String? error;
  final List<QuizCollection> collections;

  @override
  List<Object?> get props => [
        collections,
        isLoading,
        error,
      ];

  QuizCollectionState2 copyWith({
    bool? isLoading,
    String? error,
    List<QuizCollection>? collections,
  }) {
    return QuizCollectionState2(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      collections: collections ?? this.collections,
    );
  }
}
