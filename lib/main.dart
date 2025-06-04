import 'package:flutter/material.dart';
import 'truecaller_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(home: TruecallerScreen());
}

class TruecallerScreen extends StatefulWidget {
  @override
  _TruecallerScreenState createState() => _TruecallerScreenState();
}

class _TruecallerScreenState extends State<TruecallerScreen> {
  String resultText = 'Waiting...';

  @override
  void initState() {
    super.initState();
    TruecallerService.startListening(
      onSuccess: (authCode, codeVerifier) {
        setState(() {
          resultText = "Success\nAuth Code: $authCode\nCode Verifier: $codeVerifier";
        });
      },
      onError: (errorCode, message) {
        setState(() {
          resultText = "Error $errorCode: $message";
        });
      },
    );
  }

  Future<void> _startTruecallerFlow() async {
    try {
      bool usable = await TruecallerService.isUsable();
      if (usable) {
        await TruecallerService.initialize();
        await TruecallerService.invoke();
      } else {
        setState(() => resultText = 'Truecaller not available on this device');
      }
    } catch (e) {
      setState(() => resultText = 'Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Truecaller Auth')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _startTruecallerFlow,
              child: Text('Start Truecaller Login'),
            ),
            SizedBox(height: 20),
            Text(resultText),
          ],
        ),
      ),
    );
  }
}
