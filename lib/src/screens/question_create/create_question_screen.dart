import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/extensions/extension.dart';
import 'package:whizz/src/common/widgets/shared_widget.dart';

import 'package:whizz/src/modules/quiz/bloc/quiz_bloc.dart';

import 'package:whizz/src/screens/question_create/widgets/preview_question_card.dart';
import 'package:whizz/src/screens/question_create/widgets/question_answer.dart';

class CreateQuestionScreen extends StatelessWidget {
  const CreateQuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(l10n.question_create),
        actions: [
          IconButton(
            onPressed: () {
              context.showConfirmDialog(
                title: l10n.delete_title,
                description: l10n.delete_subtitle,
                onNegativeButton: () {},
                onPositiveButton: () => context
                    .read<QuizBloc>()
                    .add(const OnRemoveCurrentQuestion()),
              );
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstant.kPadding),
        child: BlocBuilder<QuizBloc, QuizState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context
                            .read<QuizBloc>()
                            .add(OnQuestionMediaChanged(context));
                      },
                      child: ImageCover(
                        media: state.quiz.questions[state.index].media,
                      ),
                    ),
                    Positioned(
                      bottom: AppConstant.kPadding / 2,
                      left: AppConstant.kPadding,
                      child: ElevatedButton.icon(
                        onPressed: () => showSetTimer(
                          context: context,
                          state: state,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF036be5),
                        ),
                        icon: const Icon(
                          Icons.timer,
                          color: Colors.white,
                        ),
                        label: Text(
                          '${state.quiz.questions[state.index].duration}s',
                          style: AppConstant.textSubtitle.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: AppConstant.kPadding / 2,
                ),
                GestureDetector(
                  onTap: () {
                    showInputTitle(
                      context: context,
                      initialValue: state.quiz.questions[state.index].name,
                      onChanged: (name) => context
                          .read<QuizBloc>()
                          .add(OnQuestionNameChanged(name)),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(AppConstant.kPadding / 2),
                    width: double.infinity,
                    constraints: BoxConstraints(
                      maxHeight: .08.sh,
                      minHeight: .05.sh,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6d5ff6),
                      borderRadius: BorderRadius.circular(AppConstant.kPadding),
                    ),
                    child: Text(
                      state.quiz.questions[state.index].name.isEmpty
                          ? l10n.question_add_title
                          : state.quiz.questions[state.index].name,
                      style: AppConstant.textSubtitle.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: null,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ),
                const SizedBox(
                  height: AppConstant.kPadding / 2,
                ),
                Expanded(
                  child: QuestionAnswer(
                    answers: state.quiz.questions[state.index].answers,
                  ),
                ),
                const SizedBox(
                  height: AppConstant.kPadding / 2,
                ),
                Row(
                  children: [
                    PreviewQuestionCard(
                      questions: state.quiz.questions,
                    ),
                    const SizedBox(
                      width: AppConstant.kPadding,
                    ),
                    IconButton.filled(
                      onPressed: () {
                        context
                            .read<QuizBloc>()
                            .add(OnCreateNewQuestion(context));
                      },
                      style: IconButton.styleFrom(),
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

void showSetTimer({
  required BuildContext context,
  required QuizState state,
}) {
  final l10n = AppLocalizations.of(context)!;

  final lsTimer = <int>[5, 10, 15, 30, 45, 60, 90, 120];
  int currentIndex =
      lsTimer.indexOf(state.quiz.questions[state.index].duration!);

  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16.0),
    ),
    builder: (ctx) {
      return StatefulBuilder(
        builder: (_, setState) {
          return Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.question_set_duration,
                  style: AppConstant.textHeading,
                ),
                const SizedBox(
                  height: AppConstant.kPadding / 2,
                ),
                Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemCount: lsTimer.length,
                    itemBuilder: (_, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            currentIndex = index;
                          });
                        },
                        child: Material(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Container(
                            decoration: currentIndex != index
                                ? BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    color: Colors.white,
                                  )
                                : BoxDecoration(
                                    gradient: AppConstant.sunsetGradient,
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                            child: Center(
                              child: Text('${lsTimer[index]}s'),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: AppConstant.kPadding / 2,
                ),
                CustomButton(
                  onPressed: () {
                    context
                        .read<QuizBloc>()
                        .add(OnQuestionDurationChanged(lsTimer[currentIndex]));
                    context.pop();
                  },
                  label: l10n.continue_text,
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

void showInputTitle({
  required BuildContext context,
  required String initialValue,
  void Function(String)? onChanged,
}) {
  final l10n = AppLocalizations.of(context)!;
  showDialog(
    context: context,
    barrierDismissible: false,
    useRootNavigator: true,
    builder: (context) {
      return AlertDialog(
        title: Text(l10n.question_enter_title),
        content: TextFormField(
          autofocus: true,
          maxLength: 150,
          maxLines: 3,
          minLines: 1,
          initialValue: initialValue,
          onChanged: onChanged,
          style: AppConstant.textSubtitle,
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
