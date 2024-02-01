class SignInWithCredentialException implements Exception {
  const SignInWithCredentialException(
      [this.message = 'An unknown exception occurred.']);

  final String message;

  factory SignInWithCredentialException.fromCode(String code) {
    switch (code) {
      case 'account-exists-with-different-credential':
        return const SignInWithCredentialException(
          'Account exists with different credentials.',
        );
      case 'invalid-credential':
        return const SignInWithCredentialException(
          'The credential received is malformed or has expired.',
        );
      case 'operation-not-allowed':
        return const SignInWithCredentialException(
          'Operation is not allowed. Please contact support.',
        );
      case 'user-disabled':
        return const SignInWithCredentialException(
          'This user has been disabled. Please contact support for help.',
        );
      case 'user-not-found':
        return const SignInWithCredentialException(
          'Email is not found, please create an account.',
        );
      case 'wrong-password':
        return const SignInWithCredentialException(
          'Incorrect password, please try again.',
        );
      case 'invalid-verification-code':
        return const SignInWithCredentialException(
          'The credential verification code received is invalid.',
        );
      case 'invalid-verification-id':
        return const SignInWithCredentialException(
          'The credential verification ID received is invalid.',
        );
      default:
        return const SignInWithCredentialException();
    }
  }
}

class LogoutException implements Exception {}

class VerifyPhoneNumberException implements Exception {
  const VerifyPhoneNumberException(
      [this.message = "An unknown exception occurred."]);

  final String message;

  factory VerifyPhoneNumberException.fromCode(String code) {
    switch (code) {
      case "too-many-requests":
        return const VerifyPhoneNumberException(
            'We have blocked all requests from this device due to unusual activity. Try again later.');
      default:
        return const VerifyPhoneNumberException();
    }
  }
}

class VerifyOtpException implements Exception {
  const VerifyOtpException([this.message = "An unknown exception occured."]);

  final String message;

  factory VerifyOtpException.fromCode(String code) {
    switch (code) {
      case 'invalid-verification-code':
        return const VerifyOtpException(
            'The verification code from SMS/TOTP is invalid. Please check and enter the correct verification code again.');
      default:
        return const VerifyOtpException();
    }
  }
}
