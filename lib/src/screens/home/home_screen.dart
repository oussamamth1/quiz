import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/extensions/extension.dart';
import 'package:whizz/src/common/widgets/shared_widget.dart';

import 'package:whizz/src/gen/assets.gen.dart';
import 'package:whizz/src/modules/collection/cubit/quiz_collection_cubit.dart';
import 'package:whizz/src/modules/collection/model/quiz_collection.dart';
import 'package:whizz/src/modules/quiz/cubit/list_quiz_cubit.dart';
import 'package:whizz/src/modules/quiz/model/quiz.dart';
import 'package:whizz/src/router/app_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppConstant.kPadding),
          child: Column(
            children: [
              _buildPlayQuiz(context),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.top_collection,
                    style: AppConstant.textHeading,
                  ),
                  InkWell(
                    onTap: () {
                      context.pushNamed(RouterPath.discovery.name);
                    },
                    child: Text(
                      l10n.show_all,
                      style: AppConstant.textSubtitle,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: AppConstant.kPadding / 2,
              ),
              _buildTopCollection(),
              const SizedBox(
                height: AppConstant.kPadding,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.top_quiz,
                    style: AppConstant.textHeading,
                  ),
                  Text(
                    l10n.show_all,
                    style: AppConstant.textSubtitle,
                  ),
                ],
              ),
              const SizedBox(
                height: AppConstant.kPadding / 2,
              ),
              SizedBox(
                height: .18.sh,
                child: BlocBuilder<ListQuizCubit, ListQuizState>(
                  builder: (context, state) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: !state.isLoading ? state.quiz.length : 5,
                      itemBuilder: (context, index) {
                        return !state.isLoading
                            ? Container(
                                margin: const EdgeInsets.only(
                                    right: AppConstant.kPadding / 2),
                                child: GestureDetector(
                                  onTap: () {
                                    context.pushNamed(
                                      RouterPath.quizDetail.name,
                                      pathParameters: {
                                        'id': state.quiz[index].id
                                      },
                                      extra: state.quiz[index],
                                    );
                                  },
                                  child: _buildTopQuiz(state, index, l10n),
                                ),
                              )
                            : Container();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AspectRatio _buildTopQuiz(
    ListQuizState state,
    int index,
    AppLocalizations l10n,
  ) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ImageCover(
                    media: state.quiz[index].media,
                    isPreview: true,
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstant.kPadding / 4,
                      horizontal: AppConstant.kPadding,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(AppConstant.kPadding),
                        bottomLeft: Radius.circular(AppConstant.kPadding),
                      ),
                    ),
                    child: Text(
                      '${state.quiz[index].questions.length} ${l10n.question}',
                      style: AppConstant.textSubtitle.copyWith(
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: AppConstant.kPadding / 2,
          ),
          Text(
            state.quiz[index].title,
            style: AppConstant.textTitle700,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  SizedBox _buildTopCollection() {
    return SizedBox(
      height: .15.sh,
      child: BlocBuilder<QuizCollectionCubit, QuizCollectionState2>(
        builder: (context, state) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: state.collections.length,
            itemBuilder: (context, index) {
              if (!state.isLoading) {
                return GestureDetector(
                    onTap: () {
                      context.pushNamed(
                        RouterPath.discoveryDetail.name,
                        extra: state.collections[index],
                      );
                      context
                          .read<QuizCollectionCubit>()
                          .onGetQuizByCollectionId(state.collections[index].id);
                    },
                    child:
                        CollectionCard(collection: state.collections[index]));
              } else {
                return Container();
              }
            },
          );
        },
      ),
    );
  }

  Stack _buildPlayQuiz(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstant.kPadding),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConstant.kPadding),
            child: Assets.images.homeIntroduce.image(
              height: .35.sh,
              width: 1.sw,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: .35.sh,
          width: 1.sw,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstant.kPadding),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black12,
                Colors.black26,
              ],
            ),
          ),
        ),
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Center(
            child: Text(
              l10n.banner_friend_join,
              style: AppConstant.textTitle700.copyWith(
                color: Colors.white,
                fontSize: 18.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: CustomButton(
            onPressed: () => context.pushNamed(RouterPath.play.name),
            label: l10n.let_us_start,
          ),
        ),
      ],
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Quizwhizz'),
      actions: [
        IconButton(
          onPressed: () {
            showSearch(
              context: context,
              delegate: CustomSearch(
                cubit: context.read<ListQuizCubit>(),
              ),
            );
          },
          icon: const Icon(
            Icons.search,
          ),
        ),
      ],
    );
  }
}

class CollectionCard extends StatelessWidget {
  const CollectionCard({
    super.key,
    required this.collection,
  });

  final QuizCollection collection;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            margin: const EdgeInsets.only(right: AppConstant.kPadding / 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstant.kPadding),
              image: DecorationImage(
                image: CachedNetworkImageProvider(collection.imageUrl!),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            margin: const EdgeInsets.only(right: AppConstant.kPadding / 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstant.kPadding),
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black26,
                  Colors.black12,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Text(
            collection.name,
            style: AppConstant.textSubtitle.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class CustomSearch extends SearchDelegate {
  CustomSearch({required this.cubit});

  final ListQuizCubit cubit;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<ListQuizCubit, ListQuizState>(
      bloc: cubit,
      builder: (context, state) {
        final matchQuery = <Quiz>[];
        for (final item in state.quiz) {
          if (item.title.toLowerCase().contains(query.toLowerCase())) {
            matchQuery.add(item);
          }
        }
        if (matchQuery.isNotEmpty) {
          return ListView.builder(
            itemCount: matchQuery.length,
            itemBuilder: (context, index) {
              final result = matchQuery[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: ImageCover(media: result.media),
                  title: Text(result.title),
                ),
              );
            },
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppConstant.kPadding / 2,
              horizontal: AppConstant.kPadding,
            ),
            child: Text(l10n.search_quiz_not_found),
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<ListQuizCubit, ListQuizState>(
      bloc: cubit,
      builder: (context, state) {
        final matchQuery = <Quiz>[];
        for (final item in state.quiz) {
          if (item.title
              .removeDiacritics()
              .toLowerCase()
              .contains(query.removeDiacritics().toLowerCase())) {
            matchQuery.add(item);
          }
        }
        if (matchQuery.isNotEmpty) {
          return ListView.builder(
            itemCount: matchQuery.length,
            itemBuilder: (context, index) {
              final result = matchQuery[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    context.pushNamed(
                      RouterPath.quizDetail.name,
                      pathParameters: {'id': matchQuery[index].id},
                      extra: matchQuery[index],
                    );
                  },
                  child: ListTile(
                    leading: ImageCover(media: result.media),
                    title: Text(result.title),
                  ),
                ),
              );
            },
          );
        } else {
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppConstant.kPadding / 2,
              horizontal: AppConstant.kPadding,
            ),
            child: Text(l10n.search_quiz_not_found),
          );
        }
      },
    );
  }
}
