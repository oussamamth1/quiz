import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import 'package:whizz/src/common/extensions/extension.dart';
import 'package:whizz/src/gen/assets.gen.dart';
import 'package:whizz/src/modules/auth/bloc/auth_bloc.dart';
import 'package:whizz/src/modules/locale/cubit/locale_cubit.dart';
import 'package:whizz/src/router/app_router.dart';
import 'package:whizz/src/screens/settings/enum/menu_title.dart';
import 'package:whizz/src/screens/settings/mockup/settings_mockup.dart';
import 'package:whizz/src/screens/settings/models/menu_setting.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
      ),
      body: ListView.builder(
        itemCount: MenuSettingsMockup.settingsList.length,
        itemBuilder: (context, index) {
          final item = MenuSettingsMockup.settingsList[index];
          if (item.menuType == MenuList.toggle) {
            if (item.title == MenuTitle.language) {
              return BlocBuilder<LocaleCubit, LocaleState>(
                builder: (context, state) {
                  return SwitchListTile(
                    value: state.locale == const Locale('en'),
                    onChanged: (val) {
                      context.read<LocaleCubit>().switchLanguege(val);
                    },
                    title: Text(title(item.title)),
                    secondary: item.prefixIcon,
                    activeThumbImage: Assets.images.enFlag.provider(),
                    inactiveThumbImage: Assets.images.vnFlag.provider(),
                  );
                },
              );
            }
            return SwitchListTile(
              value: false,
              onChanged: (val) {},
              title: Text(title(item.title)),
              secondary: item.prefixIcon,
            );
          } else {
            return ListTile(
              onTap: () => onTap(context, item.title),
              title: Text(title(item.title)),
              leading: item.prefixIcon,
              trailing: const Icon(Icons.arrow_forward_ios),
            );
          }
        },
      ),
    );
  }

  String title(MenuTitle title) {
    final l10n = AppLocalizations.of(context)!;

    switch (title) {
      case MenuTitle.about:
        return l10n.setting_about;
      case MenuTitle.help:
        return l10n.setting_help;
      case MenuTitle.info:
        return l10n.setting_info;
      case MenuTitle.language:
        return l10n.setting_language;
      case MenuTitle.logout:
        return l10n.setting_logout;
      case MenuTitle.mode:
        return l10n.setting_mode;
      case MenuTitle.notifications:
        return l10n.setting_notification;
      default:
        return l10n.app_name;
    }
  }
}

Future<void>? onTap(BuildContext context, MenuTitle index) {
  switch (index) {
    case MenuTitle.logout:
      return context.showConfirmDialog(
        title: 'Are you sure?',
        description: 'Do you want to logout?',
        onNegativeButton: () {},
        onPositiveButton: () => context.read<AuthBloc>().add(const SignOut()),
      );
    case MenuTitle.about:
      return showDialog(
        context: context,
        builder: (context) {
          return const AboutDialog(
            applicationName: 'Quizwhizz',
            applicationVersion: 'version 0.0.1_20230713',
          );
        },
      );
    case MenuTitle.info:
      return context.pushNamed(RouterPath.profile.name);
    default:
      return null;
  }
}
