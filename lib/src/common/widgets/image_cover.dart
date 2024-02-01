import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/widgets/shared_widget.dart';
import 'package:whizz/src/modules/quiz/model/media.dart';
import 'package:whizz/src/modules/quiz/model/quiz.dart';

class ImageCover extends StatelessWidget {
  const ImageCover({
    super.key,
    required this.media,
    this.isPreview = false,
  });

  final Media media;
  final bool isPreview;

  @override
  Widget build(BuildContext context) {
    return switch (media.type) {
      AttachType.online => AspectRatio(
          aspectRatio: 4 / 3,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              // color: Colors.black26,
              borderRadius: const BorderRadius.all(
                Radius.circular(AppConstant.kPadding),
              ),
              gradient: AppConstant.sunsetGradient,
              image: DecorationImage(
                image: CachedNetworkImageProvider(media.imageUrl!),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      AttachType.local => AspectRatio(
          aspectRatio: 4 / 3,
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              // color: Colors.black26,
              borderRadius: const BorderRadius.all(
                Radius.circular(AppConstant.kPadding),
              ),
              gradient: AppConstant.sunsetGradient,
              image: DecorationImage(
                image: FileImage(File(media.imageUrl!)),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      _ => RainbowContainer(isPreview: isPreview),
    };
  }
}
