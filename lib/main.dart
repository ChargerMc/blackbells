import 'package:blackbells/providers/push_notification_provider.dart';
import 'package:blackbells/providers/secure_storage_provider.dart';
import 'package:blackbells/routes/routes.dart';
import 'package:blackbells/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'global/environment.dart';
import 'providers/navigation_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SecureStorage.configurePrefs();
  await PushNotificationProvider.initializeApp();
  String environment = const String.fromEnvironment(
    'ENV',
    defaultValue: Environment.dev,
  );
  Environment().initConfig(environment);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: blackbellsTheme,
      themeMode: ThemeMode.dark,
      navigatorKey: NavigationService.navigatorKey,
      debugShowCheckedModeBanner: false,
      routes: BlackbellsRoutes.routes,
      initialRoute: BlackbellsRoutes.loading,
    );
  }
}
