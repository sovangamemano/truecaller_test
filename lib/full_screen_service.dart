import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class IconSwitcher {
  static const MethodChannel _channel = MethodChannel('app.icon.switcher');

  /// Switches the app icon using the alias name (must match AndroidManifest alias)
  static Future<void> switchIcon(String alias) async {
    try {
      await _channel.invokeMethod('changeIcon', {'alias': alias});
    } catch (e) {
      debugPrint("Failed to switch icon: $e");
    }
  }
}
