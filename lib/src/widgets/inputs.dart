import 'package:flutter/material.dart';
import 'package:coinpay/src/utils/colors.dart';
import 'package:coinpay/src/utils/sizes.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchOptionTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final Function onTap;

  SearchOptionTextField({
    @required this.controller,
    @required this.label,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: TextField(
        controller: controller,
        enabled: false,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: FontSize.s20,
        ),
        decoration: InputDecoration(
          labelText: "$label",
          labelStyle: TextStyle(
            fontSize: FontSize.s18,
            color: primaryColor,
          ),
        ),
      ),
    );
  }
}

class OutlineTextField extends StatelessWidget {
  final String hintText;
  final String labelText;
  final TextEditingController controller;
  final String Function(String) validator;
  final double height;
  final TextStyle hintStyle;
  final TextStyle labelStyle;
  final bool obscureText;
  final Widget suffixIcon;
  final Widget prefixIcon;
  final Widget prefix;
  final TextInputType textInputType;
  final bool enable;
  final int maxLength;
  final bool autoFocus;

  OutlineTextField({
    this.hintText,
    this.labelText,
    this.controller,
    this.height,
    this.hintStyle,
    this.labelStyle,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.prefix,
    this.textInputType,
    this.enable = true,
    this.validator,
    this.maxLength,
    this.autoFocus = true
  });
  @override
  Widget build(BuildContext context) {
    final ThemeData mode = Theme.of(context);
    return Container(
      child: TextFormField(
        enabled: enable,
        maxLength: maxLength,
        controller: controller,
        validator: validator,
        obscureText: obscureText,
        keyboardType: textInputType,
        autofocus: autoFocus,
        decoration: InputDecoration(
          prefix: prefix,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon != null ? IconButton(
            icon: prefixIcon,
            iconSize: Sizes.s24,
          ) : prefixIcon,
          hintText: "$hintText",
          hintStyle: GoogleFonts.heebo(
            color: inputHint,
            fontWeight: FontWeight.w500,
            fontSize: FontSize.s14,
            fontStyle: FontStyle.normal
          ),
          counterText: '',
          counterStyle: TextStyle(fontSize: 0),
          isDense: true,
          contentPadding: EdgeInsets.fromLTRB(Sizes.s30, Sizes.s30, Sizes.s30, 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(Sizes.s10)),
            borderSide: !autoFocus ? BorderSide.none : BorderSide(width: Sizes.s1, color: secondaryColor, style: BorderStyle.solid),
          ),
          fillColor: inputBg,
          filled: enable,
        ),
      ),
    );
  }
}
