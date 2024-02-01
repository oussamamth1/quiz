import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/modules/media/bloc/online_media_bloc.dart';
import 'package:whizz/src/modules/quiz/model/media.dart';
import 'package:whizz/src/modules/quiz/model/quiz.dart';



class MasonryListPhotos extends StatelessWidget {
  const MasonryListPhotos({
    super.key,
    required this.state,
  });

  final SuccessFetchState state;

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.builder(
      itemCount: state.photos.length,
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      mainAxisSpacing: AppConstant.kPadding / 4,
      crossAxisSpacing: AppConstant.kPadding / 4,
      itemBuilder: (context, index) {
        final url = state.photos[index].urls.raw.toString();
        return GestureDetector(
          onTap: () {
            context.pop(Media(
              imageUrl: url,
              type: AttachType.online,
            ));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppConstant.kPadding / 4),
            child: CachedNetworkImage(
              imageUrl: url,
              progressIndicatorBuilder: (context, url, download) {
                if (download.progress != null) {
                  final percent = download.progress! * 100;
                  return Container(
                    alignment: Alignment.center,
                    height: 100,
                    color: Colors.grey.shade300,
                    child: Text('${percent.toInt()}%'),
                  );
                }
                return Container(
                  height: 100,
                  color: Colors.grey.shade300,
                );
              },
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        );
      },
    );
  }
}
