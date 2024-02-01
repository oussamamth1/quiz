import 'package:flutter/material.dart';
import 'package:whizz/src/common/constants/constants.dart';

class CustomSquareButton extends StatelessWidget {
  const CustomSquareButton({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.indigo.shade400,
        child: Container(
          padding: const EdgeInsets.all(AppConstant.kPadding),
          child: Column(
            children: [
              Icon(
                icon,
                color: Colors.white,
              ),
              const SizedBox(height: AppConstant.kPadding / 4),
              Text(
                title,
                style: AppConstant.textSubtitle.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
