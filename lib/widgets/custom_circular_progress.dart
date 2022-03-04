import 'package:flutter/material.dart';

class CustomCircularProgressIndicator extends StatelessWidget {
  const CustomCircularProgressIndicator({Key? key, this.heightFactor})
      : super(key: key);
  final double? heightFactor;

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: heightFactor,
      child: const CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    );
  }
}
