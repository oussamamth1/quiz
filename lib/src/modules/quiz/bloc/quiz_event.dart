part of 'quiz_bloc.dart';

sealed class QuizEvent {
  const QuizEvent();
}

final class OnInitialNewQuiz implements QuizEvent {
  const OnInitialNewQuiz(this.context);

  final BuildContext context;
}

class OnQuizTitleChanged implements QuizEvent {
  const OnQuizTitleChanged(this.title);

  final String title;
}

final class OnQuizDescriptionChange implements QuizEvent {
  const OnQuizDescriptionChange(this.description);

  final String description;
}

final class OnQuizVisibilityChanged implements QuizEvent {
  const OnQuizVisibilityChanged(this.visibility);

  final String visibility;
}

final class OnQuizCollectionChanged implements QuizEvent {
  const OnQuizCollectionChanged(this.collectionId);

  final String? collectionId;
}

final class OnTakePhoto implements QuizEvent {
  const OnTakePhoto();
}

final class OnPickLocalImage implements QuizEvent {
  const OnPickLocalImage();
}

final class OnPickOnlineImage implements QuizEvent {
  const OnPickOnlineImage(this.imageUrl);

  final String imageUrl;
}

final class OnQuizMediaChanged implements QuizEvent {
  const OnQuizMediaChanged(this.context);

  final BuildContext context;
}

final class OnCreateNewQuestion implements QuizEvent {
  const OnCreateNewQuestion(this.context, [this.isInQuizScreen = false]);

  final BuildContext context;
  final bool isInQuizScreen;
}

final class OnQuestionSelectedChanged implements QuizEvent {
  const OnQuestionSelectedChanged(this.index);

  final int index;
}

final class OnQuestionNameChanged implements QuizEvent {
  const OnQuestionNameChanged(this.name);

  final String name;
}

final class OnQuestionMediaChanged implements QuizEvent {
  const OnQuestionMediaChanged(this.context);

  final BuildContext context;
}

final class OnQuestionDurationChanged implements QuizEvent {
  const OnQuestionDurationChanged(this.duration);

  final int duration;
}

final class OnQuestionAnswerChanged implements QuizEvent {
  const OnQuestionAnswerChanged(this.answer, this.index);

  final String answer;
  final int index;
}

final class OnQuestionAnswerStatusChanged implements QuizEvent {
  const OnQuestionAnswerStatusChanged(this.index);

  final int index;
}

final class OnRemoveCurrentQuestion implements QuizEvent {
  const OnRemoveCurrentQuestion();
}

final class OnGoToEditScreen implements QuizEvent {
  const OnGoToEditScreen(this.quiz);

  final Quiz quiz;
}

final class OnRemoveQuiz implements QuizEvent {
  const OnRemoveQuiz(this.context, this.quiz);

  final BuildContext context;
  final Quiz quiz;
}
