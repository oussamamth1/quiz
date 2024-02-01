import 'package:flutter/widgets.dart';
import 'package:whizz/src/screens/settings/enum/menu_title.dart';

class MenuSetting {
  const MenuSetting({
    this.prefixIcon,
    required this.title,
    this.description,
    this.menuType = MenuList.more,
  });

  final Widget? prefixIcon;
  final MenuTitle title;
  final String? description;
  final MenuList menuType;
}

enum MenuList {
  more,
  toggle,
}
