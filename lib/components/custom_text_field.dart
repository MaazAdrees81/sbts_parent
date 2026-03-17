import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../globals/constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    this.width,
    this.height,
    this.inputFormatters,
    this.textInputAction,
    this.keyboardType,
    this.controller,
    this.node,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
    this.obscureText = false,
    this.onChanged,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.errorText,
    this.suffix,
    this.suffixIcon,
    this.prefix,
    this.prefixIcon,
    this.textAlign = TextAlign.start,
    this.style,
    this.labelText,
    this.helperText,
    this.hintText,
    this.hintTextStyle,
    this.isDense = true,
    this.enableBorder,
    this.isFilled = true,
    this.hasBorders = true,
    this.hasShadow = false,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.prefixIconConstraints = const BoxConstraints.tightFor(width: 48, height: 48),
    this.suffixIconConstraints = const BoxConstraints.tightFor(width: 48, height: 48),
    this.autofocus = false,
    this.fillColor = Colors.white,
    this.textColor = Colors.black,
    this.initialValue,
    this.isError = false,
    this.borderRadius = 8,
    this.cursorHeight,
    super.key,
  });

  final String? labelText;
  final String? errorText;
  final String? helperText;
  final String? hintText;
  final String? initialValue;
  final TextStyle? style;
  final TextStyle? hintTextStyle;
  final int maxLines;
  final int minLines;
  final double? height;
  final double? width;
  final bool obscureText;
  final bool isDense;
  final bool readOnly;
  final bool isError;
  final bool autofocus;
  final bool hasBorders;
  final BorderSide? enableBorder;
  final bool hasShadow;
  final Function(String)? onChanged;
  final Function()? onEditingComplete;
  final Function(String)? onFieldSubmitted;
  final EdgeInsets contentPadding;
  final FocusNode? node;
  final TextEditingController? controller;
  final TextAlign textAlign;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final BoxConstraints prefixIconConstraints;
  final BoxConstraints suffixIconConstraints;
  final Widget? suffix;
  final Widget? suffixIcon;
  final Widget? prefix;
  final Widget? prefixIcon;
  final Color? fillColor;
  final double borderRadius;
  final double? cursorHeight;
  final bool isFilled;
  final List<TextInputFormatter>? inputFormatters;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: TextFormField(
        initialValue: initialValue,
        onChanged: onChanged,
        textAlign: textAlign,
        inputFormatters: inputFormatters,
        onEditingComplete: onEditingComplete,
        onFieldSubmitted: onFieldSubmitted,
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        focusNode: node,
        readOnly: readOnly,
        obscureText: obscureText,
        autofocus: autofocus,
        cursorRadius: const Radius.circular(15),
        cursorWidth: 1.5,
        maxLines: maxLines,
        minLines: minLines,
        cursorHeight: 20,
        cursorColor: (style ?? TextStyle(color: textColor, fontSize: 16)).color,
        style: style ?? TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          filled: isFilled,
          fillColor: fillColor,
          isDense: isDense,
          alignLabelWithHint: true,
          contentPadding: contentPadding,
          labelText: labelText,
          labelStyle: const TextStyle(color: kGrey, fontSize: 14),
          helperText: helperText,
          helperStyle: const TextStyle(color: kGrey, fontSize: 10, height: 0.05),
          hintText: hintText,
          hintStyle: hintTextStyle ?? const TextStyle(color: kMidGrey, fontSize: 16, fontWeight: FontWeight.w500),
          prefixIcon: prefixIcon,
          errorText: errorText,
          errorStyle: const TextStyle(color: kRed, fontSize: 10, height: 0.5),
          prefixIconConstraints: prefixIconConstraints,
          suffixIconConstraints: suffixIconConstraints,
          suffix: suffix,
          suffixIcon: suffixIcon,
          prefix: prefix,
          enabledBorder: OutlineInputBorder(
            borderSide: hasBorders ? enableBorder ?? BorderSide(width: 1.2, color: isError ? Colors.red.shade700 : kMidGrey) : BorderSide.none,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: hasBorders ? enableBorder ?? BorderSide(width: 1.2, color: isError ? Colors.red.shade200 : kMidGrey) : BorderSide.none,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          border: OutlineInputBorder(
            borderSide: hasBorders ? enableBorder ?? BorderSide(width: 1.2, color: isError ? Colors.red.shade700 : kMidGrey) : BorderSide.none,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: hasBorders ? BorderSide(width: 1.2, color: isError ? Colors.red.shade700 : kDarkGrey) : BorderSide.none,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: hasBorders ? BorderSide(width: 1.2, color: Colors.red.shade700) : BorderSide.none,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: hasBorders ? BorderSide(width: 1.2, color: Colors.red.shade700) : BorderSide.none,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}
