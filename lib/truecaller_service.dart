import 'package:flutter/services.dart';

class TruecallerService {
  static const MethodChannel _channel = MethodChannel('truecaller_sdk');
  static const EventChannel _eventChannel = EventChannel(
    'truecaller_sdk_events',
  );

  static Future<void> initialize() async {
    await _channel.invokeMethod('initialize', {
      "buttonColor": "#00AEEF",
      "buttonTextColor": "#FFFFFF",
    });
  }

  static Future<void> invoke() async {
    final result = await _channel.invokeMethod('invoke');
    print("Invoke result: $result");
  }

  static Future<bool> isUsable() async {
    return await _channel.invokeMethod('isUsable');
  }

  static void startListening({
    required Function(String authCode, String codeVerifier) onSuccess,
    required Function(int errorCode, String message) onError,
  }) {
    _eventChannel.receiveBroadcastStream().listen((event) {
      final map = Map<String, dynamic>.from(event);
      if (map.containsKey('authorizationCode')) {
        onSuccess(map['authorizationCode'], map['codeVerifier']);
      } else if (map.containsKey('errorCode')) {
        onError(map['errorCode'], map['errorMessage']);
      }
    });
  }
}
