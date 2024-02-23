import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = MethodChannel('channel/text');

  String _displayText = '';

  Future<String> _sendTextToPlatform(String text) async {
    final Completer<String> completer = Completer<String>();
    try {
      final String processedText =
          await platform.invokeMethod('sendText', {'text': text});
      completer.complete(processedText);
    } catch (e) {
      completer.completeError("Failed to process text: $e");
    }
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Platform Channel Example'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                onChanged: (text) {
                  _displayText = text;
                },
                decoration: const InputDecoration(
                  hintText: 'Введите текст',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _sendTextToPlatform(_displayText);
                  });
                },
                child: const Text('Отправить'),
              ),
              const SizedBox(height: 20),
              FutureBuilder<String>(
                future: _sendTextToPlatform(_displayText),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Не удалось обработать текст');
                  } else if (snapshot.hasData) {
                    return Text('Ваш текст: ${snapshot.data}');
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
