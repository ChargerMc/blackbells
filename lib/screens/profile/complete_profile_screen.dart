import 'package:blackbells/widgets/profile/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompleteProfileScreen extends ConsumerStatefulWidget {
  const CompleteProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends ConsumerState<CompleteProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final _textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Completa tu perfil.',
                textScaleFactor: 1,
                style: _textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Es muy importante que tu perfil esté completo, para rodar con BlackBells.',
                style: _textTheme.bodyLarge,
              ),
              const Divider(height: 24),
              const ProfileWidget(),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
