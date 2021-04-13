import 'package:flutter/material.dart';
import 'package:coinpay/src/utils/colors.dart';
import 'package:coinpay/src/utils/sizes.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

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
  final Function onTap;
  final FocusNode focusNode;

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
    this.onTap,
    this.focusNode
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
        focusNode: focusNode,
        decoration: InputDecoration(
          prefix: prefix,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
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
            borderSide: focusNode.hasFocus ? BorderSide(width: Sizes.s1, color: secondaryColor, style: BorderStyle.solid) : BorderSide.none,
          ),
          fillColor: inputBg,
          filled: enable,
        ),
      ),
    );
  }
}

class OutlinePinField extends StatelessWidget {
  final TextEditingController controller;
  final String Function(String) validator;
  final int length;
  final FocusNode focusNode;
  final BuildContext appContext;

  OutlinePinField({
    this.controller,
    this.validator,
    this.length,
    this.focusNode,
    this.appContext
  });
  @override
  Widget build(BuildContext context) {
    final ThemeData mode = Theme.of(context);
    return Container(
      child: PinCodeTextField(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        focusNode: focusNode,
        appContext: appContext,
        length: length != null ? length : 6,
        controller: controller,
        textStyle: GoogleFonts.heebo(
          fontSize: FontSize.s14,
          fontStyle: FontStyle.normal,
          fontWeight: FontWeight.w400,
        ),
        pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.circular(Sizes.s10),
          borderWidth: 0,
          fieldHeight: Sizes.s50,
          fieldWidth: Sizes.s50,
          activeFillColor: Colors.indigoAccent,
          selectedFillColor: Colors.indigo,
          activeColor: Colors.indigo,
          selectedColor: Colors.indigo,
        ),
        cursorColor: Colors.black,
        animationDuration: Duration(milliseconds: 300),
        keyboardType: TextInputType.number,
        boxShadows: [
          BoxShadow(
            offset: Offset(0, 1),
            color: inputBg,
            blurRadius: Sizes.s10,
          )
        ],
        beforeTextPaste: (text) {
          print("Allowing to paste $text");
          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
          //but you can show anything you want here, like your pop up saying wrong paste format or etc
          return true;
        },
        validator: validator,
        onChanged: (String value){},
      ),
    );
  }
}
