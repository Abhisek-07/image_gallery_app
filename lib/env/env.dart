import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
final class Env {
  @EnviedField(
    varName: 'PIXABAY_API_KEY',
    obfuscate: true,
  )
  static final String pixabayApiKey = _Env.pixabayApiKey;
}
