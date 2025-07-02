import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

const platform = MethodChannel('overlay_channel');

class MyApp extends StatelessWidget {
  Future<void> _showOverlay() async {
    try {
      final result = await platform.invokeMethod('showOverlay');
      debugPrint('Overlay result: $result');
    } on PlatformException catch (e) {
      debugPrint("Failed to show overlay: ${e.message}");
    }
  }

  Future<void> _scheduleOverlay() async {
    try {
      final result = await platform.invokeMethod('scheduleOverlay');
      debugPrint('Overlay scheduled: $result');
    } on PlatformException catch (e) {
      debugPrint("Failed to schedule overlay: ${e.message}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Overlay Demo',
      home: Scaffold(
        appBar: AppBar(title: Text("Overlay Banner Example")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: _showOverlay, child: Text("Show Now")),
              ElevatedButton(
                onPressed: _scheduleOverlay,
                child: Text("Show After 10s"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
