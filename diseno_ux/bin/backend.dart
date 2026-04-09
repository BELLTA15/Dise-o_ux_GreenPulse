import 'package:diseno_ux/backend/server.dart';

Future<void> main() async {
  try {
    await startBackend();
  } catch (error, stackTrace) {
    print('Error iniciando backend: $error');
    print(stackTrace);
    rethrow;
  }
}
