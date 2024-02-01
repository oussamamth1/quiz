// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'locale_cubit.dart';

class LocaleState extends Equatable {
  const LocaleState({
    this.locale = const Locale('vi'),
  });

  final Locale locale;

  @override
  List<Object> get props => [locale];

  LocaleState copyWith({
    Locale? locale,
  }) {
    return LocaleState(
      locale: locale ?? this.locale,
    );
  }
}
