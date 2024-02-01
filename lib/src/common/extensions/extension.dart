import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

extension BuildContextX on BuildContext {
  void showErrorSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: duration ?? const Duration(seconds: 2),
        ),
      );
  }

  void showSuccessSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: duration ?? const Duration(seconds: 2),
        ),
      );
  }

  void hideCurrentSnackbar() {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
  }

  Future<CountryCode?> showCountryPicker() async {
    final FlCountryCodePicker codePicker = FlCountryCodePicker(
      countryTextStyle: TextStyle(
        fontSize: 16.sp,
      ),
      dialCodeTextStyle: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
      ),
    );

    final code = await codePicker.showPicker(
      context: this,
      scrollToDeviceLocale: true,
    );

    return code;
  }

  showConfirmDialog({
    required String title,
    String? description,
    required VoidCallback? onNegativeButton,
    required VoidCallback? onPositiveButton,
  }) {
    AwesomeDialog(
      context: this,
      title: title,
      desc: description,
      animType: AnimType.scale,
      dialogType: DialogType.question,
      btnCancelOnPress: onNegativeButton,
      btnOkOnPress: onPositiveButton,
    ).show();
  }

  void showSuccessDialog({
    required String title,
    String? description,
  }) {
    AwesomeDialog(
      context: this,
      title: title,
      desc: description,
      animType: AnimType.scale,
      dialogType: DialogType.success,
      btnOkOnPress: pop,
    ).show();
  }

  void showInformationDialog({
    required String title,
    String? description,
    required void Function()? btnOkOnPress,
  }) {
    AwesomeDialog(
      context: this,
      title: title,
      desc: description,
      animType: AnimType.scale,
      dialogType: DialogType.info,
      btnOkOnPress: btnOkOnPress,
    ).show();
  }
}

extension DateTimeFormat on int {
  String countDay() {
    final remains =
        DateTime.now().difference(DateTime.fromMillisecondsSinceEpoch(this));

    if (remains.inDays == 0) return 'Today';
    return '${remains.inDays.toString()} days ago';
  }
}

extension DateFormatter on DateTime {
  String format() {
    return DateFormat('yyyy-MM-dd, hh:mm a').format(this);
  }
}

extension F on String {
  String toCapitalize() {
    return replaceAllMapped(RegExp(r'[A-Z]'), (match) => ' ${match.group(0)}')
        .toLowerCase()
        .replaceAllMapped(
          RegExp(r'\b\w'),
          (match) => match.group(0)!.toUpperCase(),
        );
  }

  String removeDiacritics() {
    return replaceAll(RegExp('[àáạảãâầấậẩẫăằắặẳẵ]'), 'a')
        .replaceAll(RegExp('[èéẹẻẽêềếệểễ]'), 'e')
        .replaceAll(RegExp('[ìíịỉĩ]'), 'i')
        .replaceAll(RegExp('[òóọỏõôồốộổỗơờớợởỡ]'), 'o')
        .replaceAll(RegExp('[ùúụủũưừứựửữ]'), 'u')
        .replaceAll(RegExp('[ỳýỵỷỹ]'), 'y')
        .replaceAll(RegExp('[đ]'), 'd');
  }
}
