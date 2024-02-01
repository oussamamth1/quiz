// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  const ProfileState({
    this.user = AppUser.empty,
    this.quizzies = const [],
    this.save = const [],
    this.collections = const [],
    this.isLoading = false,
  });

  final AppUser user;
  final List<Quiz> quizzies;
  final List<Quiz> save;
  final List<QuizCollection> collections;
  final bool isLoading;

  @override
  List<Object?> get props => [
        user,
        quizzies,
        save,
        isLoading,
        collections,
      ];

  ProfileState copyWith({
    AppUser? user,
    List<Quiz>? quizzies,
    List<Quiz>? save,
    List<QuizCollection>? collections,
    bool? isLoading,
  }) {
    return ProfileState(
      user: user ?? this.user,
      quizzies: quizzies ?? this.quizzies,
      save: save ?? this.save,
      collections: collections ?? this.collections,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
