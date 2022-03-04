import 'package:blackbells/screens/admin/admin_screen.dart';
import 'package:blackbells/screens/admin/notification_screen.dart';
import 'package:blackbells/screens/admin/users_screen.dart';
import 'package:blackbells/screens/auth/auth_screen.dart';
import 'package:blackbells/screens/auth/reset_password.dart';
import 'package:blackbells/screens/dashboard_screen.dart';
import 'package:blackbells/screens/loading_screen.dart';
import 'package:blackbells/screens/profile_screen.dart';
import 'package:flutter/material.dart';

class BlackbellsRoutes {
  static const String loading = 'loading';
  static const String dashboard = 'dashboard';
  static const String auth = 'auth';
  static const String profile = 'profile';
  static const String admin = 'admin';
  static const String users = 'users';
  static const String sendNotification = 'sendNotification';
  static const String passwordReset = 'passwordReset';

  static final Map<String, Widget Function(BuildContext)> routes = {
    loading: (_) => const LoadingScreen(),
    dashboard: (_) => const DashboardScreen(),
    auth: (_) => const AuthScreen(),
    profile: (_) => const ProfileScreen(),
    admin: (_) => const AdminScreen(),
    users: (_) => const UsersScreen(),
    sendNotification: (_) => const NotificationScreen(),
    passwordReset: (_) => const ResetPassword(),
  };
}
