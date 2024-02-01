import 'package:flutter/material.dart';

class CreateOptionsPopupMenu extends StatelessWidget {
  const CreateOptionsPopupMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_horiz),
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            child: Text('Import from CSV'),
          ),
        ];
      },
    );
  }
}
