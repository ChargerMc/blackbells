import 'package:blackbells/providers/backend_provider.dart';
import 'package:blackbells/services/dialog_service.dart';
import 'package:blackbells/services/navigation_service.dart';
import 'package:blackbells/widgets/custom_button.dart';
import 'package:blackbells/widgets/profile/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backend = ref.watch(backendProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const EditProfileWidget(),
            CustomButton(
              isCancel: true,
              child: const Text('Cerrar sesión'),
              onPressed: () => DialogService.show(
                title: '¿Cerrar sesión?',
                actions: [
                  CustomButton(
                    child: const Text('Confirmar'),
                    onPressed: () => NavigationService.pop(true),
                  ),
                  CustomButton(
                    isCancel: true,
                    child: const Text('Cancelar'),
                    onPressed: () => NavigationService.pop(false),
                  ),
                ],
              ).then(
                (value) async => (value != null && value == true)
                    ? await backend.logout()
                    : null,
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
