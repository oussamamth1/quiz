

import 'package:whizz/src/modules/quiz/model/question.dart';
import 'package:whizz/src/modules/quiz/model/quiz.dart';

extension EnumX on String {
  QuizVisibility convertQuizVisibitity() {
    switch (this) {
      case 'private':
        return QuizVisibility.private;
      case 'public':
        return QuizVisibility.public;
      default:
        return QuizVisibility.public;
    }
  }

  AttachType convertAttachType() {
    switch (this) {
      case 'local':
        return AttachType.local;
      case 'onlie':
        return AttachType.online;
      default:
        return AttachType.none;
    }
  }

  QuestionType convertQuestionType() {
    switch (this) {
      case 'choice':
        return QuestionType.choice;
      case 'poll':
        return QuestionType.poll;
      case 'yesNo':
        return QuestionType.yesNo;
      default:
        return QuestionType.choice;
    }
  }
}
