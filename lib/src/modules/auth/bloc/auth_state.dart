// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

class AuthState extends Equatable {
  const AuthState({
    this.code = const CountryCode(
      name: 'Viet Nam',
      code: 'VN',
      dialCode: '+84',
    ),
    this.message,
    this.isLoading = false,
    this.isError = false,
    this.phoneNumber = '',
  });

  final CountryCode code;
  final String? message;
  final bool isLoading;
  final bool isError;
  final String phoneNumber;

  @override
  List<Object?> get props => [
        code,
        message,
        isLoading,
        isError,
        phoneNumber,
      ];

  AuthState copyWith({
    CountryCode? code,
    String? message,
    bool? isLoading,
    bool? isError,
    String? phoneNumber,
  }) {
    return AuthState(
      code: code ?? this.code,
      message: message ?? this.message,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}
