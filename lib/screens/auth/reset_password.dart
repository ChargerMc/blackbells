import 'package:blackbells/providers/backend_provider.dart';
import 'package:blackbells/screens/dashboard_screen.dart';
import 'package:blackbells/services/dialog_service.dart';
import 'package:blackbells/services/navigation_service.dart';
import 'package:blackbells/widgets/custom_button.dart';
import 'package:blackbells/widgets/custom_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../error/disabled_user_screen.dart';

enum RecoverState { email, code, password }

class ResetPassword extends ConsumerStatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResetPasswordState();
}

bool isEnabled = true;
bool isVisible = false;
TextEditingController _email = TextEditingController();
TextEditingController _code = TextEditingController();
TextEditingController _password = TextEditingController();
TextEditingController _password2 = TextEditingController();
RecoverState state = RecoverState.email;

class _ResetPasswordState extends ConsumerState<ResetPassword> {
  @override
  void initState() {
    state = RecoverState.email;
    super.initState();
  }

  @override
  void dispose() {
    _email.clear();
    _password.clear();
    _password2.clear();
    _code.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar contraseña'),
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (state == RecoverState.email) return true;

          return await DialogService.show(
            title: '¿Estás seguro?',
            content:
                'Al salir perderás tu progreso, en el proceso de recuperar tu contraseña.',
            actions: [
              CustomButton(
                  child: const Text('Salir'),
                  onPressed: () => NavigationService.pop(true)),
              CustomButton(
                  child: const Text('Cancelar'),
                  isCancel: true,
                  onPressed: () => NavigationService.pop(false)),
            ],
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                state == RecoverState.email
                    ? 'Ingresa tu correo electrónico.'
                    : state == RecoverState.code
                        ? 'Ingresa el código que te hemos enviado.'
                        : state == RecoverState.password
                            ? 'Ingresa tu nueva contraseña.'
                            : '¡Felicidades!',
                style: _textTheme.headlineMedium,
              ),
              const SizedBox(height: 14),
              AutofillGroup(child: _recoverState(state)),
              CustomButton(
                child: const Text('Continuar'),
                onPressed: isEnabled && validate(state) == null
                    ? () => _submit()
                    : null,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _recoverState(RecoverState state) {
    switch (state) {
      case RecoverState.email:
        return CustomInput(
          autofillHints: const [AutofillHints.email],
          onChanged: (_) => setState(() {}),
          controller: _email,
          enabled: isEnabled,
          prefixIcon: const Icon(Icons.email_rounded),
          hintText: 'Correo electrónico',
          keyboardType: TextInputType.emailAddress,
          padding: const EdgeInsets.only(bottom: 14),
          errorText: validate(state),
        );
      case RecoverState.code:
        return CustomInput(
          maxLength: 4,
          onChanged: (_) => setState(() {}),
          controller: _code,
          enabled: isEnabled,
          prefixIcon: const Icon(Icons.pin_rounded),
          hintText: 'Código',
          keyboardType: TextInputType.number,
          padding: const EdgeInsets.only(bottom: 14),
          errorText: validate(state),
        );
      case RecoverState.password:
        return Column(
          children: [
            CustomInput(
              autofillHints: const [AutofillHints.newPassword],
              enabled: isEnabled,
              controller: _password,
              prefixIcon: const Icon(Icons.lock),
              hintText: 'Contraseña',
              obscureText: !isVisible,
              keyboardType: TextInputType.visiblePassword,
              padding: const EdgeInsets.only(bottom: 8),
              onChanged: (_) => setState(() {}),
              textInputAction: TextInputAction.next,
              suffixIcon: IconButton(
                icon: Icon(
                  !isVisible
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_outlined,
                ),
                onPressed: () => setState(() => isVisible = !isVisible),
              ),
              errorText: validate(state),
            ),
            CustomInput(
              delay: const Duration(milliseconds: 200),
              enabled: isEnabled,
              autofillHints: const [AutofillHints.newPassword],
              controller: _password2,
              prefixIcon: const Icon(Icons.lock),
              hintText: 'Confirmar contraseña',
              obscureText: !isVisible,
              keyboardType: TextInputType.visiblePassword,
              padding: const EdgeInsets.only(bottom: 14),
              onChanged: (_) => setState(() {}),
              textInputAction: TextInputAction.done,
              suffixIcon: IconButton(
                icon: Icon(
                  !isVisible
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_outlined,
                ),
                onPressed: () => setState(() => isVisible = !isVisible),
              ),
              onEditingComplete: () => _submit(),
            ),
          ],
        );
    }
  }

  void _submit() async {
    final backend = ref.read(backendProvider);
    FocusScope.of(context).unfocus();
    isVisible = false;
    setState(() => isEnabled = false);
    switch (state) {
      case RecoverState.email:
        await backend.resetPassword(_email.text.trim()).then((value) {
          if (!value) return;
          state = RecoverState.code;
        });
        setState(() => isEnabled = true);
        break;
      case RecoverState.code:
        await backend
            .validateCode(_email.text.trim(), _code.text.trim())
            .then((value) {
          if (!value) return;
          state = RecoverState.password;
        });
        setState(() => isEnabled = true);
        break;
      case RecoverState.password:
        await backend
            .changePassword(
                _email.text.trim(), _code.text.trim(), _password.text.trim())
            .then((value) {
          if (!value) return;
          final user = ref.read(userProvider);
          if (user.enabled == false) {
            _password2.clear();
            _code.clear();
            _email.clear();
            _password.clear();
            return NavigationService.replaceAnimatedTo(
                const DisabledUserScreen());
          }
          TextInput.finishAutofillContext();
          NavigationService.replaceAnimatedTo(const DashboardScreen());
        });
        setState(() => isEnabled = true);
        break;
    }
    setState(() {});
  }

  String? validate(RecoverState state) {
    switch (state) {
      case RecoverState.email:
        final validEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
        if (!validEmail.hasMatch(_email.text)) {
          return 'Ingresa un correo válido.';
        }
        break;
      case RecoverState.code:
        if (_code.text.length < 4) return 'Ingrese el código.';
        break;
      case RecoverState.password:
        if (_password.text.length < 5) {
          return 'La contraseña debe ser mayor a 6 carácteres.';
        }
        if (_password2.text.length > 3 &&
            _password.text.trim() != _password2.text.trim()) {
          return 'Las contraseñas no coinciden';
        }
        final reg = RegExp(r' ');
        if (reg.hasMatch(_password.text)) return 'Los espacio no son aceptados';
        break;
    }
    setState(() {});
    return null;
  }
}
