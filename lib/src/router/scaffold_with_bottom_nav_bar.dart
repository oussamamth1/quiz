import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

import 'package:whizz/src/router/app_router.dart';

class ScaffoldWithBottomNavBar extends StatefulWidget {
  const ScaffoldWithBottomNavBar({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<ScaffoldWithBottomNavBar> createState() =>
      _ScaffoldWithBottomNavBarState();
}

class _ScaffoldWithBottomNavBarState extends State<ScaffoldWithBottomNavBar> {
  int currentIndex = 0;

  void onTap(int index) {
    if (index == currentIndex) {
      return;
    }

    switch (index) {
      case 0:
        context.goNamed(RouterPath.home.name);
        break;
      case 1:
        context.pushNamed(RouterPath.discovery.name);
        break;
      case 2:
        context.pushNamed(RouterPath.play.name);
        break;
      case 3:
        context.pushNamed(RouterPath.quiz.name);
        break;
      case 4:
        context.goNamed(RouterPath.settings.name);
        break;
      default:
        context.goNamed(RouterPath.home.name);
    }

    if (index != 3 && index != 2 && index != 1) {
      setState(() {
        currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Material(
        elevation: 4,
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          onTap: onTap,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: l10n.home,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.explore),
              label: l10n.discovery,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.games),
              label: l10n.play,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.add_circle),
              label: l10n.create,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: l10n.settings,
            ),
          ],
        ),
      ),
    );
  }
}
