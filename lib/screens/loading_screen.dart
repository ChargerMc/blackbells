import 'package:blackbells/providers/backend_provider.dart';
import 'package:blackbells/services/navigation_service.dart';
import 'package:blackbells/providers/socket_provider.dart';
import 'package:blackbells/screens/auth/auth_screen.dart';
import 'package:blackbells/screens/dashboard_screen.dart';
import 'package:blackbells/screens/error/disabled_user_screen.dart';
import 'package:blackbells/theme/theme.dart';
import 'package:blackbells/widgets/custom_circular_progress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'error/server_disconnected_screen.dart';

class LoadingScreen extends ConsumerStatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends ConsumerState<LoadingScreen> {
  @override
  void initState() {
    auth();
    super.initState();
  }

  auth() async {
    final backend = ref.read(backendProvider);
    final socket = ref.read(socketProvider);

    final auth = await backend.authenticate();

    if (auth == Authenticated.error) {
      return NavigationService.replaceAnimatedTo(
          const ServerDisconnectedScreen());
    }

    if (auth == Authenticated.logged) {
      final user = ref.read(userProvider);
      if (user.enabled == false) {
        return NavigationService.replaceAnimatedTo(const DisabledUserScreen());
      }
      await socket.connect();
      return NavigationService.replaceAnimatedTo(const DashboardScreen());
    } else {
      return NavigationService.replaceAnimatedTo(const AuthScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: blackbellsColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logos/logo.png',
                  width: width * 0.6,
                ),
                const SizedBox(height: 14),
                const CustomCircularProgressIndicator()
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Image.asset(
              'assets/logos/sp3_logo.png',
              width: width * 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
