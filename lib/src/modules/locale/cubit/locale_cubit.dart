import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'locale_state.dart';

class LocaleCubit extends HydratedCubit<LocaleState> {
  LocaleCubit() : super(const LocaleState());

  void switchLanguege(bool isEn) {
    emit(state.copyWith(
      locale: isEn ? const Locale('en') : const Locale('vi'),
    ));
  }

  @override
  LocaleState? fromJson(Map<String, dynamic> json) {
    return LocaleState(
      locale: Locale(json['value'] as String),
    );
  }

  @override
  Map<String, dynamic>? toJson(LocaleState state) {
    return {'value': state.locale.languageCode};
  }
}
