import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whizz/src/common/extensions/extension.dart';
import 'package:whizz/src/modules/auth/exception/auth_exception.dart';
import 'package:whizz/src/modules/auth/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({AuthenticationRepository? repository})
      : _repository = repository ?? AuthenticationRepository(),
        super(const AuthState()) {
    on(_onLoginWithGoogle);
    on(_onLoginWithTwitter);
    on(_onLoginWithPhoneNumber);
    on(_onPhoneNumberInformationChanged);
    on(_onVerifyOtp);
    on(_onUpdateUser);
    on(_onLogout);
  }

  final AuthenticationRepository _repository;

  void _onLoginWithGoogle(
    SignInWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      isError: false,
    ));
    try {
      await _repository.loginWithGoogle();
      emit(state.copyWith(isLoading: false));
    } on SignInWithCredentialException catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isError: true,
        message: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isError: true,
        message: e.toString(),
      ));
    }
  }

  void _onLoginWithTwitter(
    SignInWithTwitter event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      isError: false,
    ));
    try {
      await _repository.loginWithTwitter();
      emit(state.copyWith(isLoading: false));
    } on SignInWithCredentialException catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isError: true,
        message: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isError: true,
        message: e.toString(),
      ));
    }
  }

  void _onLoginWithPhoneNumber(
    SignInWithPhoneNumber event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final phoneNumber = '${state.code.dialCode}${event.phoneNumber}';
      FocusManager.instance.primaryFocus?.unfocus();
      event.context.showSuccessSnackBar(
        'Chúng tôi đang kiểm tra thông tin của bạn... Vui lòng đợi trong giây lát!',
        duration: const Duration(minutes: 1),
      );
      emit(state.copyWith(
        isLoading: true,
        phoneNumber: event.phoneNumber,
      ));
      await _repository.loginWithPhoneNumber(event.context, phoneNumber, () {
        emit(state.copyWith(
          isLoading: false,
        ));
      });
    } on VerifyPhoneNumberException catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isError: true,
        message: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isError: true,
        message: e.toString(),
      ));
    }
  }

  void _onPhoneNumberInformationChanged(
    CountryPickerChanged event,
    Emitter<AuthState> emit,
  ) async {
    final context = event.context;

    await context.showCountryPicker().then((code) {
      if (code != null) {
        emit(state.copyWith(code: code));
      }
    });
  }

  void _onVerifyOtp(
    OtpVerification event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(
      isError: false,
      isLoading: true,
    ));
    try {
      await _repository.verifyOtp(event.codeSent, event.pin);
      emit(state.copyWith(isLoading: false));
    } on VerifyOtpException catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isError: true,
        message: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isError: true,
        message: e.toString(),
      ));
    }
  }

  void _onUpdateUser(
    UpdateUser event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(
      isLoading: true,
      isError: false,
      message: null,
    ));
    try {
      await _repository.updateUser(event.displayName, event.avatar);
      emit(state.copyWith(isLoading: false));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isError: true,
        message: e.toString(),
      ));
    }
  }

  void _onLogout(
    SignOut event,
    Emitter<AuthState> emit,
  ) async {
    await _repository.logout();
    emit(const AuthState());
  }
}
