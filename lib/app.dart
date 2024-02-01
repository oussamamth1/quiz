import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:whizz/src/common/constants/constants.dart';
import 'package:whizz/src/gen/fonts.gen.dart';
import 'package:whizz/src/modules/auth/bloc/auth_bloc.dart';
import 'package:whizz/src/modules/collection/cubit/quiz_collection_cubit.dart';
import 'package:whizz/src/modules/lobby/cubit/lobby_cubit.dart';
import 'package:whizz/src/modules/locale/cubit/locale_cubit.dart';
import 'package:whizz/src/modules/media/bloc/online_media_bloc.dart';
import 'package:whizz/src/modules/profile/cubit/profile_cubit.dart';
import 'package:whizz/src/router/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => OnlineMediaBloc()..add(const GetListPhotosEvent())),
        BlocProvider(create: (_) => QuizCollectionCubit()),
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => LobbyCubit()),
        BlocProvider(create: (_) => LocaleCubit()),
        BlocProvider(create: (_) => ProfileCubit()),
      ],
      child: ScreenUtilInit(
        builder: (context, child) => BlocBuilder<LocaleCubit, LocaleState>(
          builder: (context, state) {
            return MaterialApp.router(
              title: 'Quizwhizz',
              debugShowCheckedModeBanner: false,
              routeInformationProvider:
                  AppRouter.router.routeInformationProvider,
              routeInformationParser: AppRouter.router.routeInformationParser,
              routerDelegate: AppRouter.router.routerDelegate,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: state.locale,
              theme: ThemeData(
                fontFamily: FontFamily.montserrat,
                colorScheme: ColorScheme.fromSeed(
                  seedColor: AppConstant.primaryColor,
                ),
                useMaterial3: true,
                platform: TargetPlatform.iOS,
              ),
            );
          },
        ),
      ),
    );
  }
}
