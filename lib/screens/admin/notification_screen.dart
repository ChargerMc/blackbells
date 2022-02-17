import 'package:blackbells/providers/backend_provider.dart';
import 'package:blackbells/services/dialog_service.dart';
import 'package:blackbells/services/navigation_service.dart';
import 'package:blackbells/widgets/custom_button.dart';
import 'package:blackbells/widgets/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationScreenState();
}

TextEditingController title = TextEditingController();
TextEditingController body = TextEditingController();
bool isSending = false;

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  void dispose() {
    title.dispose();
    body.dispose();
    isSending = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enviar notificación'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomInput(
              enabled: !isSending,
              hintText: 'Título',
              controller: title,
              textInputAction: TextInputAction.next,
              onChanged: (_) => setState(() {}),
            ),
            CustomInput(
              enabled: !isSending,
              delay: const Duration(milliseconds: 200),
              maxLines: 6,
              hintText: 'Cuerpo del mensaje',
              padding: const EdgeInsets.symmetric(vertical: 18),
              controller: body,
              onChanged: (_) => setState(() {}),
              onEditingComplete:
                  !isSending && title.text.length > 3 && body.text.length > 3
                      ? () => _summit()
                      : null,
            ),
            CustomButton(
              padding: const EdgeInsets.only(top: 18),
              child: const Text('Enviar'),
              onPressed:
                  !isSending && title.text.length > 3 && body.text.length > 3
                      ? () => _summit()
                      : null,
            )
          ],
        ),
      ),
    );
  }

  void _summit() {
    DialogService.show(
      title: '¿Estás seguro?',
      content:
          'Enviarás una notificación con la siguiente información: \n\nTítulo: ${title.text}\n\nContenido: ${body.text}',
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
      (value) async {
        setState(() => isSending = true);
        if (value != null && value) {
          try {
            final resp = await ref
                .read(backendProvider)
                .sendPushNotification(title.text, body: body.text);
            if (resp) NavigationService.pop();
            setState(() => isSending = false);
          } catch (e) {
            setState(() => isSending = false);
          }
        }
      },
    );
    setState(() => isSending = false);
  }
}
