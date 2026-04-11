import 'package:dio/dio.dart';

import '../core/api_client.dart';

class SettingsService {
  final Dio _dio = ApiClient.instance.dio;

  Future<Map<String, dynamic>> getAjustes() async {
    try {
      final response = await _dio.get('/ajustes');
      final data = _asMap(response.data);
      final ajustes = data['ajustes'];
      if (ajustes is Map) {
        return ajustes.map((k, v) => MapEntry(k.toString(), v));
      }
      return _defaultAjustes();
    } on DioException catch (error) {
      throw Exception(ApiClient.readableError(error));
    }
  }

  Future<Map<String, dynamic>> updateAjustes(Map<String, dynamic> payload) async {
    try {
      final response = await _dio.put('/ajustes', data: payload);
      final data = _asMap(response.data);
      final ajustes = data['ajustes'];
      if (ajustes is Map) {
        return ajustes.map((k, v) => MapEntry(k.toString(), v));
      }
      return _defaultAjustes();
    } on DioException catch (error) {
      throw Exception(ApiClient.readableError(error));
    }
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    if (value is Map) {
      return value.map((key, value) => MapEntry(key.toString(), value));
    }
    throw Exception('Formato de respuesta inválido');
  }

  Map<String, dynamic> _defaultAjustes() {
    return {
      'notificaciones_activas': true,
      'sonidos_activos': false,
      'idioma': 'Español',
      'tema': 'Claro (GreenPulse)',
      'privacidad_modo': 'Estándar',
    };
  }
}
