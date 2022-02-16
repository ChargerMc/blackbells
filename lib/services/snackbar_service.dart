import 'package:blackbells/services/navigation_service.dart';
import 'package:flutter/material.dart';

class SnackService {
  static final _context = NavigationService.navigatorKey.currentContext!;
  static showBanner({
    void Function()? onVisible,
    required dynamic content,
    required List<Widget> actions,
    Color? backgroundColor,
    TextStyle? contentTextStyle,
    Widget? leading,
    EdgeInsetsGeometry? padding,
  }) {
    return ScaffoldMessenger.of(_context).showMaterialBanner(
      MaterialBanner(
        padding: padding,
        leading: leading,
        contentTextStyle: contentTextStyle,
        backgroundColor: backgroundColor,
        onVisible: onVisible,
        content: (content is Widget) ? content : Text(content.toString()),
        actions: actions,
      ),
    );
  }

  static void close() {
    return ScaffoldMessenger.of(_context).hideCurrentMaterialBanner();
  }
}
