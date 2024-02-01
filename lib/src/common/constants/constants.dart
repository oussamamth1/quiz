import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whizz/src/gen/colors.gen.dart';

class AppConstant {
  static const primaryColor = Palettes.darkBrown;

  static final sunsetGradient = LinearGradient(
    colors: [
      const Color(0xFFFFAFBD).withOpacity(.35),
      const Color(0xFFffc3a0).withOpacity(.35),
    ],
  );

  static const kPadding = 16.0;

  static TextStyle textTitle700 = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 16.sp,
  );

  static final textHeading = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 20.sp,
  );

  static final textSubtitle = TextStyle(
    fontSize: 12.sp,
  );
}

final class FirebaseDocumentConstants {
  static const user = 'User';
  static const quiz = 'Quiz';
  static const collection = 'Collection';
  static const lobby = 'Lobby';
  static const lobbyParticipant = 'Participants';
  static const save = 'Bookmark';
  static const collectionInfo = 'Info';
}
