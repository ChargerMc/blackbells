import 'package:flutter/material.dart';

class CustomTitle extends StatelessWidget {
  const CustomTitle({
    Key? key,
    required this.title,
    this.subtitle,
    this.padding = EdgeInsets.zero,
    this.onPressed,
    this.icon,
  }) : super(key: key);
  final String title;
  final String? subtitle;
  final EdgeInsetsGeometry padding;
  final void Function()? onPressed;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final _textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: _textTheme.headline4,
                textScaleFactor: 1,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle ?? '',
                textScaleFactor: 1,
                style: _textTheme.bodyText1,
              ),
            ],
          ),
          icon != null
              ? ElevatedButton(
                  onPressed: onPressed,
                  child: icon,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(14),
                    primary: Colors.white10,
                    onPrimary: Colors.white,
                  ),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
