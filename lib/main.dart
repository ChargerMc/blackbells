import 'package:blackbells/services/notification_service.dart';
import 'package:blackbells/providers/secure_storage_provider.dart';
import 'package:blackbells/routes/routes.dart';
import 'package:blackbells/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'global/environment.dart';
import 'services/navigation_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SecureStorage.configurePrefs();
  Environment().initConfig(
      const String.fromEnvironment('ENV', defaultValue: Environment.prod));
  NotificationService.init();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
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
