import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/modules/profile/cubit/profile_cubit.dart';
import 'package:whizz/src/modules/quiz/bloc/quiz_bloc.dart';
import 'package:whizz/src/modules/quiz/model/quiz.dart';
import 'package:whizz/src/router/app_router.dart';
import 'package:whizz/src/screens/profile/widgets/collection_card.dart';
import 'package:whizz/src/screens/profile/widgets/quiz_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: [
                _buildTop(context, state),
                _buildDisplayInformation(state),
                const SizedBox(
                  height: AppConstant.kPadding,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppConstant.kPadding),
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius:
                          BorderRadius.circular(AppConstant.kPadding * 2),
                    ),
                    child: TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      unselectedLabelColor: Colors.black,
                      labelColor: Colors.white,
                      indicator: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(AppConstant.kPadding * 2),
                        color: Colors.green[400],
                      ),
                      tabs: [
                        Tab(
                          text: l10n.profile_quiz,
                        ),
                        Tab(
                          text: l10n.profile_collecttion,
                        ),
                        Tab(
                          text: l10n.profile_save,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: AppConstant.kPadding,
                ),
                SizedBox(
                  height: 1.sh,
                  child: TabBarView(
                    children: [
                      _buildListQuiz(state),
                      _buildOwnCollection(state),
                      _buildSaveQuiz(state),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Padding _buildListQuiz(ProfileState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          state.isLoading
              ? Text(
                  '0 Quizz',
                  style: AppConstant.textHeading,
                )
              : Text(
                  '${state.quizzies.length} Quizz',
                  style: AppConstant.textHeading,
                ),
          if (state.quizzies.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    QuizCard(
                      quiz: state.quizzies[index],
                      onTap: () {
                        context.pushNamed(
                          RouterPath.quizEdit.name,
                          extra: context.read<QuizBloc>()
                            ..add(OnGoToEditScreen(state.quizzies[index])),
                        );
                      },
                    ), //! hehe
                    const SizedBox(
                      height: AppConstant.kPadding / 2,
                    ),
                  ],
                );
              },
              itemCount: state.quizzies.length,
            ),
        ],
      ),
    );
  }

  Padding _buildOwnCollection(ProfileState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          state.isLoading
              ? Text(
                  '0 Collection',
                  style: AppConstant.textHeading,
                )
              : Text(
                  '${state.collections.length} Collection',
                  style: AppConstant.textHeading,
                ),
          if (state.collections.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final quizzies = <Quiz>[];
                context
                    .read<ProfileCubit>()
                    .onGetQuizByCollection(state.collections[index].id)
                    .then((value) {
                  quizzies.addAll(value);
                });
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DiscoveryCard(
                      onTap: () {
                        context
                            .pushNamed(RouterPath.discoverySave.name, extra: {
                          'collection': state.collections[index],
                          'quizzies': quizzies,
                        });
                      },
                      collection: state.collections[index],
                    ),
                    const SizedBox(
                      height: AppConstant.kPadding / 2,
                    ),
                  ],
                );
              },
              itemCount: state.collections.length,
            ),
        ],
      ),
    );
  }

  Padding _buildSaveQuiz(ProfileState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          state.isLoading
              ? Text(
                  '0 Quizz',
                  style: AppConstant.textHeading,
                )
              : Text(
                  '${state.save.length} Quizz',
                  style: AppConstant.textHeading,
                ),
          if (state.save.isNotEmpty)
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    QuizCard(
                      quiz: state.save[index],
                      onTap: () {
                        context.pushNamed(
                          RouterPath.quizDetail.name,
                          pathParameters: {'id': state.save[index].id},
                          extra: state.save[index],
                        );
                      },
                    ), //! hehe
                    const SizedBox(
                      height: AppConstant.kPadding / 2,
                    ),
                  ],
                );
              },
              itemCount: state.save.length,
            ),
        ],
      ),
    );
  }

  Column _buildDisplayInformation(ProfileState state) {
    return Column(
      children: [
        Text(
          state.user.name ?? 'Nameless',
          style: AppConstant.textTitle700,
        ),
        Text(
          '@${state.user.id}',
          style: AppConstant.textSubtitle,
        ),
      ],
    );
  }

  Stack _buildTop(BuildContext context, ProfileState state) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        _buildCoverImage(context),
        _buildAvatar(state),
      ],
    );
  }

  Positioned _buildAvatar(ProfileState state) {
    return Positioned(
      top: 150 - 35,
      child: CircleAvatar(
        radius: 35,
        backgroundColor: Colors.white,
        child: CircleAvatar(
          radius: 32,
          backgroundColor: Colors.grey.shade800,
          backgroundImage: state.user.avatar != null
              ? CachedNetworkImageProvider(state.user.avatar!)
              : null,
        ),
      ),
    );
  }

  Widget _buildCoverImage(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 150,
          margin: const EdgeInsets.only(bottom: 35),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF22C1C3),
                Color(0xFFFDBB2D),
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(AppConstant.kPadding * 2),
              bottomRight: Radius.circular(AppConstant.kPadding * 2),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  context.pushNamed(
                    RouterPath.profileEdit.name,
                    extra: context.read<ProfileCubit>(),
                  );
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
