import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../routes/routes.dart';

class AdminScreen extends ConsumerWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin dashboard'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.people_alt_rounded),
              title: const Text('Usuarios'),
              trailing: const Icon(Icons.arrow_forward_ios_rounded),
              onTap: () => Navigator.pushNamed(context, BlackbellsRoutes.users),
            ),
          ],
        ),
      ),
    );
  }
}
