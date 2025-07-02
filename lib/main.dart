import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

const platform = MethodChannel('overlay_channel');

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    setupOverlayListener();
  }

  Future<void> showOverlay() async {
    try {
      final res = await platform.invokeMethod('showOverlay');
      debugPrint('Overlay result: $res');
    } on PlatformException catch (e) {
      debugPrint('Error: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Overlay Test',
      home: Scaffold(
        appBar: AppBar(title: const Text('Overlay Test')),
        body: Center(
          child: ElevatedButton(
            onPressed: showOverlay,
            child: const Text('Show Test Banner'),
          ),
        ),
      ),
    );
  }
}

const overlayActionChannel = MethodChannel("overlay_action");

void setupOverlayListener() {
  overlayActionChannel.setMethodCallHandler((call) async {
    if (call.method == "handleAction") {
      final data = Map<String, dynamic>.from(call.arguments);
      final action = data["action"];
      final orderId = data["orderId"];

      // Call your Dio API using existing setup
      // await YourApiService.handleOrderAction(action, orderId);
      print("Action: $action, Order ID: $orderId");
      // Optionally show Toast/snackbar
    }
  });
}
