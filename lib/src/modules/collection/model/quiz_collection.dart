// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class QuizCollection extends Equatable {
  const QuizCollection({
    required this.id,
    required this.name,
    this.imageUrl,
    this.quantity = 0,
    this.isVibility,
    this.owner,
  });

  final String id;
  final String name;
  final String? imageUrl;
  final int quantity;
  final bool? isVibility;
  final String? owner;

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
        quantity,
        isVibility,
        owner,
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'quantity': quantity,
      if (isVibility != null) 'isVibility': isVibility,
      if (owner != null) 'owner': owner,
    };
  }

  factory QuizCollection.fromMap(Map<String, dynamic> map) {
    return QuizCollection(
      id: map['id'] as String,
      name: map['name'] as String,
      imageUrl: map['imageUrl'] != null ? map['imageUrl'] as String : null,
      // quantity: map['quantity'] as int,
      quantity: map.containsKey('quantity') ? map['quantity'] as int : 0,
      isVibility:
          map.containsKey('isVisibity') ? map['isVibility'] as bool : null,
      owner: map.containsKey('owner') ? map['owner'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory QuizCollection.fromJson(String source) =>
      QuizCollection.fromMap(json.decode(source) as Map<String, dynamic>);
}
