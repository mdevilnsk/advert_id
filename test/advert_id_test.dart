import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:advert_id/advert_id.dart';

void main() {
  const MethodChannel channel = MethodChannel('advert_id');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await AdvertId.platformVersion, '42');
  });
}
