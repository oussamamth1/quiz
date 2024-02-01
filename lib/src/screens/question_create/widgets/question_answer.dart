import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/modules/quiz/bloc/quiz_bloc.dart';
import 'package:whizz/src/modules/quiz/model/answer.dart';

class QuestionAnswer extends StatelessWidget {
  const QuestionAnswer({
    super.key,
    required this.answers,
  });

  final List<Answer> answers;

  final listColors = const [
    Color(0xFFe35454),
    Color(0xFF30b0c7),
    Color(0xFFff9500),
    Color(0xFF3ed684),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return GridView.builder(
      itemCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        childAspectRatio: 16 / 9,
        mainAxisSpacing: 4,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            showAnswer(
              context: context,
              answer: answers[index],
              onChanged: (ans) {
                context
                    .read<QuizBloc>()
                    .add(OnQuestionAnswerChanged(ans, index));
              },
              onToggled: (_) {
                context
                    .read<QuizBloc>()
                    .add(OnQuestionAnswerStatusChanged(index));
              },
            );
          },
          child: Stack(
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(AppConstant.kPadding / 2),
                decoration: BoxDecoration(
                  color: listColors[index],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  answers[index].answer.isNotEmpty
                      ? answers[index].answer
                      : l10n.question_add_answer,
                  style: AppConstant.textSubtitle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: null,
                  textAlign: TextAlign.justify,
                  overflow: TextOverflow.visible,
                ),
              ),
              if (answers[index].isCorrect)
                const Positioned(
                  top: 0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    radius: 8,
                    child: FittedBox(
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

void showAnswer({
  required BuildContext context,
  required Answer answer,
  void Function(String)? onChanged,
  void Function(bool)? onToggled,
}) {
  final l10n = AppLocalizations.of(context)!;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(l10n.question_enter_answer),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              autofocus: true,
              maxLength: 150,
              maxLines: 3,
              minLines: 1,
              initialValue: answer.answer,
              style: AppConstant.textSubtitle,
              onChanged: onChanged,
            ),
            SwitchListTile(
              value: answer.isCorrect,
              dense: true,
              onChanged: (val) {
                onToggled!(val);
                context.pop();
              },
              title: Text(l10n.question_correct_answer),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: context.pop,
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
