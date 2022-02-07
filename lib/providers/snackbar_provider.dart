import 'package:blackbells/providers/navigation_provider.dart';
import 'package:flutter/material.dart';

final context = NavigationService.navigatorKey.currentState!.context;

class SnackService {
  static showBanner({
    void Function()? onVisible,
    required dynamic content,
    required List<Widget> actions,
    Color? backgroundColor,
    TextStyle? contentTextStyle,
    Widget? leading,
    EdgeInsetsGeometry? padding,
  }) {
    return ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        padding: padding,
        leading: leading,
        contentTextStyle: contentTextStyle,
        backgroundColor: backgroundColor,
        onVisible: onVisible,
        content: (content is Widget) ? content : Text(content),
        actions: actions,
      ),
    );
  }

  static void close() {
    return ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
  }
}
