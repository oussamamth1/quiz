import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/extensions/extension.dart';
import 'package:whizz/src/common/utils/pick_image.dart';
import 'package:whizz/src/common/widgets/custom_button.dart';
import 'package:whizz/src/gen/assets.gen.dart';
import 'package:whizz/src/modules/profile/cubit/profile_cubit.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController controller;
  File? image;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  void changeAvatar() async {
    image = await PickImage.pickImage();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(AppConstant.kPadding),
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 0.06.sh,
                        backgroundColor: Colors.grey.shade800,
                        backgroundImage: image == null
                            ? state.user.avatar != null
                                ? CachedNetworkImageProvider(state.user.avatar!)
                                : Assets.images.unknownUser.provider()
                            : FileImage(image!),
                      ),
                      Positioned(
                        bottom: -5,
                        right: -5,
                        child: IconButton(
                          onPressed: changeAvatar,
                          icon: Container(
                            padding:
                                const EdgeInsets.all(AppConstant.kPadding / 2),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(
                                  AppConstant.kPadding / 2),
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 16.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: AppConstant.kPadding * 2,
                ),
                Builder(builder: (context) {
                  controller.text = state.user.name!;
                  return TextFormField(
                    controller: controller,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.people),
                      isDense: true,
                      border: const OutlineInputBorder(),
                      label: Text(l10n.user_display_name),
                    ),
                  );
                }),
                const SizedBox(
                  height: AppConstant.kPadding,
                ),
                TextFormField(
                  initialValue: state.user.email,
                  enabled: false,
                  onChanged: (val) {},
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.people),
                    isDense: true,
                    border: OutlineInputBorder(),
                    label: Text('Email'),
                  ),
                ),
                const SizedBox(
                  height: AppConstant.kPadding,
                ),
                TextFormField(
                  initialValue: state.user.phoneNumber,
                  enabled: false,
                  onChanged: (val) {},
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.people),
                    isDense: true,
                    border: const OutlineInputBorder(),
                    label: Text(l10n.user_phone_number),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.all(AppConstant.kPadding),
            child: state.isLoading
                ? const LoadingButton(label: 'Loading')
                : CustomButton(
                    onPressed: () {
                      context
                          .read<ProfileCubit>()
                          .onEditProfile(controller.text, image);
                      context.showSuccessSnackBar('Update successfully');
                      context.pop();
                    },
                    label: 'Save',
                  ),
          );
        },
      ),
    );
  }
}
