import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';
import 'package:bcrypt/bcrypt.dart';

import '../config/database.dart';
import '../config/mysql_compat.dart';
import '../config/env.dart';

Future<Response> registroUsuario(Request request) async {
  final body = await request.readAsString();
  final Map<String, dynamic> data = jsonDecode(body) as Map<String, dynamic>;

  final nombre = (data['nombre'] ?? '').toString().trim();
  final correo = (data['correo'] ?? '').toString().trim().toLowerCase();
  final contrasena = (data['contrasena'] ?? '').toString();

  if (nombre.isEmpty || correo.isEmpty || contrasena.isEmpty) {
    return Response(
      400,
      body: jsonEncode({
        'error': 'nombre, correo y contrasena son obligatorios',
      }),
      headers: {'content-type': 'application/json'},
    );
  }

  MySqlConnection? connection;
  try {
    connection = await openDatabaseConnection();

    final existing = await connection.query(
      'SELECT usuario_id FROM USUARIO WHERE correo = ? LIMIT 1',
      [correo],
    );

    if (existing.isNotEmpty) {
      return Response(
        409,
        body: jsonEncode({'error': 'El correo ya existe'}),
        headers: {'content-type': 'application/json'},
      );
    }

    final passwordHash = BCrypt.hashpw(
      contrasena,
      BCrypt.gensalt(logRounds: 10),
    );
    final now = DateTime.now();

    final result = await connection.query(
      '''
      INSERT INTO USUARIO (nombre, correo, contrasena_hash, token_fcm, fecha_registro, activo, sync_estado)
      VALUES (?, ?, ?, ?, ?, ?, ?)
      ''',
      [nombre, correo, passwordHash, null, now, 1, 'PENDING'],
    );

    return Response(
      201,
      body: jsonEncode({
        'mensaje': 'Usuario creado exitosamente',
        'usuario_id': result.insertId,
      }),
      headers: {'content-type': 'application/json'},
    );
  } finally {
    await connection?.close();
  }
}

Future<Response> loginUsuario(Request request) async {
  final body = await request.readAsString();
  final Map<String, dynamic> data = jsonDecode(body) as Map<String, dynamic>;

  final correo = (data['correo'] ?? '').toString().trim().toLowerCase();
  final contrasena = (data['contrasena'] ?? '').toString();

  if (correo.isEmpty || contrasena.isEmpty) {
    return Response(
      400,
      body: jsonEncode({'error': 'correo y contrasena son obligatorios'}),
      headers: {'content-type': 'application/json'},
    );
  }

  MySqlConnection? connection;
  try {
    connection = await openDatabaseConnection();
    final rows = await connection.query(
      '''
      SELECT usuario_id, nombre, correo, contrasena_hash
      FROM USUARIO
      WHERE correo = ?
      LIMIT 1
      ''',
      [correo],
    );

    if (rows.isEmpty) {
      return Response(
        401,
        body: jsonEncode({'error': 'Credenciales incorrectas'}),
        headers: {'content-type': 'application/json'},
      );
    }

    final row = rows.first;
    final usuarioId = row['usuario_id'] as int;
    final nombre = row['nombre'] as String;
    final correoDb = row['correo'] as String;
    final hash = row['contrasena_hash'] as String;

    if (!BCrypt.checkpw(contrasena, hash)) {
      return Response(
        401,
        body: jsonEncode({'error': 'Credenciales incorrectas'}),
        headers: {'content-type': 'application/json'},
      );
    }

    final token = _generateToken({
      'usuario_id': usuarioId,
      'correo': correoDb,
      'nombre': nombre,
    });

    return Response.ok(
      jsonEncode({
        'access_token': token,
        'token_type': 'bearer',
        'usuario': {'id': usuarioId, 'nombre': nombre, 'correo': correoDb},
      }),
      headers: {'content-type': 'application/json'},
    );
  } finally {
    await connection?.close();
  }
}

