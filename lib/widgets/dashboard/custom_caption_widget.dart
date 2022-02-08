import 'package:flutter/material.dart';

class CaptionWidget extends StatelessWidget {
  const CaptionWidget(
      {Key? key, this.onPressed, required this.text, required this.icon})
      : super(key: key);
  final String text;
  final IconData icon;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final _textTheme = Theme.of(context).textTheme;

    return TextButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          onPressed != null
              ? const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0)
              : const EdgeInsets.only(left: 8.0),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(icon, size: 18),
          ),
          Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: _textTheme.bodyText1,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
