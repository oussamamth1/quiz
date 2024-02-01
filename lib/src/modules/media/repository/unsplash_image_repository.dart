import 'package:unsplash_client/unsplash_client.dart';
import 'package:whizz/src/common/utils/debouncer.dart';
import 'package:whizz/src/env/env.dart';

class UnsplashImageRepository {
  UnsplashImageRepository({
    Debouncer? debouncer,
  }) : _debouncer = debouncer ?? Debouncer();

  final Debouncer _debouncer;

  Future<List<Photo>> loadImages() async {
    final client = UnsplashClient(
      settings: ClientSettings(
        credentials: AppCredentials(
          accessKey: Env.unsplashAccessKey,
          secretKey: Env.unsplashSecretKey,
        ),
      ),
    );
    final photos = await client.photos
        .list(
          page: 1,
          perPage: 10,
        )
        .goAndGet();
    client.close();
    return photos;
  }

  Future<List<Photo>> _searchImage(String query) async {
    final client = UnsplashClient(
      settings: ClientSettings(
        credentials: AppCredentials(
          accessKey: Env.unsplashAccessKey,
          secretKey: Env.unsplashSecretKey,
        ),
      ),
    );
    final photos = await client.search
        .photos(
          query.trim(),
          page: 1,
          perPage: 30,
        )
        .goAndGet();
    return photos.results;
  }

  Future<List<Photo>> searchImage(String query) async {
    return _debouncer.debounce(
      callback: _searchImage,
      args: [query],
    );
  }
}
