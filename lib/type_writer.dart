import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TypeWriter extends StatefulWidget {
  final String prefix;
  final TextStyle prefixTextStyle;
  final double spacingAfterPrefix;
  final String text;
  final TextStyle textStyle;
  final Color cursorColor;
  final VoidCallback? onComplete;

  const TypeWriter({
    super.key,
    required this.prefix,
    required this.prefixTextStyle,
    required this.spacingAfterPrefix,
    required this.text,
    required this.textStyle,
    required this.cursorColor,
    required this.onComplete,
  });

  @override
  State<TypeWriter> createState() => _TypeWriterState();
}

class _TypeWriterState extends State<TypeWriter> {
  static const _minTypingDelay = Duration(milliseconds: 20);
  static const _maxTypingDelay = Duration(milliseconds: 200);

  late String _textToType;
  late int _nextIndex;
  late String _typedText;

  @override
  void initState() {
    super.initState();

    _textToType = widget.text;
    _nextIndex = 0;
    _typedText = '';

    _typeNewText();
  }

  /// Logic behind typing
  Future<void> _typeNewText() async {
    // initial wait
    await Future.delayed(const Duration(seconds: 1));
    if (!context.mounted) return;

    // type the text
    for (int i = _nextIndex; i < _textToType.length; i++) {
      await Future.delayed(_generateTypingDuration());
      if (!context.mounted) return;

      setState(() {
        _typedText = _textToType.substring(0, i + 1);
      });
    }

    // wait for the next line
    await Future.delayed(const Duration(seconds: 2));
    if (context.mounted) {
      widget.onComplete?.call();
    }
  }

  /// Gives us a more natural typing speed
  Duration _generateTypingDuration() {
    return lerpDuration(
      _minTypingDelay,
      _maxTypingDelay,
      Random().nextDouble(),
    );
  }

  @override
  void didUpdateWidget(covariant TypeWriter oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.text != oldWidget.text) {
      _textToType = widget.text;
      _nextIndex = 0;
      _typedText = '';

      _typeNewText();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          widget.prefix,
          style: widget.prefixTextStyle,
        ),
        SizedBox(width: widget.spacingAfterPrefix),
        Text(
          _typedText,
          style: widget.textStyle,
        ),
        Text(
          '|',
          style: TextStyle(
            color: widget.cursorColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
