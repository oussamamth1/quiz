import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:whizz/src/modules/auth/models/user.dart';
import 'package:whizz/src/modules/auth/repository/auth_repository.dart';
import 'package:whizz/src/modules/collection/model/quiz_collection.dart';
import 'package:whizz/src/modules/play/cubit/play_cubit.dart';
import 'package:whizz/src/modules/profile/cubit/profile_cubit.dart';
import 'package:whizz/src/modules/quiz/bloc/quiz_bloc.dart';
import 'package:whizz/src/modules/quiz/cubit/list_quiz_cubit.dart';
import 'package:whizz/src/modules/quiz/model/quiz.dart';
import 'package:whizz/src/router/scaffold_with_bottom_nav_bar.dart';
import 'package:whizz/src/screens/discovery/discovery_screen.dart';
import 'package:whizz/src/screens/discovery_create/discovery_create_screen.dart';
import 'package:whizz/src/screens/discovery_detail/discovery_detail_screen.dart';
import 'package:whizz/src/screens/discovery_save/discovery_save_screen.dart';
import 'package:whizz/src/screens/home/home_screen.dart';
import 'package:whizz/src/screens/login/login_screen.dart';
import 'package:whizz/src/screens/media/media_screen.dart';
import 'package:whizz/src/screens/otp/otp_screen.dart';
import 'package:whizz/src/screens/phone_number_profile/phone_number_profile_screen.dart';
import 'package:whizz/src/screens/play/lobby_screen.dart';
import 'package:whizz/src/screens/play/play_screen.dart';
import 'package:whizz/src/screens/play_quiz/play_quiz_screen.dart';
import 'package:whizz/src/screens/profile/profile_edit_screen.dart';
import 'package:whizz/src/screens/profile/profile_screen.dart';
import 'package:whizz/src/screens/question_create/create_question_screen.dart';
import 'package:whizz/src/screens/quiz_create/create_quiz_screen.dart';
import 'package:whizz/src/screens/quiz_detail/quiz_detail_screen.dart';
import 'package:whizz/src/screens/quiz_edit/edit_quiz_screen.dart';
import 'package:whizz/src/screens/settings/settings_screen.dart';

