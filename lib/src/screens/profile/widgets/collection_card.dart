import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/modules/collection/model/quiz_collection.dart';

class DiscoveryCard extends StatelessWidget {
  const DiscoveryCard({
    super.key,
    required this.collection,
    this.onTap,
  });

  final QuizCollection collection;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: Container(
                decoration: collection.imageUrl != null
                    ? BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius:
                            BorderRadius.circular(AppConstant.kPadding),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            collection.imageUrl!,
                          ),
                          fit: BoxFit.cover,
                        ),
                      )
                    : BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(AppConstant.kPadding),
                        color: Colors.grey[200],
                      ),
              ),
            ),
          ),
          const SizedBox(
            width: AppConstant.kPadding / 2,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  collection.name,
                  style: AppConstant.textTitle700,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
