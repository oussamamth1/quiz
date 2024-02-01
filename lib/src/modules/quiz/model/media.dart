// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:whizz/src/modules/quiz/model/quiz.dart';

class Media {
  const Media({
    this.imageUrl,
    this.type = AttachType.none,
  });

  final String? imageUrl;
  final AttachType type;

  Media copyWith({
    String? imageUrl,
    AttachType? type,
  }) {
    return Media(
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
    );
  }
}
