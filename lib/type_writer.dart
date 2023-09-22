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
  late BlinkingCursorController _blinkingCursorController;

  @override
  void initState() {
    super.initState();

    _textToType = widget.text;
    _nextIndex = 0;
    _typedText = '';
    _blinkingCursorController = BlinkingCursorController();

    _typeNewText();
  }

  @override
  void didUpdateWidget(covariant TypeWriter oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.text != oldWidget.text) {
      _textToType = widget.text;

      _typeNewText();
    }
  }

  @override
  void dispose() {
    _blinkingCursorController.dispose();
    super.dispose();
  }

  /// Logic behind typing
  Future<void> _typeNewText() async {
    // initial wait
    await Future.delayed(const Duration(seconds: 1));
    if (!context.mounted) return;

    // if there's text, delete first
    final firstDifferentCharacter = _findFirstDifferentCharacter(
      _textToType,
      _typedText,
    );
    await _eraseToIndex(firstDifferentCharacter);
    if (!context.mounted) return;

    // type the text
    await _typeForward();

    // wait for the next line
    await Future.delayed(const Duration(seconds: 2));
    if (context.mounted) {
      widget.onComplete?.call();
    }
  }

  /// Returns the first index where two strings differ
  int _findFirstDifferentCharacter(String label1, String label2) {
    int index = 0;

    while (index < label1.length &&
        index < label2.length &&
        label1[index] == label2[index]) {
      index += 1;
    }

    return index;
  }

  Future<void> _eraseToIndex(int index) async {
    for (int i = _typedText.length - 1; i >= index; i--) {
      await Future.delayed(const Duration(milliseconds: 40));

      if (!context.mounted) return;

      setState(() {
        _typedText = _typedText.substring(0, i);
        _nextIndex = i;
        _blinkingCursorController.reset();
      });
    }
  }

  Future<void> _typeForward() async {
    for (int i = _nextIndex; i < _textToType.length; i++) {
      await Future.delayed(_generateTypingDuration());
      if (!context.mounted) return;

      setState(() {
        _typedText = _textToType.substring(0, i + 1);
        _blinkingCursorController.reset();
      });
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
        BlinkingCursor(
          color: widget.cursorColor,
          fontSize: widget.textStyle.fontSize ?? 20,
          blinkingCursorController: _blinkingCursorController,
        ),
      ],
    );
  }
}

class BlinkingCursor extends StatefulWidget {
  final double fontSize;
  final Color color;
  final BlinkingCursorController blinkingCursorController;
  const BlinkingCursor({
    super.key,
    required this.fontSize,
    required this.color,
    required this.blinkingCursorController,
  });

  @override
  State<BlinkingCursor> createState() => _BlinkingCursorState();
}

class _BlinkingCursorState extends State<BlinkingCursor>
    with TickerProviderStateMixin {
  static const pulsePeriod = Duration(milliseconds: 400);
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: pulsePeriod,
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _animationController.forward();
        }
      })
      ..forward();

    widget.blinkingCursorController.addListener(_reset);
  }

  void _reset() {
    _animationController.forward(from: 0.0);
  }

  @override
  void didUpdateWidget(covariant BlinkingCursor oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.blinkingCursorController != oldWidget.blinkingCursorController) {
      oldWidget.blinkingCursorController.removeListener(_reset);
      widget.blinkingCursorController.addListener(_reset);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          return Text(
            '|',
            style: TextStyle(
              color: widget.color.withOpacity(1 - _animationController.value),
              fontSize: widget.fontSize,
              fontWeight: FontWeight.bold,
            ),
          );
        });
  }
}

class BlinkingCursorController with ChangeNotifier {
  void reset() {
    notifyListeners();
  }
}
