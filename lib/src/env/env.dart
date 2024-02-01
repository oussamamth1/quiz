import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static String apiKey = _Env.apiKey;

  @EnviedField(varName: 'API_KEY_SECRET', obfuscate: true)
  static String apiKeySecret = _Env.apiKeySecret;

  @EnviedField(varName: 'UNSPLASH_ACCESS_KEY', obfuscate: true)
  static String unsplashAccessKey = _Env.unsplashAccessKey;

  @EnviedField(varName: 'UNSPLASH_SECRET_KEY', obfuscate: true)
  static String unsplashSecretKey = _Env.unsplashSecretKey;
}
