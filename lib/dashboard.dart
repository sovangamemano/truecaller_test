import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:readsms/readsms.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';

import 'home_screen.dart';
import 'inventory_screen.dart';
import 'main.dart';
import 'orders_screen.dart';
import 'profile_screen.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    InventoryScreen(),
    OrdersScreen(),
    ProfileScreen(),
  ];

  final List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.home, 'label': 'Home'},
    {'icon': Icons.inventory, 'label': 'Inventory'},
    {'icon': Icons.notifications, 'label': 'Orders'},
    {'icon': Icons.person, 'label': 'Profile'},
  ];

  @override
  void initState() {
    super.initState();
    // _setDefaultSmsApp();
    _setupForegroundListener();
    fetchSms();
    _loadSMS();
  }

  final Readsms _plugin = Readsms();

  String sms = 'No SMS received';
  String sender = 'Unknown';
  String time = 'Not available';
  String backgroundStatus = "Not started";
  List<String> messages = [];
  List<SmsMessage> newMessages = [];
  

  /// ✅ Request SMS Permission & Start Foreground Listener
  Future<void> _setupForegroundListener() async {
    bool granted = await _requestPermission();
    if (!granted) {
      print('SMS permission not granted');
      return;
    }

    _plugin.read();
    _plugin.smsStream.listen((event) {
      print('📩 [Foreground] SMS Received');
      print('Sender: ${event.sender}');
      print('Message: ${event.body}');
      print('Time: ${event.timeReceived}');

      setState(() {
        sms = event.body;
        sender = event.sender;
        time = event.timeReceived.toString();
      });
    });
  }

  /// ✅ Start WorkManager Background Task
  void _startBackgroundTask() async {
    bool granted = await _requestPermission();
    if (!granted) {
      setState(() {
        backgroundStatus = "Permission not granted!";
      });
      return;
    }

    await Workmanager().registerOneOffTask(
      "uniqueSmsTask",
      "readSmsInBackground",
    );

    setState(() {
      backgroundStatus = "Background task registered! Wait for SMS...";
    });
  }

  /// ✅ SMS Permission Handling
  Future<bool> _requestPermission() async {
    var result = await Permission.sms.status;
    if (!result.isGranted) {
      result = await Permission.sms.request();
    }
    return result.isGranted;
  }

  Future<void> _loadSMS() async {
    // Register Android-specific plugin manually (needed in some cases)
    SharedPreferencesAndroid.registerWith();

    // Load from native-named prefs file
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('sms_list') ?? '';
    print("🧪 Retrieved from SharedPreferences: $data");

    final list = data
        .trim()
        .split('\n')
        .where((line) => line.contains("|||"))
        .toList();

    setState(() {
      messages = list;
    });
  }

  // Future<void> _setDefaultSmsApp() async {
  //   try {
  //     await platform.invokeMethod('makeDefaultSmsApp');
  //   } on PlatformException catch (e) {
  //     print("Error setting default SMS app: ${e.message}");
  //   }
  // }

  @override
  void dispose() {
    _plugin.dispose();
    super.dispose();
  }

  fetchSms() async {
    SmsQuery query = SmsQuery();
    // List<SmsMessage> messages = await query.getAllSms;
    // print(messages);
    // Process messages as needed
    List<SmsMessage> messages = await query.querySms(
      // threadId: 1,
      kinds: [SmsQueryKind.inbox],
    );
    print(messages);
    final oneHourAgo = DateTime.now().subtract(Duration(hours: 1));

    messages.forEach((message) {
      final msgDate = DateTime.fromMillisecondsSinceEpoch(message.date?.millisecondsSinceEpoch ?? 0);

      if (msgDate.isAfter(oneHourAgo)) {
        newMessages.add(message);
        print('🟢 [Recent] From: ${message.address}, Body: ${message.body}');
      } else {
        print('⚪ [Old] Ignored: ${message.address}');
      }
    });
    print(newMessages);

    // await query.querySms(
    //   address: getContactAddress()
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _loadSMS,
        child: ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final parts = messages[index].split("|||");

            final sender = parts.length > 0 ? parts[0] : "Unknown";
            final message = parts.length > 1 ? parts[1] : "No message";
            String timeString = "Invalid";

            if (parts.length > 2) {
              try {
                final millis = int.parse(parts[2]);
                timeString = DateTime.fromMillisecondsSinceEpoch(
                  millis,
                ).toLocal().toString();
              } catch (e) {
                timeString = "Invalid timestamp";
              }
            }

            return ListTile(
              title: Text(message),
              subtitle: Text("From: $sender"),
              trailing: Text(timeString),
            );
          },
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _setDefaultSmsApp,
      //   child: Icon(Icons.play_arrow),
      // ),
    );
  }
}
