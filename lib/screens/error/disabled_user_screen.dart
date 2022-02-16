import 'package:blackbells/providers/backend_provider.dart';
import 'package:blackbells/routes/routes.dart';
import 'package:blackbells/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../services/navigation_service.dart';
import '../../providers/push_notification_provider.dart';
import '../../providers/socket_provider.dart';

class DisabledUserScreen extends ConsumerStatefulWidget {
  const DisabledUserScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DisabledUserScreenState();
}

class _DisabledUserScreenState extends ConsumerState<DisabledUserScreen> {
  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    final socket = ref.read(socketProvider);
    if (socket.serverStatus != ServerStatus.online) {
      await socket.connect();
    }
    await ref.read(pushNotificationProvider).initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    final _textTheme = Theme.of(context).textTheme;
    final user = ref.watch(userProvider);
    final backend = ref.watch(backendProvider);
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            LottieBuilder.asset(
              'assets/lotties/user_desactivated.json',
              height: width * 0.7,
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Tu usuario no está activado.',
                  textAlign: TextAlign.center,
                  style: _textTheme.headline4,
                  textScaleFactor: 1,
                ),
                const SizedBox(height: 8),
                Text(
                  user.email,
                  style: _textTheme.headline6!.copyWith(color: Colors.white54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Solicita tu activación a un administrador BlackBells.',
                  textAlign: TextAlign.center,
                  style: _textTheme.headline6!.copyWith(color: Colors.white54),
                ),
              ],
            ),
            const Spacer(),
            CustomButton(
              child: const Text('Reintentar'),
              onPressed: () =>
                  NavigationService.replaceTo(BlackbellsRoutes.loading),
            ),
            CustomButton(
              isCancel: true,
              child: const Text('Cerrar sesión'),
              onPressed: () async => await backend.logout(),
            ),
          ],
        ),
      ),
    );
  }
}
