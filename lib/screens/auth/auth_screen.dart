import 'package:animate_do/animate_do.dart';
import 'package:blackbells/providers/backend_provider.dart';
import 'package:blackbells/services/navigation_service.dart';
import 'package:blackbells/providers/socket_provider.dart';
import 'package:blackbells/screens/dashboard_screen.dart';
import 'package:blackbells/screens/error/disabled_user_screen.dart';
import 'package:blackbells/widgets/auth/auth_form_widget.dart';
import 'package:blackbells/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthScreenState();
}

bool isVisible = false;
bool isEnabled = true;

Authtype type = Authtype.login;

TextEditingController _email = TextEditingController();
TextEditingController _password = TextEditingController();
TextEditingController _password2 = TextEditingController();
TextEditingController _phonenumber = TextEditingController();

class _AuthScreenState extends ConsumerState<AuthScreen> {
  @override
  void initState() {
    isEnabled = true;
    type = Authtype.login;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            child: AutofillGroup(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AuthFormWidget(
                    type: type,
                    phonenumber: _phonenumber,
                    isEnabled: isEnabled,
                    isVisible: isVisible,
                    email: _email,
                    password: _password,
                    password2: _password2,
                    onPressed: () => setState(() {
                      isVisible = !isVisible;
                    }),
                    onEditingComplete: () {
                      final valid = validate();
                      if (valid) auth(ref.read);
                    },
                    onChanged: (_) => setState(
                      () {
                        validate();
                      },
                    ),
                  ),
                  FadeInUp(
                    delay: const Duration(milliseconds: 800),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextButton(
                          onPressed: isEnabled
                              ? () => setState(() {
                                    if (type == Authtype.login) {
                                      type = Authtype.register;
                                    } else {
                                      type = Authtype.login;
                                    }
                                  })
                              : null,
                          child: Text.rich(
                            TextSpan(
                              text: type == Authtype.login
                                  ? '¿No tienes una cuenta?  '
                                  : '¿Tienes una cuenta?  ',
                              style: const TextStyle(color: Colors.white54),
                              children: [
                                TextSpan(
                                  text: type == Authtype.login
                                      ? 'Postúlate'
                                      : 'Ingresar',
                                  style: const TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                        CustomButton(
                          onPressed: isEnabled && validate()
                              ? () => auth(ref.read)
                              : null,
                          child: Text(
                            type == Authtype.login ? 'Ingresar' : 'Postularme',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool validate() {
    final validEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!validEmail.hasMatch(_email.text.trim())) return false;
    if (!(_password.text.length >= 5)) return false;

    if (type == Authtype.register) {
      if (!(_password2.text.length >= 5)) return false;
      if (_password.text.trim() != _password2.text.trim()) return false;
      if (!(_phonenumber.text.length > 9)) return false;
    }

    return true;
  }

  void auth(Reader read) async {
    final backend = ref.read(backendProvider);

    FocusScope.of(context).unfocus();
    TextInput.finishAutofillContext();
    setState(() {
      isVisible = false;
      isEnabled = false;
    });

    if (type == Authtype.register) {
      final register = await backend.register(
          _email.text.trim(), _password.text.trim(), _phonenumber.text.trim());

      if (!register) {
        setState(() {
          isEnabled = true;
        });
        return;
      }
    }

    final isLoggin =
        await backend.login(_email.text.trim(), _password.text.trim());

    if (isLoggin) {
      final user = ref.read(userProvider);
      if (user.enabled == false) {
        _password2.clear();
        _phonenumber.clear();
        _email.clear();
        _password.clear();
        return NavigationService.replaceAnimatedTo(const DisabledUserScreen());
      }
      await ref.read(socketProvider).connect();
      NavigationService.replaceAnimatedTo(const DashboardScreen());
      _password2.clear();
      _phonenumber.clear();
      _email.clear();
      _password.clear();
    }

    setState(() {
      isEnabled = true;
    });
  }
}
