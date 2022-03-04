import 'package:blackbells/providers/backend_provider.dart';
import 'package:blackbells/services/dialog_service.dart';
import 'package:blackbells/services/navigation_service.dart';
import 'package:blackbells/widgets/custom_button.dart';
import 'package:blackbells/widgets/profile/profile_widget.dart';
import 'package:blackbells/widgets/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backend = ref.watch(backendProvider);
    final user = ref.watch(userProvider);
    final _textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            onPressed: () => DialogService.showBottomPage(
              const SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 48),
                  child: EditProfileWidget()),
              isScrollControlled: true,
              isDismissible: false,
            ),
            icon: const Icon(Icons.edit_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: user.img,
                    width: 100,
                    height: 100,
                    placeholder: (_, __) => const ShimmerEffect(
                      width: 100,
                      height: 50,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Flexible(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      child: Text(
                        user.name,
                        style: _textTheme.headline4,
                      ),
                    ),
                    Text(
                      user.email,
                      style:
                          const TextStyle(color: Colors.white54, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      user.phonenumber,
                      style:
                          const TextStyle(color: Colors.white54, fontSize: 18),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            ...ListTile.divideTiles(
              tiles: [
                ListTile(
                  leading: const Icon(Icons.bloodtype_rounded),
                  title: Text(
                    user.bloodtype,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: _textTheme.titleLarge!.fontSize,
                    ),
                  ),
                  subtitle: const Text('Tipo de sangre'),
                ),
                ListTile(
                  leading: const Icon(Icons.warning_rounded),
                  title: Text(
                    user.allergies,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: _textTheme.titleLarge!.fontSize,
                    ),
                  ),
                  isThreeLine: true,
                  subtitle: const Text('Alergias'),
                ),
                ListTile(
                  leading: const Icon(Icons.two_wheeler_rounded),
                  title: Text(
                    user.motorcycle,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: _textTheme.titleLarge!.fontSize,
                    ),
                  ),
                  subtitle: const Text('Motocicleta'),
                ),
                ListTile(
                  leading: const Icon(Icons.bolt_rounded),
                  title: Text(
                    user.cubiccapacity,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: _textTheme.titleLarge!.fontSize,
                    ),
                  ),
                  subtitle: const Text('CC'),
                ),
                ListTile(
                  leading: const Icon(Icons.palette_rounded),
                  title: Text(
                    user.color,
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: _textTheme.titleLarge!.fontSize,
                    ),
                  ),
                  subtitle: const Text('color'),
                ),
              ],
              context: context,
            ),
            const SizedBox(height: 14),
            CustomButton(
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
