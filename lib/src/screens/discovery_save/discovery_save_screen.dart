import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/widgets/shared_widget.dart';
import 'package:whizz/src/gen/assets.gen.dart';
import 'package:whizz/src/modules/collection/model/quiz_collection.dart';
import 'package:whizz/src/modules/quiz/model/quiz.dart';
import 'package:whizz/src/router/app_router.dart';

class DiscoverySaveScreen extends StatelessWidget {
  const DiscoverySaveScreen({
    super.key,
    required this.collection,
    required this.quizzies,
  });

  final QuizCollection collection;
  final List<Quiz> quizzies;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(collection.name),
      ),
      body: quizzies.isNotEmpty
          ? ListView.builder(
              itemCount: quizzies.length,
              itemBuilder: (context, index) {
                final quiz = quizzies[index];
                return GestureDetector(
                  onTap: () {
                    context.pushNamed(
                      RouterPath.quizDetail.name,
                      pathParameters: {'id': quiz.id},
                      extra: quiz,
                    );
                  },
                  child: ListTile(
                    leading: ImageCover(
                      media: quiz.media,
                      isPreview: true,
                    ),
                    title: Text(
                      quiz.title,
                      style: AppConstant.textTitle700,
                    ),
                    subtitle: Text(quiz.author.name ?? ''),
                  ),
                );
              },
            )
          : Center(
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
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.pushNamed(
            RouterPath.quiz.name,
            extra: collection.id,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
