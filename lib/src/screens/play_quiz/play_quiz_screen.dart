import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/extensions/extension.dart';
import 'package:whizz/src/common/widgets/shared_widget.dart';
import 'package:whizz/src/gen/assets.gen.dart';
import 'package:whizz/src/modules/lobby/cubit/lobby_cubit.dart';
import 'package:whizz/src/modules/lobby/model/lobby.dart';
import 'package:whizz/src/modules/play/cubit/play_cubit.dart';
import 'package:whizz/src/modules/quiz/model/question.dart';
import 'package:whizz/src/modules/quiz/model/quiz.dart';
import 'package:whizz/src/router/app_router.dart';
import 'package:whizz/src/screens/play_quiz/widgets/choose_tile.dart';

class PlayQuizScreen extends StatefulWidget {
  const PlayQuizScreen({
    super.key,
    required this.quiz,
    this.isSoloMode = true,
  });

  final Quiz quiz;
  final bool isSoloMode;

  @override
  State<PlayQuizScreen> createState() => _PlayQuizScreenState();
}

class _PlayQuizScreenState extends State<PlayQuizScreen> {
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: BlocBuilder<GameCubit, GameState>(
        builder: (context, state) {
          return Scaffold(
            body: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: _controller,
              itemCount: widget.quiz.questions.length * 2 + 1,
              itemBuilder: (context, index) {
                final currentQuestion =
                    widget.quiz.questions[state.currentQuestion];

                if (index.isEven) {
                  if (index == widget.quiz.questions.length * 2) {
                    return widget.isSoloMode
                        ? _buildTotalSoloScorePage(context)
                        : _buildTotalFriendScorePage(context);
                  }
                  return _buildQuestionPage(
                      state, currentQuestion, index, context);
                }

                return _buildShowScorePage(index, context);
              },
            ),
          );
        },
      ),
      onWillPop: () async => false,
    );
  }

  Widget _buildTotalFriendScorePage(BuildContext context) {
    double rating = 0.0;
    bool isClicked = false;

    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(AppConstant.kPadding),
      child: BlocBuilder<LobbyCubit, Lobby>(
        builder: (context, state) {
          final rank = context.read<LobbyCubit>().getRank();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(
                title: Text(l10n.leaderboard),
                automaticallyImplyLeading: false,
              ),
              Center(
                child: Text(
                  l10n.user_got_rank(rank + 1),
                  style: AppConstant.textHeading,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: state.participants.length > 5
                      ? 5
                      : state.participants.length,
                  itemBuilder: (context, index) {
                    final participant = state.participants[index];
                    return Ink(
                      decoration: BoxDecoration(
                        color: index == rank ? Colors.grey.shade400 : null,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: AppConstant.kPadding,
                          ),
                          Text(
                            '${index + 1}',
                            style: AppConstant.textTitle700,
                          ),
                          Expanded(
                            child: ListTile(
                              leading: participant.participant.avatar != null
                                  ? CircleAvatar(
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              participant.participant.avatar!),
                                    )
                                  : null,
                              title: Text(participant.participant.name!),
                              trailing: Text(participant.score.toString()),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        l10n.quiz_satisfied,
                        style: AppConstant.textTitle700,
                      ),
                    ),
                    Center(
                      child: RatingBar.builder(
                        itemBuilder: (context, index) {
                          switch (index) {
                            case 0:
                              return const Icon(
                                Icons.sentiment_very_dissatisfied,
                                color: Colors.red,
                              );
                            case 1:
                              return const Icon(
                                Icons.sentiment_dissatisfied,
                                color: Colors.redAccent,
                              );
                            case 2:
                              return const Icon(
                                Icons.sentiment_neutral,
                                color: Colors.amber,
                              );
                            case 3:
                              return const Icon(
                                Icons.sentiment_satisfied,
                                color: Colors.lightGreen,
                              );
                            case 4:
                              return const Icon(
                                Icons.sentiment_very_satisfied,
                                color: Colors.green,
                              );
                            default:
                              return const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              );
                          }
                        },
                        allowHalfRating: true,
                        onRatingUpdate: (r) {
                          rating = r;
                          isClicked = true;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: AppConstant.kPadding,
                    ),
                    CustomButton(
                      onPressed: () {
                        context
                            .read<LobbyCubit>()
                            .rating(isClicked, rating)
                            .then((_) {
                          context.read<LobbyCubit>().cancel();
                          context.goNamed(RouterPath.home.name);
                        });
                      },
                      label: l10n.go_back,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTotalSoloScorePage(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.all(AppConstant.kPadding),
      child: BlocBuilder<LobbyCubit, Lobby>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(
                title: Text(l10n.leaderboard),
                automaticallyImplyLeading: false,
              ),
              BlocBuilder<GameCubit, GameState>(
                builder: (context, s) {
                  return Center(
                    child: Text(
                      l10n.user_got_point(s.score),
                      style: AppConstant.textHeading,
                    ),
                  );
                },
              ),
              Expanded(
                child: state.solo.isNotEmpty
                    ? ListView.builder(
                        itemCount:
                            state.solo.length > 5 ? 5 : state.solo.length,
                        itemBuilder: (context, index) {
                          final lobby = state.solo[index];
                          final participant = lobby.participants[0];
                          return Row(
                            children: [
                              const SizedBox(
                                width: AppConstant.kPadding,
                              ),
                              Text(
                                '${index + 1}',
                                style: AppConstant.textTitle700,
                              ),
                              Expanded(
                                child: ListTile(
                                  leading:
                                      participant.participant.avatar != null
                                          ? CircleAvatar(
                                              backgroundImage:
                                                  CachedNetworkImageProvider(
                                                participant.participant.avatar!,
                                              ),
                                            )
                                          : CircleAvatar(
                                              backgroundImage: Assets
                                                  .images.unknownUser
                                                  .provider(),
                                            ),
                                  title: Text(participant.participant.name!),
                                  subtitle: Text(
                                    lobby.startTime!.format(),
                                    style: AppConstant.textSubtitle,
                                  ),
                                  trailing: Text(
                                    participant.score.toString(),
                                    style: AppConstant.textTitle700.copyWith(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(l10n.leaderboard_wait),
                            const CircularProgressIndicator.adaptive(),
                          ],
                        ),
                      ),
              ),
              if (state.solo.isNotEmpty)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomButton(
                    onPressed: () {
                      context.goNamed(RouterPath.home.name);
                      context.read<LobbyCubit>().cancel();
                    },
                    label: l10n.go_back,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  LeaderboardCountdown _buildShowScorePage(int index, BuildContext context) {
    return LeaderboardCountdown(
      onNextQuestion: () async {
        if (index <= (widget.quiz.questions.length - 1) * 2 + 1) {
          if (index <= (widget.quiz.questions.length - 1) * 2) {
            context.read<GameCubit>().nextQuestion();
          } else {
            await context.read<LobbyCubit>().soloHistory();
          }
          _controller.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        }
      },
    );
  }

  Widget _buildQuestionPage(
    GameState state,
    Question currentQuestion,
    int index,
    BuildContext context,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(AppConstant.kPadding),
      child: Column(
        children: [
          AppBar(
            title: Text(
              '${l10n.question.toCapitalize()} ${state.currentQuestion + 1}/${widget.quiz.questions.length}',
            ),
            actions: [
              // Bộ đếm thời gian
              QuestionCountdown(
                duration: currentQuestion.duration ?? 0,
                quiz: widget.quiz,
                onNextQuestion: () {
                  if (index <= (widget.quiz.questions.length - 1) * 2 + 1) {
                    context.read<LobbyCubit>().calculateScore(state.score);
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  }
                },
              ),
            ],
            automaticallyImplyLeading: false,
          ),
          ImageCover(
            media: currentQuestion.media,
            isPreview: true,
          ),
          const SizedBox(
            height: AppConstant.kPadding / 2,
          ),
          Container(
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
              widget.quiz.questions[state.currentQuestion].name,
              style: AppConstant.textSubtitle.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              maxLines: null,
              textAlign: TextAlign.center,
              overflow: TextOverflow.visible,
            ),
          ),
          const SizedBox(
            height: AppConstant.kPadding / 2,
          ),
          Expanded(
            child: ChooseTile(
              question: widget.quiz.questions[state.currentQuestion],
            ),
          ),
          const SizedBox(
            height: AppConstant.kPadding / 2,
          ),
        ],
      ),
    );
  }
}

class LeaderboardCountdown extends StatefulWidget {
  const LeaderboardCountdown({
    super.key,
    required this.onNextQuestion,
  });

  final VoidCallback onNextQuestion;

  @override
  State<LeaderboardCountdown> createState() => _LeaderboardCountdownState();
}

class _LeaderboardCountdownState extends State<LeaderboardCountdown> {
  Timer? timer;
  int seconds = 3;

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (seconds > 0) {
        seconds--;
      } else {
        timer?.cancel();
        widget.onNextQuestion();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(AppConstant.kPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            title: Text(l10n.show_score),
            automaticallyImplyLeading: false,
          ),
          BlocBuilder<LobbyCubit, Lobby>(
            builder: (context, state) {
              final rank = context.read<LobbyCubit>().getRank();
              return Expanded(
                child: ListView.builder(
                  itemCount: state.participants.length > 5
                      ? 5
                      : state.participants.length,
                  itemBuilder: (context, index) {
                    final participant = state.participants[index];
                    return Ink(
                      decoration: BoxDecoration(
                        color: index == rank ? Colors.grey.shade400 : null,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: AppConstant.kPadding,
                          ),
                          Text(
                            '${index + 1}',
                            style: AppConstant.textTitle700,
                          ),
                          Expanded(
                            child: ListTile(
                              leading: participant.participant.avatar != null
                                  ? CircleAvatar(
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              participant.participant.avatar!),
                                    )
                                  : null,
                              title: Text(participant.participant.name!),
                              trailing: Text(participant.score.toString()),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class QuestionCountdown extends StatefulWidget {
  const QuestionCountdown({
    super.key,
    required this.duration,
    required this.quiz,
    required this.onNextQuestion,
  });

  final int duration;
  final Quiz quiz;
  final VoidCallback onNextQuestion;

  @override
  State<QuestionCountdown> createState() => _QuestionCountdownState();
}

class _QuestionCountdownState extends State<QuestionCountdown> {
  Timer? timer;
  int seconds = 0;

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (seconds > 0) {
          seconds--;
          context.read<GameCubit>().tick(seconds);
        } else {
          timer?.cancel();

          // Delay 2s để show đáp án
          Future.delayed(const Duration(seconds: 2)).then((_) {
            context.read<GameCubit>().tick(-1);

            widget.onNextQuestion();
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    seconds = widget.duration;
    _startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: Text('$seconds'),
    );
  }
}
