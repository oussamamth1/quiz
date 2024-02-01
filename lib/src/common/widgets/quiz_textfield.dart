import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/modules/collection/model/quiz_collection.dart';
import 'package:whizz/src/modules/quiz/bloc/quiz_bloc.dart';

class QuizFormField extends StatelessWidget {
  const QuizFormField({
    super.key,
    this.initialValue,
    this.keyboardType,
    this.onChanged,
    this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLines,
    this.maxLength,
    this.label,
    this.controller,
  });

  final String? initialValue;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final String? hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLines;
  final int? maxLength;
  final Widget? label;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(
          AppConstant.kPadding.toDouble() / 2,
        ),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        initialValue: initialValue,
        onChanged: onChanged,
        style: AppConstant.textSubtitle,
        minLines: 1,
        maxLines: maxLines ?? 1,
        maxLength: maxLength,
        decoration: InputDecoration(
          hintText: hintText,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
          label: label,
        ),
      ),
    );
  }
}

class QuizCollectionDropDownField extends StatelessWidget {
  const QuizCollectionDropDownField({
    super.key,
    required this.ctx,
    this.onChanged,
    required this.items,
    this.label,
    this.initialValue,
  });
  final BuildContext ctx;
  final void Function(Object?)? onChanged;
  final Widget? label;

  final List<QuizCollection> items;
  final String? initialValue;

  void checkSaveInitial(BuildContext context) {
    if (initialValue != null) {
      context.read<QuizBloc>().add(OnQuizCollectionChanged(initialValue));
    }
  }

  @override
  Widget build(BuildContext context) {
    checkSaveInitial(context);
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(
          AppConstant.kPadding.toDouble() / 2,
        ),
      ),
      child: DropdownButtonFormField<String>(
        items: items.isNotEmpty
            ? items
                .map<DropdownMenuItem<String>>(
                  (val) => DropdownMenuItem(
                    value: val.id,
                    child: Text(val.name),
                  ),
                )
                .toList()
            : null,
        onChanged: (val) {
          context.read<QuizBloc>().add(OnQuizCollectionChanged(val));
        },
        value: items.isNotEmpty
            ? (initialValue == null
                ? null
                : items
                    .firstWhere((collection) => collection.id == initialValue!)
                    .id)
            : null,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          label: label,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class QuizVisibilityTextField extends StatelessWidget {
  const QuizVisibilityTextField({
    super.key,
    required this.onChanged,
    this.label,
    this.initialValue,
  });

  final void Function(Object?)? onChanged;
  final Widget? label;

  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    final items = <String>[
      'public',
      'private',
    ];

    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(
          AppConstant.kPadding.toDouble() / 2,
        ),
      ),
      child: DropdownButtonFormField<String>(
        items: items.isNotEmpty
            ? items
                .map<DropdownMenuItem<String>>(
                  (val) => DropdownMenuItem(
                    value: val,
                    child: Text(visibility(val, l10n)),
                  ),
                )
                .toList()
            : null,
        onChanged: onChanged,
        value: initialValue ?? items[0],
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          label: label,
          border: InputBorder.none,
        ),
      ),
    );
  }

  String visibility(String item, AppLocalizations l10n) {
    if (item == 'public') {
      return l10n.quiz_public;
    }

    return l10n.quiz_private;
  }
}
