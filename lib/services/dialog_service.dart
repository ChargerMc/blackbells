import 'package:blackbells/services/navigation_service.dart';
import 'package:flutter/material.dart';

class DialogService {
  static final _context = NavigationService.navigatorKey.currentContext!;

  static Future<dynamic> show({
    required String title,
    String? content,
    List<Widget>? actions,
  }) async {
    return await showDialog(
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
}
