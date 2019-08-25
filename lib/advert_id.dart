import 'dart:async';

import 'package:flutter/services.dart';

class AdvertId {
  static const MethodChannel _channel = const MethodChannel('advert_id');

  static Future<String> get id async {
    final String id = await _channel.invokeMethod('getAdvertisingId');
    return id;
  }
}
