import 'package:flutter/material.dart';
import 'package:typewriter_animation_example/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'TypeWriter Animation',
      home: HomeScreen(),
    );
  }
}