enum RouterPath {
  home,
  login,
  otp,
  lobby,
  discovery,
  discoveryCreate,
  discoveryDetail,
  discoverySave,
  play,
  quiz,
  quizDetail,
  quizEdit,
  question,
  media,
  unsplash,
  settings,
  noConnection,
  error,
  profile,
  profileEdit,
  playQuiz,
  phone,
}

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static final _authRepo = AuthenticationRepository();

  static final GoRouter _router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/login',
    navigatorKey: _rootNavigatorKey,
    redirect: (context, state) {
      final isLoggedIn = _authRepo.currentUser != AppUser.empty;
      final isPhone = _authRepo.currentUser.name == null;
      if (isLoggedIn) {
        if (isPhone) {
          return '/phone';
        }
        if (state.matchedLocation == '/login') {
          return '/home';
        }
      } else {
        if (state.matchedLocation == '/home' ||
            state.matchedLocation == '/settings') {
          return '/login';
        }
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(_authRepo.user),
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return ScaffoldWithBottomNavBar(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: RouterPath.home.name,
            pageBuilder: (_, state) => NoTransitionPage(
              key: state.pageKey,
              child: BlocProvider(
                create: (_) => ListQuizCubit(),
                child: const HomeScreen(),
              ),
            ),
          ),
          GoRoute(
            path: '/settings',
            name: RouterPath.settings.name,
            pageBuilder: (_, state) => NoTransitionPage(
              key: state.pageKey,
              child: const SettingsScreen(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/discovery',
        name: RouterPath.discovery.name,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (_, state) => NoTransitionPage(
          key: state.pageKey,
          child: const DiscoveryScreen(),
        ),
      ),
      GoRoute(
        path: '/play',
        name: RouterPath.play.name,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (_, state) => NoTransitionPage(
          key: state.pageKey,
          child: const PlayScreen(),
        ),
        routes: [
          GoRoute(
            path: ':id',
            name: RouterPath.playQuiz.name,
            parentNavigatorKey: _rootNavigatorKey,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: BlocProvider(
                create: (context) => GameCubit(),
                child: PlayQuizScreen(
                  quiz: (state.extra! as Map)['quiz'] as Quiz,
                  isSoloMode:
                      (state.extra! as Map)['isSoloMode'] as bool? ?? true,
                ),
              ),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/quiz',
        name: RouterPath.quiz.name,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (_, state) => MaterialPage(
          key: state.pageKey,
          child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => QuizBloc(),
              ),
            ],
            child: CreateQuizScreen(
              collectionId: state.extra as String?,
            ),
          ),
        ),
        routes: [
          GoRoute(
            path: ':id',
            name: RouterPath.quizDetail.name,
            parentNavigatorKey: _rootNavigatorKey,
            pageBuilder: (context, state) => MaterialPage(
              key: state.pageKey,
              child: QuestionDetailScreen(
                quiz: state.extra! as Quiz,
              ),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/quiz_edit',
        name: RouterPath.quizEdit.name,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (_, state) => MaterialPage(
          key: state.pageKey,
          child: BlocProvider.value(
            value: state.extra! as QuizBloc,
            child: const EditQuizScreen(),
          ),
        ),
      ),
      GoRoute(
        path: '/question',
        name: RouterPath.question.name,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (_, state) => MaterialPage(
          key: state.pageKey,
          child: BlocProvider.value(
            value: state.extra! as QuizBloc,
            child: const CreateQuestionScreen(),
          ),
        ),
      ),
      GoRoute(
        path: '/media',
        name: RouterPath.media.name,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (_, state) => MaterialPage(
          key: state.pageKey,
          child: const MediaScreen(),
        ),
      ),
      GoRoute(
        path: '/login',
        name: RouterPath.login.name,
        pageBuilder: (_, state) => MaterialPage(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/phone',
        name: RouterPath.phone.name,
        pageBuilder: (_, state) => MaterialPage(
          key: state.pageKey,
          child: const PhoneNumberProfileScreen(),
        ),
      ),
      GoRoute(
        path: '/otp',
        name: RouterPath.otp.name,
        pageBuilder: (_, state) => MaterialPage(
          key: state.pageKey,
          child: OtpScreen(
            codeSent: state.extra as (String, int),
          ),
        ),
      ),
      GoRoute(
        path: '/profile',
        name: RouterPath.profile.name,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (_, state) => MaterialPage(
          key: state.pageKey,
          child: MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => ProfileCubit()),
              BlocProvider(create: (_) => QuizBloc()),
            ],
            child: const ProfileScreen(),
          ),
        ),
      ),
      GoRoute(
        path: '/edit_profile',
        name: RouterPath.profileEdit.name,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (_, state) => MaterialPage(
          key: state.pageKey,
          child: BlocProvider.value(
            value: state.extra! as ProfileCubit,
            child: const EditProfileScreen(),
          ),
        ),
      ),
      GoRoute(
        path: '/discovery_detail',
        name: RouterPath.discoveryDetail.name,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (_, state) => MaterialPage(
          key: state.pageKey,
          child: DiscoveryDetailScreen(
            quizCollection: state.extra! as QuizCollection,
          ),
        ),
      ),
      GoRoute(
        path: '/discovery_create',
        name: RouterPath.discoveryCreate.name,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (_, state) => MaterialPage(
          key: state.pageKey,
          child: const DiscoveryCreateScreen(),
        ),
      ),
      GoRoute(
        path: '/discovery_save',
        name: RouterPath.discoverySave.name,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (_, state) => MaterialPage(
          key: state.pageKey,
          child: DiscoverySaveScreen(
            collection: (state.extra! as Map)['collection'] as QuizCollection,
            quizzies: (state.extra as Map)['quizzies'] as List<Quiz>,
          ),
        ),
      ),
      GoRoute(
        path: '/lobby',
        name: RouterPath.lobby.name,
        parentNavigatorKey: _rootNavigatorKey,
        pageBuilder: (_, state) => MaterialPage(
          key: state.pageKey,
          child: LobbyScreen(
            isSoloMode: state.extra as bool? ?? true,
          ),
        ),
      ),
    ],
  );

  static GoRouter get router => _router;
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
