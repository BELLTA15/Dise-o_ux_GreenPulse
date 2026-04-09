import 'env.dart';
import 'mysql_compat.dart';

Future<MySqlConnection> openDatabaseConnection() {
  final settings = ConnectionSettings(
    host: envOrThrow('DB_HOST'),
    port: int.tryParse(backendEnv['DB_PORT'] ?? '3306') ?? 3306,
    db: envOrThrow('DB_NAME'),
    user: envOrThrow('DB_USER'),
    password: envOrThrow('DB_PASSWORD'),
    secure: false,
  );

  return MySqlConnection.connect(settings);
}

Future<bool> initializeDatabase() async {
  try {
    final connection = await openDatabaseConnection();
    await connection.query('SELECT 1');
    await connection.close();
    print('✅ MySQL conectado');
    return true;
  } catch (error) {
    print('❌ Error de conexión');
    print(error);
    return false;
  }
}
