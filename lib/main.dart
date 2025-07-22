import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:readsms/readsms.dart';
import 'package:workmanager/workmanager.dart';

import 'dashboard.dart';

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    final plugin = Readsms();

    plugin.read();
    plugin.smsStream.listen((event) {
      print("🔴 SMS RECEIVED in BACKGROUND");
      print("📤 Sender: ${event.sender}");
      print("📩 Message: ${event.body}");
      print("🕒 Time: ${event.timeReceived}");
    });

    // Delay to keep the stream alive
    await Future.delayed(Duration(seconds: 30));
    plugin.dispose();

    return Future.value(true);
  });
}

const platform = MethodChannel("sms.channel");
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager().initialize(callbackDispatcher);
  setDefaultSmsApp();
  await Firebase.initializeApp();

  // Optional: background handler if needed
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

Future<void> setDefaultSmsApp() async {
  try {
    await platform.invokeMethod('makeDefaultSmsApp');
  } on PlatformException catch (e) {
    print("Error setting default SMS app: ${e.message}");
  }
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
  ValueNotifier<bool> isScrolling = ValueNotifier(false);
  Timer? _scrollStopTimer;
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
      _triggerOverlay(message.data["orderId"], message.data["title"]);
      print('🔥 Foreground Message: ${message.data}');
      // Show overlay or call native method here
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📦 Notification caused app to open: ${message.data}');
    });

    MethodChannel overlayActionChannel = const MethodChannel('overlay_action');
    overlayActionChannel.setMethodCallHandler((call) async {
      if (call.method == "handleAction") {
        final action = call.arguments["action"];
        final orderId = call.arguments["orderId"];
        print("🔔 Action: $action | Order: $orderId");
        // Handle in Flutter UI
      }
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
      home: Dashboard(),

      // Scaffold(
      //   appBar: AppBar(title: Text('Overlay Trigger')),
      //   floatingActionButton: Align(
      //     alignment: Alignment.bottomCenter,
      //     child: ValueListenableBuilder<bool>(
      //       valueListenable: isScrolling,
      //       builder: (context, isScrollingValue, child) {
      //         return AnimatedSize(
      //           duration: const Duration(milliseconds: 300),
      //           curve: Curves.easeInOut,
      //           child: Container(
      //             height: 50,
      //             padding: const EdgeInsets.symmetric(horizontal: 16),
      //             decoration: BoxDecoration(
      //               color: Colors.blue,
      //               borderRadius: BorderRadius.circular(30),
      //             ),
      //             child: Row(
      //               mainAxisSize: MainAxisSize.min,
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               crossAxisAlignment: CrossAxisAlignment.center,
      //               children: [
      //                 AnimatedSwitcher(
      //                   duration: const Duration(milliseconds: 300),
      //                   transitionBuilder: (child, animation) => SizeTransition(
      //                     sizeFactor: animation,
      //                     axis: Axis.horizontal,
      //                     child: FadeTransition(
      //                       opacity: animation,
      //                       child: child,
      //                     ),
      //                   ),
      //                   child: isScrollingValue
      //                       ? const SizedBox(key: ValueKey('empty'), width: 0)
      //                       : Center(
      //                           child: Padding(
      //                             key: const ValueKey('scrolling'),
      //                             padding: const EdgeInsets.only(right: 8),
      //                             child: Text(
      //                               "Scrolling...",
      //                               style: const TextStyle(color: Colors.white),
      //                             ),
      //                           ),
      //                         ),
      //                 ),
      //                 const Icon(Icons.arrow_upward, color: Colors.white),
      //               ],
      //             ),
      //           ),
      //         );
      //       },
      //     ),
      //   ),
      //   body: Padding(
      //     padding: const EdgeInsets.all(16),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.stretch,
      //       children: [
      //         ElevatedButton(
      //           onPressed: () => _triggerOverlay('12345', 'New Order'),
      //           child: Text("Show Top Overlay"),
      //         ),
      //         const SizedBox(height: 20),
      //         Text(_log, style: TextStyle(fontSize: 16, color: Colors.black87)),
      //         Expanded(
      //           child: NotificationListener<ScrollNotification>(
      //             onNotification: (ScrollNotification notification) {
      //               if (notification is ScrollStartNotification) {
      //                 print("Scrolling...");
      //                 isScrolling.value = true;

      //                 // Cancel any pending timer
      //                 _scrollStopTimer?.cancel();
      //               } else if (notification is ScrollEndNotification) {
      //                 print("Stopped scrolling... waiting to reset");

      //                 // Cancel previous timer if any
      //                 _scrollStopTimer?.cancel();

      //                 // Start new timer
      //                 _scrollStopTimer = Timer(const Duration(seconds: 1), () {
      //                   print("Actually stopped.");
      //                   isScrolling.value = false;
      //                 });
      //               }
      //               return true;
      //             },
      //             child: ListView.builder(
      //               itemCount: 1000,
      //               itemBuilder: (_, index) =>
      //                   SizedBox(height: 20, child: Text("List $index")),
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
