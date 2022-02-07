import 'package:flutter/material.dart';

class CaptionWidget extends StatelessWidget {
  const CaptionWidget({Key? key, required this.text, required this.icon})
      : super(key: key);
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final _textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0, top: 4.0),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(icon, size: 18),
          ),
          Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: _textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}
