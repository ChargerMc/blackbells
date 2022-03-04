import 'package:blackbells/services/navigation_service.dart';
import 'package:flutter/material.dart';

class DialogService {
  static final _context = NavigationService.navigatorKey.currentContext!;

  static Future<dynamic> show({
    required String title,
    String? content,
    List<Widget>? actions,
    bool isDismissible = true,
  }) async {
    return await showDialog(
      barrierDismissible: isDismissible,
      context: _context,
      builder: (_context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        title: Text(title),
        content: content != null ? Text(content) : null,
        actions: actions != null
            ? [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: actions,
                )
              ]
            : null,
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.all(8),
      ),
    );
  }

  static void showBottomPage(
    Widget child, {
    Color? backgroundColor,
    bool? enableDrag,
    bool isDismissible = true,
    bool isScrollControlled = false,
  }) async {
    showModalBottomSheet(
      context: _context,
      builder: (context) => child,
      isDismissible: isDismissible,
      isScrollControlled: isScrollControlled,
      backgroundColor: backgroundColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18), topRight: Radius.circular(18))),
    );
  }
}
