import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/widgets/shared_widget.dart';
import 'package:whizz/src/gen/assets.gen.dart';
import 'package:whizz/src/modules/collection/cubit/quiz_collection_cubit.dart';
import 'package:whizz/src/modules/collection/model/quiz_collection.dart';
import 'package:whizz/src/modules/quiz/model/quiz.dart';
import 'package:whizz/src/router/app_router.dart';

class DiscoveryDetailScreen extends StatelessWidget {
  const DiscoveryDetailScreen({
    super.key,
    required this.quizCollection,
  });

  final QuizCollection quizCollection;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(quizCollection.name),
      ),
      body: FutureBuilder<List<Quiz>>(
        future: context
            .read<QuizCollectionCubit>()
            .onGetQuizByCollectionId(quizCollection.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (snapshot.data!.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    context.pushNamed(
                      RouterPath.quizDetail.name,
                      pathParameters: {'id': snapshot.data![index].id},
                      extra: snapshot.data![index],
                    );
                  },
                  child: ListTile(
                    leading: ImageCover(
                      media: snapshot.data![index].media,
                      isPreview: true,
                    ),
                    title: Text(
                      snapshot.data![index].title,
                      style: AppConstant.textTitle700,
                    ),
                    subtitle: Text(snapshot.data![index].author.name ?? ''),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Assets.images.empty.lottie(
                    height: .25.sh,
                  ),
                  Text(
                    l10n.discovery_empty,
                    style: AppConstant.textTitle700,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(
            RouterPath.quiz.name,
            extra: quizCollection.id,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
