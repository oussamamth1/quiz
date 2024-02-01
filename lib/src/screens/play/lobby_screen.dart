import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/extensions/extension.dart';
import 'package:whizz/src/common/widgets/custom_button.dart';
import 'package:whizz/src/modules/lobby/cubit/lobby_cubit.dart';
import 'package:whizz/src/modules/lobby/model/lobby.dart';
import 'package:whizz/src/modules/quiz/model/quiz.dart';
import 'package:whizz/src/router/app_router.dart';
import 'package:whizz/src/screens/play/widgets/popup_menu.dart';

class LobbyScreen extends StatelessWidget {
  const LobbyScreen({
    super.key,
    this.isSoloMode = true,
  });

  final bool isSoloMode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final title = isSoloMode ? l10n.solo_mode : l10n.pvp_mode;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          leading: BlocBuilder<LobbyCubit, Lobby>(
            builder: (context, state) {
              return IconButton(
                onPressed: () {
                  context.showConfirmDialog(
                      title: state.isHost
                          ? l10n.lobby_cancel_title_host
                          : l10n.lobby_cancel_title_user,
                      description: state.isHost
                          ? l10n.lobby_cancel_description_host
                          : l10n.lobby_cancel_description_user,
                      onNegativeButton: () {},
                      onPositiveButton: () {
                        context
                            .read<LobbyCubit>()
                            .outRoom()
                            .then((_) => context.goNamed(RouterPath.home.name));
                      });
                },
                icon: const Icon(Icons.arrow_back_ios_new),
              );
            },
          ),
          actions: [
            if (!isSoloMode) const CreateOptionsPopupMenu(),
          ],
        ),
        body: BlocBuilder<LobbyCubit, Lobby>(
          builder: (context, state) {
            return StreamBuilder<Lobby>(
                stream: context.read<LobbyCubit>().streamData(),
                builder: (_, snapshot) {
                  // if (!state.isHost && state.isCancelled) {
                  //   context.showInformationDialog(
                  //     title: l10n.lobby_quit_title,
                  //     description: l10n.lobby_quit_description,
                  //     btnOkOnPress: () {},
                  //   );
                  // }
                  // if (snapshot.hasData) {
                  //   if (snapshot.data!.isCancelled && !snapshot.data!.isHost) {
                  //     context.showInformationDialog(
                  //       title: l10n.lobby_quit_title,
                  //       description: l10n.lobby_quit_description,
                  //       btnOkOnPress: () {
                  //         context.goNamed(RouterPath.home.name);
                  //       },
                  //     );
                  //   }
                  // }
                  return Padding(
                    padding: const EdgeInsets.all(AppConstant.kPadding),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (!isSoloMode) ...[
                            if (state.code != null)
                              QrImageView(
                                data: state.code!,
                                version: QrVersions.auto,
                                size: .2.sh,
                              ),
                            Text(
                              state.code ?? '',
                              style: AppConstant.textTitle700.copyWith(
                                fontSize: 28.sp,
                              ),
                            ),
                            const SizedBox(
                              height: AppConstant.kPadding,
                            ),
                          ],
                          Text(
                            state.quiz.title,
                            style: AppConstant.textTitle700.copyWith(
                              fontSize: 20.sp,
                            ),
                          ),
                          const SizedBox(
                            height: AppConstant.kPadding / 4,
                          ),
                          Text(
                            state.quiz.description ?? '',
                            textAlign: TextAlign.center,
                            style: AppConstant.textSubtitle.copyWith(
                              fontSize: 16.sp,
                            ),
                          ),
                          const Spacer(),
                          if (!state.isStart) ...[
                            Text(
                              '${state.participants.length} ${l10n.participant}',
                              style: AppConstant.textTitle700,
                            ),
                            Wrap(
                              children: state.participants
                                  .map((e) => Chip(
                                        label: Text(e.participant.name!),
                                      ))
                                  .toList(),
                            ),
                          ],
                          const Spacer(),
                          if (state.isStart) ...[
                            Text(
                              l10n.lobby_start,
                              style: AppConstant.textHeading,
                            ),
                            Counter(
                              quiz: state.quiz,
                              isSoloMode: isSoloMode,
                            ),
                          ] else if (state.participants.isNotEmpty &&
                              state.isHost)
                            CustomButton(
                              onPressed: () {
                                context.read<LobbyCubit>().startGame();
                              },
                              label: l10n.lobby_start_button,
                            ),
                        ],
                      ),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }
}

class Counter extends StatefulWidget {
  const Counter({
    super.key,
    required this.quiz,
    required this.isSoloMode,
  });

  final Quiz quiz;
  final bool isSoloMode;

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  Timer? timer;
  int seconds = 5;

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          timer?.cancel();
          context.pushReplacementNamed(
            RouterPath.playQuiz.name,
            pathParameters: {'id': widget.quiz.id},
            extra: {
              'quiz': widget.quiz,
              'isSoloMode': widget.isSoloMode,
            },
          );
        }
      });
    });
  }

  @override
  void initState() {
    _startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      seconds.toString(),
      style: AppConstant.textHeading.copyWith(
        color: Colors.red,
      ),
    );
  }
}
