import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomInput extends StatelessWidget {
  const CustomInput({
    Key? key,
    this.controller,
    this.keyboardType,
    this.onChanged,
    this.onEditingComplete,
    this.errorText,
    this.obscureText = false,
    this.enabled,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.padding = EdgeInsets.zero,
    this.autofillHints,
    this.textInputAction,
    this.animate = true,
    this.delay = const Duration(milliseconds: 0),
    this.validator,
  }) : super(key: key);

  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final EdgeInsetsGeometry padding;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final bool obscureText;
  final bool? enabled;
  final TextInputType? keyboardType;
  final void Function(String text)? onChanged;
  final void Function()? onEditingComplete;
  final String? errorText;
  final String? hintText;
  final bool animate;
  final Duration delay;
  final String? Function(String? text)? validator;

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      animate: animate,
      delay: delay,
      child: Padding(
        padding: padding,
        child: TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: validator,
          textInputAction: textInputAction,
          enabled: enabled,
          autofillHints: autofillHints,
          style: GoogleFonts.roboto(),
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged,
          onEditingComplete: onEditingComplete,
          decoration: _buildInputDecoration(),
          cursorColor: Colors.white,
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration() => InputDecoration(
        errorMaxLines: 2,
        errorStyle: const TextStyle(fontSize: 14),
        errorText: errorText,
        filled: true,
        fillColor:
            enabled ?? true ? Colors.white10 : Colors.white.withOpacity(0.05),
        contentPadding: const EdgeInsets.all(24),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(style: BorderStyle.none),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(style: BorderStyle.none),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.white),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(style: BorderStyle.none),
        ),
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      );
}
