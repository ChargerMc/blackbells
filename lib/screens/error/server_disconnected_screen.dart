import 'package:blackbells/services/navigation_service.dart';
import 'package:blackbells/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../routes/routes.dart';

class ServerDisconnectedScreen extends StatelessWidget {
  const ServerDisconnectedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LottieBuilder.asset('assets/lotties/disconnect.json'),
            Column(
              children: [
                Text(
                  'Sin conexión al servidor.',
                  textAlign: TextAlign.center,
                  style: _textTheme.headline4,
                  textScaleFactor: 1,
                ),
                const SizedBox(height: 8),
                Text(
                  'Intenta más tarde.',
                  style: _textTheme.headline6!.copyWith(color: Colors.white54),
                ),
              ],
            ),
            CustomButton(
                child: const Text('Reintentar'),
                onPressed: () =>
                    NavigationService.replaceTo(BlackbellsRoutes.loading))
          ],
        ),
      ),
    );
  }
}
