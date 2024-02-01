import 'package:flutter/material.dart';
import 'package:whizz/src/common/constants/constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.backgroundColor,
    this.color,
  });

  final void Function()? onPressed;
  final String label;
  final Color? backgroundColor;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppConstant.primaryColor,
        minimumSize: const Size.fromHeight(40),
      ),
      child: FittedBox(
        child: Text(
          label,
          style: TextStyle(
            color: color ?? Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class LoadingButton extends StatelessWidget {
  const LoadingButton({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: null,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppConstant.primaryColor,
        minimumSize: const Size.fromHeight(40),
      ),
      icon: const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
      label: FittedBox(
        child: Text(
          label,
          style: AppConstant.textTitle700,
        ),
      ),
    );
  }
}
