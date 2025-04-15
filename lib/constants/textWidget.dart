import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Text_Widget extends StatelessWidget {

  final String text;
  final Color? color;
  final FontWeight? fontweight;
  final double fontSize;
  final TextAlign? textAlign;
  final TextOverflow? textOverflow;
  final int? maxLines;
  final FontStyle? fontStyle;

  const Text_Widget( {super.key,
    required this.text,
    this.color,
    this.fontweight,
    required this.fontSize,
    this.textAlign,
    this.textOverflow,
    this.maxLines,
    this.fontStyle,
  }
      );

  @override
  Widget build(BuildContext context) {
    return
      Text(
        text,style: GoogleFonts.dmSans(
        textStyle: TextStyle(

          color: color ?? Colors.black,
          fontWeight:fontweight??FontWeight.w400,
          fontSize: fontSize,
          overflow: textOverflow,
          fontStyle: fontStyle ?? FontStyle.normal,

        ),
      ),textAlign: textAlign,
        maxLines: maxLines,
      );
  }
}