import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:whizz/src/common/constants/constants.dart';

class RainbowContainer extends StatelessWidget {
  const RainbowContainer({
    super.key,
    this.isPreview = false,
  });

  final bool isPreview;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          // color: Colors.black26,
          borderRadius: const BorderRadius.all(
            Radius.circular(AppConstant.kPadding),
          ),
          gradient: AppConstant.sunsetGradient,
        ),
        child: !isPreview
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.image_outlined),
                  const SizedBox(height: AppConstant.kPadding / 4),
                  Text(l10n.image_cover),
                ],
              )
            : null,
      ),
    );
  }
}
