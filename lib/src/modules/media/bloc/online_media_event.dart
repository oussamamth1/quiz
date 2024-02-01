part of 'online_media_bloc.dart';

sealed class OnlineMediaEvent {
  const OnlineMediaEvent();
}

base class GetListPhotosEvent implements OnlineMediaEvent {
  const GetListPhotosEvent();
}

base class PopEvent implements OnlineMediaEvent {
  const PopEvent(this.context, this.callback);

  final BuildContext context;
  final Future<File?> callback;
}

base class SearchPhotoEvent implements OnlineMediaEvent {
  const SearchPhotoEvent(this.query);

  final String query;
}
