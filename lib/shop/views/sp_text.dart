import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SpText extends StatefulWidget {
  String text;
  Color? color;
  String? font;
  List<Shadow>? shadow;

  SpText({Key? key, required this.text, this.color, this.font, this.shadow}) : super(key: key);

  @override
  _SpTextState createState() => _SpTextState();
}

class _SpTextState extends State<SpText> {

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          widget.text,
          textAlign:
          TextAlign.center,
          style: TextStyle(
            fontFamily: widget.font?? 'Yekan',
            color: widget.color?? Colors.black,
              shadows: widget.shadow,
          ),
        ),
      ),
    );
  }
}
