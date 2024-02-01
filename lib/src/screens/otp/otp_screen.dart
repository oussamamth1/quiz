import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/common/extensions/extension.dart';
import 'package:whizz/src/common/widgets/custom_button.dart';
import 'package:whizz/src/modules/auth/bloc/auth_bloc.dart';

class OtpScreen extends HookWidget {
  const OtpScreen({super.key, required this.codeSent});

  final (String, int) codeSent;

  @override
  Widget build(BuildContext context) {
    final pinController = useTextEditingController(text: '');
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.isError) {
            context.showErrorSnackBar(state.message!);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(AppConstant.kPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.user_enter_otp,
                style: AppConstant.textHeading,
              ),
              Text(
                l10n.otp_hint_text,
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return Text(
                    '${state.code.dialCode}${state.phoneNumber}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  );
                },
              ),
              SizedBox(
                height: 16.h,
              ),
              SizedBox(
                width: 1.sw - (AppConstant.kPadding * 2),
                child: Pinput(
                  controller: pinController,
                  length: 6,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Text(l10n.otp_expired),
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 60, end: 0),
                    duration: const Duration(seconds: 60),
                    builder: (context, value, child) {
                      return Text(
                        '${value.toInt()}s',
                        style: const TextStyle(
                          color: Colors.red,
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(
                height: AppConstant.kPadding.h / 2,
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return state.isLoading
                      ? LoadingButton(label: l10n.authenticating)
                      : CustomButton(
                          onPressed: () => context.read<AuthBloc>().add(
                                OtpVerification(
                                  pinController.text,
                                  codeSent.$1,
                                ),
                              ),
                          label: l10n.continue_text,
                        );
                },
              ),
              SizedBox(
                height: 16.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
