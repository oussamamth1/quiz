import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/extensions/extension.dart';
import 'package:whizz/src/common/widgets/custom_button.dart';
import 'package:whizz/src/common/widgets/image_cover.dart';
import 'package:whizz/src/modules/collection/model/quiz_collection.dart';
import 'package:whizz/src/modules/lobby/cubit/lobby_cubit.dart';
import 'package:whizz/src/modules/profile/cubit/profile_cubit.dart';
import 'package:whizz/src/modules/quiz/model/quiz.dart';
import 'package:whizz/src/router/app_router.dart';

class QuestionDetailScreen extends StatelessWidget {
  const QuestionDetailScreen({
    super.key,
    required this.quiz,
  });

  final Quiz quiz;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  showSaveDialog(context);
                },
                icon: const Icon(Icons.share),
              ),
              IconButton(
                onPressed: () {
                  showSaveDialog(context);
                },
                icon: const Icon(Icons.copy),
              ),
              IconButton(
                onPressed: () {
                  showSaveDialog(context);
                },
                icon: const Icon(Icons.bookmark),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppConstant.kPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 3 / 2,
                child: ImageCover(
                  media: quiz.media,
                  isPreview: true,
                ),
              ),
              const SizedBox(
                height: AppConstant.kPadding / 2,
              ),
              Text(
                quiz.title,
                style: AppConstant.textHeading.copyWith(
                  fontSize: 22.sp,
                  color: Colors.red,
                ),
              ),
              const SizedBox(
                height: AppConstant.kPadding * 2,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstant.kPadding),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(l10n.quiz_played),
                          const SizedBox(
                            height: AppConstant.kPadding / 4,
                          ),
                          Text(
                            quiz.playedCount.toString(),
                            style: AppConstant.textTitle700,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(l10n.quiz_rating),
                          const SizedBox(
                            height: AppConstant.kPadding / 4,
                          ),
                          Text(
                            '${quiz.rating.toStringAsFixed(1)} ⭐',
                            style: AppConstant.textTitle700,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(l10n.quiz_question_count),
                          const SizedBox(
                            height: AppConstant.kPadding / 4,
                          ),
                          Text(
                            quiz.questions.length.toString(),
                            style: AppConstant.textTitle700,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: AppConstant.kPadding * 2,
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        CachedNetworkImageProvider(quiz.author.avatar!),
                  ),
                  const SizedBox(
                    width: AppConstant.kPadding / 2,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        quiz.author.name!,
                        style: AppConstant.textTitle700.copyWith(
                          fontSize: 12.sp,
                        ),
                      ),
                      Text(
                        '@${quiz.author.id}',
                        style: AppConstant.textSubtitle.copyWith(
                          fontSize: 10.sp,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: AppConstant.kPadding,
              ),
              Text(
                l10n.quiz_description,
                style: AppConstant.textTitle700.copyWith(
                  color: AppConstant.primaryColor,
                ),
              ),
              const SizedBox(
                height: AppConstant.kPadding / 2,
              ),
              Text(
                quiz.description!.isEmpty
                    ? l10n.quiz_description_empty
                    : quiz.description!,
                style: AppConstant.textSubtitle,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(AppConstant.kPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  context
                      .read<LobbyCubit>()
                      .createLobby(quiz, isSoloMode: false);
                  context.pushNamed(
                    RouterPath.lobby.name,
                    extra: false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstant.primaryColor,
                  elevation: 4,
                ),
                child: FittedBox(
                  child: Text(
                    l10n.quiz_play_friend,
                    style: AppConstant.textHeading.copyWith(
                      color: Colors.white,
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: AppConstant.kPadding,
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  context.read<LobbyCubit>().createLobby(quiz);
                  context.pushNamed(
                    RouterPath.lobby.name,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 4,
                ),
                child: FittedBox(
                  child: Text(
                    l10n.quiz_play_solo,
                    style: AppConstant.textHeading.copyWith(
                      fontSize: 14.sp,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSaveDialog(BuildContext context) {
    QuizCollection? selectedCollection;
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          height: .5.sh,
          child: AlertDialog(
            title: Text(l10n.save_quiz_collection_title),
            content: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                if (state.collections.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.collections.length,
                    itemBuilder: (context, index) {
                      return StatefulBuilder(
                        builder: (context, setState) {
                          return RadioListTile.adaptive(
                            dense: true,
                            title: Text(state.collections[index].name),
                            value: state.collections[index],
                            groupValue: selectedCollection,
                            onChanged: (val) {
                              setState(() {
                                selectedCollection = val!;
                              });
                            },
                          );
                        },
                      );
                    },
                  );
                } else {
                  return Container();
                }
              },
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      onPressed: () {
                        context
                            .read<ProfileCubit>()
                            .onSaveQuiz(quiz, selectedCollection)
                            .then((_) {
                          context.pop();
                          context.showSuccessSnackBar(
                              l10n.bookmark_save_quiz_successfully);
                        });
                      },
                      label: l10n.save_quiz_collection_positive,
                      backgroundColor: Colors.white,
                      color: AppConstant.primaryColor,
                    ),
                  ),
                  const SizedBox(
                    width: AppConstant.kPadding / 2,
                  ),
                  Expanded(
                    child: CustomButton(
                      onPressed: () {
                        context.pushNamed(RouterPath.discoveryCreate.name);
                      },
                      label: l10n.save_quiz_collection_negative,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