Future<Response> refreshToken(Request request) async {
  final body = await request.readAsString();
  final Map<String, dynamic> data = jsonDecode(body) as Map<String, dynamic>;
  final token = (data['token'] ?? '').toString().trim();

  if (token.isEmpty) {
    return Response(
      400,
      body: jsonEncode({'error': 'token es obligatorio'}),
      headers: {'content-type': 'application/json'},
    );
  }

  try {
    final jwt = JWT.verify(
      token,
      SecretKey(envOrThrow('JWT_SECRET')),
      checkExpiresIn: false,
    );

    final payload = Map<String, dynamic>.from(jwt.payload as Map);
    final newToken = _generateToken({
      'usuario_id': payload['usuario_id'],
      'correo': payload['correo'],
      'nombre': payload['nombre'],
    });

    return Response.ok(
      jsonEncode({'access_token': newToken, 'token_type': 'bearer'}),
      headers: {'content-type': 'application/json'},
    );
  } catch (_) {
    return Response(
      401,
      body: jsonEncode({'error': 'Token inválido o expirado'}),
      headers: {'content-type': 'application/json'},
    );
  }
}

Future<Response> obtenerPerfil(Request request) async {
  final usuarioId = _usuarioIdDesdeRequest(request);
  MySqlConnection? connection;

  try {
    connection = await openDatabaseConnection();
    final rows = await connection.query(
      '''
      SELECT usuario_id, nombre, correo, fecha_registro, activo
      FROM USUARIO
      WHERE usuario_id = ?
      LIMIT 1
      ''',
      [usuarioId],
    );

    if (rows.isEmpty) {
      return Response(
        404,
        body: jsonEncode({'error': 'Usuario no encontrado'}),
        headers: {'content-type': 'application/json'},
      );
    }

    final row = rows.first;
    return Response.ok(
      jsonEncode({
        'usuario': {
          'id': row['usuario_id'],
          'nombre': row['nombre'],
          'correo': row['correo'],
          'fecha_registro': _toIsoString(row['fecha_registro']),
          'activo': row['activo'],
        },
      }),
      headers: {'content-type': 'application/json'},
    );
  } finally {
    await connection?.close();
  }
}

Future<Response> actualizarPerfil(Request request) async {
  final usuarioId = _usuarioIdDesdeRequest(request);
  final body = await request.readAsString();
  final data = jsonDecode(body) as Map<String, dynamic>;

  final nombre = data['nombre']?.toString().trim();
  final correo = data['correo']?.toString().trim().toLowerCase();

  if ((nombre == null || nombre.isEmpty) && (correo == null || correo.isEmpty)) {
    return Response(
      400,
      body: jsonEncode({'error': 'Debes enviar nombre o correo para actualizar'}),
      headers: {'content-type': 'application/json'},
    );
  }

  MySqlConnection? connection;
  try {
    connection = await openDatabaseConnection();

    if (correo != null && correo.isNotEmpty) {
      final existing = await connection.query(
        'SELECT usuario_id FROM USUARIO WHERE correo = ? AND usuario_id <> ? LIMIT 1',
        [correo, usuarioId],
      );
      if (existing.isNotEmpty) {
        return Response(
          409,
          body: jsonEncode({'error': 'El correo ya está en uso'}),
          headers: {'content-type': 'application/json'},
        );
      }
    }

    final fields = <String>[];
    final values = <dynamic>[];

    if (nombre != null && nombre.isNotEmpty) {
      fields.add('nombre = ?');
      values.add(nombre);
    }
    if (correo != null && correo.isNotEmpty) {
      fields.add('correo = ?');
      values.add(correo);
    }

    values.add(usuarioId);

    await connection.query(
      'UPDATE USUARIO SET ${fields.join(', ')} WHERE usuario_id = ?',
      values,
    );

    final rows = await connection.query(
      'SELECT usuario_id, nombre, correo, fecha_registro, activo FROM USUARIO WHERE usuario_id = ? LIMIT 1',
      [usuarioId],
    );

    final row = rows.first;
    return Response.ok(
      jsonEncode({
        'mensaje': 'Perfil actualizado',
        'usuario': {
          'id': row['usuario_id'],
          'nombre': row['nombre'],
          'correo': row['correo'],
          'fecha_registro': _toIsoString(row['fecha_registro']),
          'activo': row['activo'],
        },
      }),
      headers: {'content-type': 'application/json'},
    );
  } finally {
    await connection?.close();
  }
}

