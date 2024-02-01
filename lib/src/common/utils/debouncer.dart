import 'dart:async';

class Debouncer {
  final Duration duration;
  Timer? _timer;

  Debouncer({
    this.duration = const Duration(milliseconds: 500),
  });

  Future<T> debounce<T>({
    required Function callback,
    required List<dynamic> args,
  }) async {
    if (_timer != null) {
      _timer!.cancel();
    }
    final completer = Completer<T>();
    _timer = Timer(duration, () async {
      final result = await Function.apply(callback, args);
      completer.complete(result);
    });
    return completer.future;
  }
}
