import 'package:flutter/foundation.dart';
import 'package:flutter_mobile/services/api_client.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiClient.resolveBaseUri', () {
    test('uses the Android emulator host by default', () {
      final uri = ApiClient.resolveBaseUri(
        override: '',
        isWeb: false,
        platform: TargetPlatform.android,
      );

      expect(uri.toString(), 'http://10.0.2.2:5000/api/');
    });

    test('uses the browser host for web development', () {
      final uri = ApiClient.resolveBaseUri(
        override: '',
        isWeb: true,
        browserUri: Uri.parse('http://localhost:8080/'),
      );

      expect(uri.toString(), 'http://localhost:5000/api/');
    });

    test('preserves an explicitly configured API URL', () {
      final uri = ApiClient.resolveBaseUri(
        override: 'http://192.168.1.25:5000/api',
        isWeb: false,
        platform: TargetPlatform.android,
      );

      expect(uri.toString(), 'http://192.168.1.25:5000/api/');
    });
  });
}