Future<Response> cambiarContrasena(Request request) async {
  final usuarioId = _usuarioIdDesdeRequest(request);
  final body = await request.readAsString();
  final data = jsonDecode(body) as Map<String, dynamic>;

  final actualContrasena = (data['actual_contrasena'] ?? '').toString();
  final nuevaContrasena = (data['nueva_contrasena'] ?? '').toString();

  if (actualContrasena.isEmpty || nuevaContrasena.isEmpty) {
    return Response(
      400,
      body: jsonEncode({'error': 'actual_contrasena y nueva_contrasena son obligatorias'}),
      headers: {'content-type': 'application/json'},
    );
  }

  if (nuevaContrasena.length < 6) {
    return Response(
      400,
      body: jsonEncode({'error': 'La nueva contraseña debe tener al menos 6 caracteres'}),
      headers: {'content-type': 'application/json'},
    );
  }

  MySqlConnection? connection;
  try {
    connection = await openDatabaseConnection();
    final rows = await connection.query(
      'SELECT contrasena_hash FROM USUARIO WHERE usuario_id = ? LIMIT 1',
      [usuarioId],
    );

    if (rows.isEmpty) {
      return Response(
        404,
        body: jsonEncode({'error': 'Usuario no encontrado'}),
        headers: {'content-type': 'application/json'},
      );
    }

    final hash = rows.first['contrasena_hash'].toString();
    if (!BCrypt.checkpw(actualContrasena, hash)) {
      return Response(
        401,
        body: jsonEncode({'error': 'La contraseña actual es incorrecta'}),
        headers: {'content-type': 'application/json'},
      );
    }

    final newHash = BCrypt.hashpw(
      nuevaContrasena,
      BCrypt.gensalt(logRounds: 10),
    );

    await connection.query(
      'UPDATE USUARIO SET contrasena_hash = ?, sync_estado = ? WHERE usuario_id = ?',
      [newHash, 'PENDING', usuarioId],
    );

    return Response.ok(
      jsonEncode({'mensaje': 'Contraseña actualizada correctamente'}),
      headers: {'content-type': 'application/json'},
    );
  } finally {
    await connection?.close();
  }
}

String _generateToken(Map<String, dynamic> payload) {
  final expires = backendEnv['JWT_EXPIRES_IN'] ?? '7d';
  final expiration = _parseDuration(expires);

  final jwt = JWT(payload);
  return jwt.sign(SecretKey(envOrThrow('JWT_SECRET')), expiresIn: expiration);
}

Duration _parseDuration(String value) {
  final trimmed = value.trim().toLowerCase();
  final match = RegExp(r'^(\d+)([smhd])$').firstMatch(trimmed);
  if (match == null) {
    return const Duration(days: 7);
  }

  final amount = int.parse(match.group(1)!);
  switch (match.group(2)!) {
    case 's':
      return Duration(seconds: amount);
    case 'm':
      return Duration(minutes: amount);
    case 'h':
      return Duration(hours: amount);
    case 'd':
      return Duration(days: amount);
    default:
      return const Duration(days: 7);
  }
}

int _usuarioIdDesdeRequest(Request request) {
  final usuario = request.context['usuario'];
  if (usuario is Map) {
    final usuarioId = usuario['usuario_id'];
    final parsed = int.tryParse(usuarioId.toString());
    if (parsed != null) {
      return parsed;
    }
  }
  throw StateError('Usuario autenticado no encontrado en el contexto');
}

String? _toIsoString(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value.toUtc().toIso8601String();
  return DateTime.parse(value.toString()).toUtc().toIso8601String();
}
