import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';

import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/extensions/extension.dart';
import 'package:whizz/src/common/widgets/custom_button.dart';
import 'package:whizz/src/common/widgets/image_cover.dart';
import 'package:whizz/src/common/widgets/quiz_textfield.dart';
import 'package:whizz/src/modules/collection/cubit/quiz_collection_cubit.dart';
import 'package:whizz/src/modules/quiz/model/media.dart';
import 'package:whizz/src/router/app_router.dart';

class DiscoveryCreateScreen extends HookWidget {
  const DiscoveryCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final media = useState(const Media());
    final nameController = useTextEditingController();
    final isVisible = useState(true);
    final isLoading = useState(false);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(l10n.collection_create_heading),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: WillPopScope(
        child: Padding(
          padding: const EdgeInsets.all(AppConstant.kPadding),
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    final result =
                        await context.pushNamed<Media>(RouterPath.media.name);
                    if (result?.imageUrl != null) {
                      media.value = result!;
                    }
                  },
                  child: ImageCover(media: media.value),
                ),
                const SizedBox(
                  height: AppConstant.kPadding / 2,
                ),
                QuizFormField(
                  controller: nameController,
                  hintText: l10n.quiz_name,
                  maxLength: 50,
                ),
                const SizedBox(
                  height: AppConstant.kPadding / 2,
                ),
                QuizVisibilityTextField(
                  label: Text(l10n.quiz_visibility),
                  onChanged: (val) {
                    isVisible.value = (val as String) == 'public';
                  },
                ),
              ],
            ),
          ),
        ),
        onWillPop: () async => false,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(AppConstant.kPadding),
        child: !isLoading.value
            ? CustomButton(
                onPressed: () {
                  isLoading.value = true;
                  context
                      .read<QuizCollectionCubit>()
                      .onCreateNewCollection(
                        name: nameController.text,
                        media: media.value,
                        isPublic: isVisible.value,
                      )
                      .then((_) {
                    context.showSuccessDialog(title: l10n.quiz_save_action);
                    isLoading.value = false;
                  });
                },
                label: 'Create',
              )
            : const LoadingButton(label: 'Loading'),
      ),
    );
  }
}
