import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/user_model.dart';
import '../../providers/backend_provider.dart';
import '../../screens/loading_screen.dart';
import '../../services/navigation_service.dart';
import '../custom_button.dart';
import '../custom_input.dart';

class ProfileWidget extends ConsumerStatefulWidget {
  const ProfileWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileWidgetState();
}

bool _isEnabled = true;
List<bool> _selections = [];
User _user = User.copyWith();
DateTime _selectedDate = DateTime.now();

class _ProfileWidgetState extends ConsumerState<ProfileWidget> {
  List<String> tiposDeSangre = [
    'A+',
    'O+',
    'B+',
    'AB+',
    'A-',
    'O-',
    'B-',
    'AB-'
  ];

  @override
  void initState() {
    _user = ref.read(userProvider);
    _selections = _user.gender == 'MALE' ? [true, false] : [false, true];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _textTheme = Theme.of(context).textTheme;
    final user = ref.watch(userProvider);

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
          cancelText: 'Cancelar',
          confirmText: 'Continuar',
          helpText: 'Selecciona tu cumpleaños',
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime(1950),
          lastDate: DateTime(2101));
      if (picked != null && picked != _selectedDate) {
        setState(() {
          _selectedDate = picked;
          _user.birthday = _selectedDate;
        });
      }
    }

    bool _validate() {
      if (user.name != _user.name) return true;
      return false;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CircleAvatar(
          radius: 75,
          child: Stack(
            children: [
              Image.asset(
                'assets/icon/icon_foreground.png',
                opacity: const AlwaysStoppedAnimation<double>(0.3),
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(14),
                    shape: const CircleBorder(),
                  ),
                  child: const Icon(Icons.camera_alt_rounded),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        CustomInput(
          initialValue: _user.name,
          padding: const EdgeInsets.symmetric(vertical: 8),
          enabled: _isEnabled,
          hintText: 'Nombre y apellido',
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.name,
          prefixIcon: const Icon(Icons.person_rounded),
          onChanged: (val) => setState(() => _user.name = val),
        ),
        FadeInLeft(
          child: DropdownButtonFormField<String>(
            value: _user.bloodtype.isNotEmpty ? _user.bloodtype : null,
            items: tiposDeSangre
                .map(
                  (e) => DropdownMenuItem(
                    child: Text(e),
                    value: e,
                    enabled: _isEnabled,
                  ),
                )
                .toList(),
            onChanged: (val) => _user.bloodtype = val!,
            decoration: CustomInputDecoration.form(
                hintText: 'Tipo de sangre',
                prefixIcon: const Icon(Icons.bloodtype_rounded)),
          ),
        ),
        CustomInput(
          initialValue: _user.allergies,
          padding: const EdgeInsets.symmetric(vertical: 8),
          enabled: _isEnabled,
          hintText: 'Alergias',
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          maxLines: 3,
          prefixIcon: const Icon(Icons.warning_rounded),
          maxLength: 256,
          onChanged: (val) => _user.allergies = val,
        ),
        FadeInLeft(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ToggleButtons(
                constraints: BoxConstraints.expand(
                    width: constraints.maxWidth / 2.02, height: 60),
                borderRadius: BorderRadius.circular(30),
                children: const [
                  Text('Hombre'),
                  Text('Mujer'),
                ],
                isSelected: _selections,
                onPressed: (index) {
                  setState(() {
                    for (int i = 0; i < _selections.length; i++) {
                      _selections[i] = i == index;
                    }
                    _user.gender = index == 0 ? 'MALE' : 'FEMALE';
                  });
                },
              );
            },
          ),
        ),
        RawMaterialButton(
          onPressed: () => _selectDate(context),
          child: Container(
            margin: const EdgeInsets.only(top: 8),
            padding: const EdgeInsets.all(14),
            alignment: Alignment.centerLeft,
            height: 70,
            child: Row(
              children: [
                const Icon(
                  Icons.cake_rounded,
                  color: Colors.white70,
                ),
                const SizedBox(width: 8),
                Text(
                  '${_user.birthday.day}/${_user.birthday.month}/${_user.birthday.year}',
                  style: _textTheme.titleMedium,
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(18),
            ),
          ),
        ),
        CustomInput(
          initialValue: _user.motorcycle,
          padding: const EdgeInsets.symmetric(vertical: 8),
          enabled: _isEnabled,
          hintText: 'Marca de tu motocicleta',
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          prefixIcon: const Icon(Icons.two_wheeler_rounded),
          onChanged: (val) => _user.motorcycle = val,
        ),
        CustomInput(
          initialValue: _user.cubiccapacity,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          padding: const EdgeInsets.symmetric(vertical: 2),
          enabled: _isEnabled,
          hintText: 'Cilindraje',
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          prefixIcon: const Icon(Icons.bolt_rounded),
          onChanged: (val) => _user.cubiccapacity = val,
        ),
        CustomInput(
          initialValue: _user.color,
          padding: const EdgeInsets.symmetric(vertical: 8),
          enabled: _isEnabled,
          hintText: 'Color',
          keyboardType: TextInputType.text,
          prefixIcon: const Icon(Icons.palette_rounded),
          onChanged: (val) => _user.color = val,
        ),
        CustomButton(
          padding: const EdgeInsets.only(top: 18),
          child: const Text('Continuar'),
          onPressed: _isEnabled && _validate()
              ? () async {
                  FocusScope.of(context).unfocus();
                  setState(() {
                    _isEnabled = false;
                  });
                  await ref
                      .read(backendProvider)
                      .modifyUser(_user)
                      .then((value) {
                    if (!value) return;
                    return NavigationService.replaceAnimatedTo(
                        const LoadingScreen());
                  });
                  setState(() {
                    _isEnabled = true;
                  });
                }
              : null,
        ),
      ],
    );
  }
}
