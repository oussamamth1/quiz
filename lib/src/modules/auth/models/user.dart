// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppUser extends Equatable {
  const AppUser({
    required this.id,
    this.email,
    this.name,
    this.avatar,
    this.phoneNumber,
  });

  final String id;
  final String? email;
  final String? name;
  final String? avatar;
  final String? phoneNumber;

  /// Empty user which represents an unauthenticated user
  static const empty = AppUser(id: '');

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != empty;

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        avatar,
        phoneNumber,
      ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
      'avatar': avatar,
      'phoneNumber': phoneNumber,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      id: map['id'] as String,
      email: map['email'] != null ? map['email'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      avatar: map['avatar'] != null ? map['avatar'] as String : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source) as Map<String, dynamic>);

  AppUser copyWith({
    String? id,
    String? email,
    String? name,
    String? avatar,
    String? phoneNumber,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }
}

extension FirebaseUser on User {
  /// Maps a [firebase_auth.User] into a [User].
  AppUser get toUser {
    return AppUser(
      id: uid,
      email: email,
      name: displayName,
      avatar: photoURL,
      phoneNumber: phoneNumber,
    );
  }
}
