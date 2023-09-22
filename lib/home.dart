import 'package:flutter/material.dart';
import 'package:typewriter_animation_example/type_writer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: Center(
        child: TypeWriter(
          prefix: '>',
          prefixTextStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          spacingAfterPrefix: 8,
          text: 'Welcome to Flutter',
          textStyle: const TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          cursorColor: Colors.blue,
        ),
      ),
    );
  }
}
