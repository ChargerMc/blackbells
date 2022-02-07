import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../custom_input.dart';

enum Authtype { login, register }

class AuthFormWidget extends StatelessWidget {
  const AuthFormWidget({
    Key? key,
    required this.onEditingComplete,
    required this.isEnabled,
    required this.isVisible,
    required this.email,
    required this.password,
    required this.onChanged,
    required this.onPressed,
    this.type = Authtype.login,
    required this.phonenumber,
    required this.password2,
  }) : super(key: key);

  final bool isEnabled;
  final bool isVisible;
  final void Function() onEditingComplete;
  final void Function() onPressed;
  final TextEditingController phonenumber;
  final TextEditingController email;
  final TextEditingController password;
  final TextEditingController password2;
  final void Function(String) onChanged;
  final Authtype type;

  @override
  Widget build(BuildContext context) {
    final _textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FadeInLeft(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  type == Authtype.login ? 'Ingresar' : 'Postularme',
                  style: _textTheme.headline4,
                ),
                const SizedBox(height: 14),
                Text(
                  type == Authtype.login
                      ? 'Bienvenido/a rider. \nTe hemos extrañado.'
                      : '¿Listo/a para la aventura?',
                  style: _textTheme.headline5,
                ),
              ],
            ),
          ),
        ),
        _authType(type, context),
      ],
    );
  }

  Widget _authType(Authtype type, BuildContext context) {
    switch (type) {
      case Authtype.register:
        return _register(context);
      default:
        return _login();
    }
  }

  Widget _login() => Column(
        children: [
          CustomInput(
            delay: const Duration(milliseconds: 400),
            enabled: isEnabled,
            autofillHints: const [AutofillHints.email],
            controller: email,
            prefixIcon: const Icon(Icons.email),
            hintText: 'Email',
            keyboardType: TextInputType.emailAddress,
            padding: const EdgeInsets.only(bottom: 8),
            textInputAction: TextInputAction.next,
            onChanged: onChanged,
          ),
          CustomInput(
              delay: const Duration(milliseconds: 600),
              enabled: isEnabled,
              autofillHints: const [AutofillHints.password],
              controller: password,
              prefixIcon: const Icon(Icons.lock),
              hintText: 'Contraseña',
              obscureText: !isVisible,
              keyboardType: TextInputType.visiblePassword,
              padding: const EdgeInsets.only(bottom: 8),
              onChanged: onChanged,
              suffixIcon: IconButton(
                  icon: Icon(
                    !isVisible
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_outlined,
                  ),
                  onPressed: onPressed),
              onEditingComplete: onEditingComplete),
        ],
      );

  Widget _register(BuildContext context) {
    return Column(
      children: [
        CustomInput(
          validator: FormBuilderValidators.numeric(context,
              errorText: 'Debe ser un número de teléfono válido.'),
          enabled: isEnabled,
          controller: phonenumber,
          prefixIcon: const Icon(Icons.phone),
          hintText: 'WhatsApp',
          keyboardType: TextInputType.phone,
          padding: const EdgeInsets.only(bottom: 8),
          textInputAction: TextInputAction.next,
          onChanged: onChanged,
        ),
        CustomInput(
          validator: FormBuilderValidators.email(context,
              errorText: 'Debe ser un correo electrónico válido.'),
          enabled: isEnabled,
          autofillHints: const [AutofillHints.email],
          controller: email,
          prefixIcon: const Icon(Icons.email),
          hintText: 'Email',
          keyboardType: TextInputType.emailAddress,
          padding: const EdgeInsets.only(bottom: 8),
          textInputAction: TextInputAction.next,
          onChanged: onChanged,
        ),
        CustomInput(
          validator: FormBuilderValidators.compose([
            FormBuilderValidators.minLength(
              context,
              5,
              errorText: 'La contraseña debe ser mayor a 5 carácteres.',
            ),
            (input) {
              final reg = RegExp(r' ');
              if (reg.hasMatch(input!)) return 'Los espacio no son aceptados';
              return null;
            }
          ]),
          delay: const Duration(milliseconds: 200),
          enabled: isEnabled,
          controller: password,
          prefixIcon: const Icon(Icons.lock),
          hintText: 'Contraseña',
          obscureText: !isVisible,
          keyboardType: TextInputType.visiblePassword,
          padding: const EdgeInsets.only(bottom: 8),
          onChanged: onChanged,
          textInputAction: TextInputAction.next,
          suffixIcon: IconButton(
            icon: Icon(
              !isVisible
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_outlined,
            ),
            onPressed: onPressed,
          ),
        ),
        CustomInput(
          errorText: password2.text.length >= 5 &&
                  password.text.trim() != password2.text.trim()
              ? 'Las contraseñas no coinciden.'
              : null,
          delay: const Duration(milliseconds: 400),
          enabled: isEnabled,
          autofillHints: const [AutofillHints.newPassword],
          controller: password2,
          prefixIcon: const Icon(Icons.lock),
          hintText: 'Confirmar contraseña',
          obscureText: !isVisible,
          keyboardType: TextInputType.visiblePassword,
          padding: const EdgeInsets.only(bottom: 8),
          onChanged: onChanged,
          textInputAction: TextInputAction.done,
          suffixIcon: IconButton(
            icon: Icon(
              !isVisible
                  ? Icons.visibility_off_rounded
                  : Icons.visibility_outlined,
            ),
            onPressed: onPressed,
          ),
          onEditingComplete: onEditingComplete,
        ),
      ],
    );
  }
}
