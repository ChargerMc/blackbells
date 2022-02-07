import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    this.onPressed,
    this.child,
    this.padding = EdgeInsets.zero,
    this.isCancel = false,
  }) : super(key: key);

  final void Function()? onPressed;
  final Widget? child;
  final EdgeInsetsGeometry padding;
  final bool isCancel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double?>(isCancel ? 0.0 : null),
          backgroundColor: MaterialStateProperty.all<Color?>(
              isCancel ? Colors.transparent : null),
          foregroundColor: MaterialStateProperty.all<Color?>(
              isCancel ? Colors.white70 : null),
          textStyle: MaterialStateProperty.all<TextStyle>(
            GoogleFonts.roboto(
              fontSize: 18,
            ),
          ),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.all(24),
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
