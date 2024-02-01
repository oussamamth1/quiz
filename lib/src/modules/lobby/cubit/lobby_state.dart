part of 'lobby_cubit.dart';

sealed class LobbyState extends Equatable {
  const LobbyState();

  @override
  List<Object> get props => [];
}

final class LobbyInitial extends LobbyState {}
