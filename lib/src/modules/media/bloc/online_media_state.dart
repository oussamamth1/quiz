part of 'online_media_bloc.dart';

sealed class OnlineMediaState {
  const OnlineMediaState();
}

base class InitialFetchState implements OnlineMediaState {
  const InitialFetchState();
}

base class LoadingFetchState implements OnlineMediaState {
  const LoadingFetchState();
}

base class SuccessFetchState implements OnlineMediaState {
  const SuccessFetchState(this.photos);

  final List<Photo> photos;
}

base class ErrorFetchState implements OnlineMediaState {
  const ErrorFetchState();
}
