import 'package:flutter/material.dart';
import 'package:whizz/src/screens/settings/enum/menu_title.dart';
import 'package:whizz/src/screens/settings/models/menu_setting.dart';

class MenuSettingsMockup {
  static const settingsList = <MenuSetting>[
    MenuSetting(
      title: MenuTitle.info,
      prefixIcon: Icon(
        Icons.person_4,
      ),
    ),
    // MenuSetting(
    //   title: MenuTitle.notifications,
    //   prefixIcon: Icon(
    //     Icons.notifications,
    //   ),
    // ),
    // MenuSetting(
    //   title: MenuTitle.mode,
    //   menuType: MenuList.toggle,
    //   prefixIcon: Icon(
    //     Icons.dark_mode,
    //   ),
    // ),
    MenuSetting(
      title: MenuTitle.language,
      menuType: MenuList.toggle,
      prefixIcon: Icon(
        Icons.language,
      ),
    ),
    MenuSetting(
      title: MenuTitle.about,
      prefixIcon: Icon(
        Icons.info,
      ),
    ),
    MenuSetting(
      title: MenuTitle.help,
      prefixIcon: Icon(
        Icons.help,
      ),
    ),
    MenuSetting(
      title: MenuTitle.logout,
      prefixIcon: Icon(
        Icons.logout,
      ),
    ),
  ];
}
