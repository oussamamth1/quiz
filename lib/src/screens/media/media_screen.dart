import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/utils/pick_image.dart';

import 'package:whizz/src/modules/media/bloc/online_media_bloc.dart';
import 'package:whizz/src/screens/media/widgets/custom_square_button.dart';
import 'package:whizz/src/screens/media/widgets/masonry_list_photo.dart';

class MediaScreen extends HookWidget {
  const MediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = useTextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add media'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppConstant.kPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomSquareButton(
                  onTap: () => context
                      .read<OnlineMediaBloc>()
                      .add(PopEvent(context, PickImage.pickImage())),
                  title: 'Gallery',
                  icon: Icons.image_outlined,
                ),
                CustomSquareButton(
                  onTap: () => context
                      .read<OnlineMediaBloc>()
                      .add(PopEvent(context, PickImage.takePhoto())),
                  title: 'Camera',
                  icon: Icons.camera_alt_outlined,
                ),
              ],
            ),
            const SizedBox(
              height: AppConstant.kPadding,
            ),
            SearchImageTextField(
              controller: searchController,
            ),
            const SizedBox(
              height: AppConstant.kPadding,
            ),
            BlocBuilder<OnlineMediaBloc, OnlineMediaState>(
              builder: (context, state) {
                return switch (state) {
                  LoadingFetchState() => const Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  SuccessFetchState() => Expanded(
                      child: MasonryListPhotos(
                        state: state,
                      ),
                    ),
                  _ => Container(
                      height: 100,
                    ),
                };
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SearchImageTextField extends StatefulWidget {
  const SearchImageTextField({
    super.key,
    this.controller,
  });

  final TextEditingController? controller;

  @override
  State<SearchImageTextField> createState() => _SearchImageTextFieldState();
}

class _SearchImageTextFieldState extends State<SearchImageTextField> {
  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(_searchImage);
  }

  void _searchImage() {
    final query = widget.controller?.text ?? '';
    if (query.isEmpty) {
      context.read<OnlineMediaBloc>().add(const GetListPhotosEvent());
    } else {
      context.read<OnlineMediaBloc>().add(SearchPhotoEvent(query));
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        isDense: true,
        suffixIcon: IconButton(
          onPressed: () {
            widget.controller?.clear();
          },
          icon: const Icon(Icons.clear),
        ),
        border: const OutlineInputBorder(),
        hintText: 'Search image',
      ),
    );
  }
}
