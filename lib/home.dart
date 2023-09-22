import 'package:flutter/material.dart';
import 'package:typewriter_animation_example/type_writer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const _flutterCommands = [
    'flutter create my_app',
    'flutter run',
    'flutter build appbundle',
    'flutter build ipa'
  ];

  int _currentCommandIndex = 0;

  void _nextCommand() {
    setState(() {
      _currentCommandIndex = _currentCommandIndex < _flutterCommands.length - 1
          ? _currentCommandIndex + 1
          : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: Container(
        height: 200,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black87,
        ),
        alignment: Alignment.topLeft,
        child: RepaintBoundary(
          child: TypeWriter(
            prefix: '>',
            prefixTextStyle: const TextStyle(
              color: Colors.blueAccent,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            spacingAfterPrefix: 8,
            text: _flutterCommands[_currentCommandIndex],
            textStyle: const TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            cursorColor: Colors.blue,
            onComplete: _nextCommand,
          ),
        ),
      ),
    );
  }
}
