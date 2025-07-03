import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Optional: background handler if needed
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

// Must be a top-level function
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("🔔 Background Message: ${message.messageId}");
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const MethodChannel overlayChannel = MethodChannel('overlay_channel');
  static const MethodChannel overlayActionChannel = MethodChannel(
    'overlay_action',
  );

  String _log = "Waiting for overlay action...";

  @override
  void initState() {
    super.initState();
    requestNotificationPermissions();
    FirebaseMessaging.instance.getToken().then((token) {
      print("📱 FCM Token: $token");
    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _triggerOverlay('12345', 'New Order');
      print('🔥 Foreground Message: ${message.data}');
      // Show overlay or call native method here
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📦 Notification caused app to open: ${message.data}');
    });

    // Listen for Accept / Reject coming from native
    overlayActionChannel.setMethodCallHandler((call) async {
      if (call.method == "handleAction") {
        final data = call.arguments as Map?;
        final action = data?["action"];
        final orderId = data?["orderId"];

        setState(() {
          _log = "Action: $action\nOrder ID: $orderId";
        });

        // You can perform API call here
        // if (action == "accept") callAcceptAPI(orderId);
        // if (action == "reject") callRejectAPI(orderId);
      }
    });
  }

  void requestNotificationPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('🔐 User granted permission');
    } else {
      print('❌ User declined or has not accepted permission');
    }
  }

  Future<void> _triggerOverlay(String orderId, String title) async {
    try {
      final result = await overlayChannel.invokeMethod('showOverlay', {
        'orderId': orderId,
        'title': title,
      });
      debugPrint("Overlay result: $result");
      setState(() {
        _log = "Overlay triggered: $result";
      });
    } on PlatformException catch (e) {
      setState(() {
        _log = "Error: ${e.message}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Overlay Test',
      home: Scaffold(
        appBar: AppBar(title: Text('Overlay Trigger')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () => _triggerOverlay('12345', 'New Order'),
                child: Text("Show Top Overlay"),
              ),
              const SizedBox(height: 20),
              Text(_log, style: TextStyle(fontSize: 16, color: Colors.black87)),
            ],
          ),
        ),
      ),
    );
  }
}
