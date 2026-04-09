import 'package:flutter/foundation.dart';

const String _androidEmulatorBaseUrl = 'http://10.0.2.2:3000/api/v1';
const String _localBaseUrl = 'http://127.0.0.1:3000/api/v1';

final String BASE_URL =
	defaultTargetPlatform == TargetPlatform.android
	? _androidEmulatorBaseUrl
	: _localBaseUrl;
const TIMEOUT_SECONDS = 30;
const TOKEN_KEY = 'token';
