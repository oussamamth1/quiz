part of 'auth_bloc.dart';

sealed class AuthEvent {
  const AuthEvent();
}

class CountryPickerChanged implements AuthEvent {
  const CountryPickerChanged(this.context);

  final BuildContext context;
}

class OtpVerification implements AuthEvent {
  const OtpVerification(this.pin, this.codeSent);

  final String pin;
  final String codeSent;
}

class SignInWithPhoneNumber implements AuthEvent {
  const SignInWithPhoneNumber(this.context, this.phoneNumber);

  final BuildContext context;
  final String phoneNumber;
}

class SignInWithGoogle implements AuthEvent {
  const SignInWithGoogle();
}

class SignInWithTwitter implements AuthEvent {
  const SignInWithTwitter();
}

class UpdateUser implements AuthEvent {
  const UpdateUser(this.displayName, this.avatar);

  final String displayName;
  final File? avatar;
}

class SignOut implements AuthEvent {
  const SignOut();
}
