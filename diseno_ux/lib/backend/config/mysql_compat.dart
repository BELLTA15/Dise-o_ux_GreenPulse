import 'package:mysql_client/mysql_client.dart';

typedef ResultRow = Map<String, dynamic>;

class ConnectionSettings {
  final String host;
  final int port;
  final String db;
  final String user;
  final String password;
  final bool secure;

  const ConnectionSettings({
    required this.host,
    required this.port,
    required this.db,
    required this.user,
    required this.password,
    this.secure = false,
  });
}

class MySqlConnection {
  final MySQLConnection _inner;

  MySqlConnection._(this._inner);

  static Future<MySqlConnection> connect(ConnectionSettings settings) async {
    final inner = await MySQLConnection.createConnection(
      host: settings.host,
      port: settings.port,
      userName: settings.user,
      password: settings.password,
      databaseName: settings.db,
      secure: settings.secure,
    );
    await inner.connect();
    return MySqlConnection._(inner);
  }

  Future<QueryResult> query(String sql, [List<dynamic>? params]) async {
    final renderedSql = _renderSql(sql, params);
    final resultSet = await _inner.execute(renderedSql);
    return QueryResult._fromResultSet(resultSet);
  }

  Future<void> close() => _inner.close();
}

class QueryResult extends Iterable<Map<String, dynamic>> {
  final List<Map<String, dynamic>> _rows;
  final int? insertId;
  final int affectedRows;

  QueryResult._({
    required List<Map<String, dynamic>> rows,
    required this.insertId,
    required this.affectedRows,
  }) : _rows = rows;

  factory QueryResult._fromResultSet(IResultSet resultSet) {
    final rows = resultSet.rows.map((row) => row.typedAssoc()).toList();
    final lastInsertId = resultSet.lastInsertID.toInt();
    final normalizedInsertId = lastInsertId == 0 ? null : lastInsertId;

    return QueryResult._(
      rows: rows,
      insertId: normalizedInsertId,
      affectedRows: resultSet.affectedRows.toInt(),
    );
  }

  bool get isEmpty => _rows.isEmpty;

  bool get isNotEmpty => _rows.isNotEmpty;

  Map<String, dynamic> get first => _rows.first;

  int get length => _rows.length;

  @override
  Iterator<Map<String, dynamic>> get iterator => _rows.iterator;
}

String _renderSql(String sql, List<dynamic>? params) {
  if (params == null || params.isEmpty) {
    return sql;
  }

  var index = 0;
  return sql.replaceAllMapped(RegExp(r'\?'), (match) {
    if (index >= params.length) {
      throw StateError('Faltan parámetros para la consulta SQL');
    }

    final value = _formatValue(params[index++]);
    return value;
  });
}

String _formatValue(dynamic value) {
  if (value == null) {
    return 'NULL';
  }

  if (value is String) {
    return "'${_escapeString(value)}'";
  }

  if (value is DateTime) {
    final normalized = value.toUtc().toIso8601String().replaceFirst('T', ' ');
    return "'${normalized.replaceFirst('Z', '')}'";
  }

  if (value is bool) {
    return value ? '1' : '0';
  }

  if (value is num) {
    return value.toString();
  }

  return "'${_escapeString(value.toString())}'";
}

String _escapeString(String value) {
  return value
      .replaceAll(r'\', r'\\')
      .replaceAll("'", "''");
}