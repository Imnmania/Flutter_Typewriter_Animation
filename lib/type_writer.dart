import 'package:flutter/material.dart';

class TypeWriter extends StatefulWidget {
  final String prefix;
  final TextStyle prefixTextStyle;
  final double spacingAfterPrefix;
  final String text;
  final TextStyle textStyle;
  final Color cursorColor;

  const TypeWriter({
    super.key,
    required this.prefix,
    required this.prefixTextStyle,
    required this.spacingAfterPrefix,
    required this.text,
    required this.textStyle,
    required this.cursorColor,
  });

  @override
  State<TypeWriter> createState() => _TypeWriterState();
}

class _TypeWriterState extends State<TypeWriter> {
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

  Future<void> _typeNewText() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!context.mounted) return;

    // type the text
    for (int i = _nextIndex; i < _textToType.length; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
      if (!context.mounted) return;

      setState(() {
        _typedText = _textToType.substring(0, i + 1);
      });
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
