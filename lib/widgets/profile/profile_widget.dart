import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:blackbells/global/blackbells_api.dart';
import 'package:blackbells/services/dialog_service.dart';
import 'package:blackbells/widgets/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/user_model.dart';
import '../../providers/backend_provider.dart';
import '../../screens/loading_screen.dart';
import '../../services/navigation_service.dart';
import '../custom_button.dart';
import '../custom_input.dart';

class EditProfileWidget extends ConsumerStatefulWidget {
  const EditProfileWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileWidgetState();
}

User _user = User.copyWith();
bool _isEnabled = true;
List<bool> _selections = [];
DateTime _selectedDate = DateTime.now();
bool _isEdited = false;
final ImagePicker _picker = ImagePicker();
XFile? _image;

class _ProfileWidgetState extends ConsumerState<EditProfileWidget> {
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
    _isEdited = false;
    _image = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _textTheme = Theme.of(context).textTheme;

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
          _isEdited = true;
        });
      }
    }

    final backend = ref.watch(backendProvider);

    return WillPopScope(
      onWillPop: () async {
        if (_isEdited) {
          return await DialogService.show(
            title: '¿Estás seguro?',
            content: 'Perderás los cambios que has hecho.',
            actions: [
              CustomButton(
                child: const Text(
                  'Continuar editando',
                ),
                onPressed: () => NavigationService.pop(false),
              ),
              CustomButton(
                isCancel: true,
                child: const Text(
                  'Salir del editor',
                ),
                onPressed: () {
                  backend.authenticate();
                  NavigationService.pop(true);
                },
              ),
            ],
          );
        }
        return true;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CircleAvatar(
            radius: 75,
            child: Stack(
              alignment: Alignment.center,
              children: [
                (_image != null)
                    ? ClipOval(
                        child: Image.file(
                          File(_image!.path),
                          fit: BoxFit.cover,
                          width: 150,
                          height: 150,
                        ),
                      )
                    : (_user.img.isNotEmpty && _image == null)
                        ? ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: _user.img,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => const ShimmerEffect(
                                width: 150,
                              ),
                            ),
                          )
                        : Image.asset(
                            'assets/icon/icon_foreground.png',
                            opacity: const AlwaysStoppedAnimation<double>(0.3),
                            fit: BoxFit.cover,
                          ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: ElevatedButton(
                    onPressed: () async {
                      _image = await _picker.pickImage(
                          source: ImageSource.gallery, maxWidth: 512);

                      if (_image != null) {
                        setState(() {
                          _isEdited = true;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.all(14),
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(Icons.edit_rounded),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          CustomInput(
            initialValue: _user.name,
            padding: const EdgeInsets.only(bottom: 8),
            enabled: _isEnabled,
            hintText: 'Nombre y apellido',
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.name,
            prefixIcon: const Icon(Icons.person_rounded),
            onChanged: (val) => setState(() {
              _user.name = val;
              _isEdited = true;
            }),
          ),
          CustomInput(
            initialValue: _user.email,
            padding: const EdgeInsets.only(bottom: 8),
            enabled: _isEnabled,
            hintText: 'Correo electrónico',
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.email_rounded),
            onChanged: (val) => setState(() {
              _user.email = val;
              _isEdited = true;
            }),
          ),
          CustomInput(
            initialValue: _user.phonenumber,
            padding: const EdgeInsets.only(bottom: 8),
            enabled: _isEnabled,
            hintText: 'WhatsApp',
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(Icons.phone_rounded),
            onChanged: (val) => setState(() {
              _user.phonenumber = val;
              _isEdited = true;
            }),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: FadeInLeft(
              delay: const Duration(milliseconds: 200),
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
                onChanged: _isEnabled
                    ? (val) => setState(() {
                          _user.bloodtype = val!;
                          _isEdited = true;
                        })
                    : null,
                decoration: CustomInputDecoration.form(
                    hintText: 'Tipo de sangre',
                    prefixIcon: const Icon(Icons.bloodtype_rounded)),
              ),
            ),
          ),
          CustomInput(
            delay: const Duration(milliseconds: 300),
            initialValue: _user.allergies,
            padding: const EdgeInsets.only(bottom: 8),
            enabled: _isEnabled,
            hintText: 'Alergias',
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            maxLines: 3,
            prefixIcon: const Icon(Icons.warning_rounded),
            maxLength: 256,
            onChanged: (val) => setState(() {
              _user.allergies = val;
              _isEdited = true;
            }),
          ),
          FadeInLeft(
            delay: const Duration(milliseconds: 400),
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
                  onPressed: _isEnabled
                      ? (index) {
                          setState(() {
                            for (int i = 0; i < _selections.length; i++) {
                              _selections[i] = i == index;
                            }
                            _user.gender = index == 0 ? 'MALE' : 'FEMALE';
                            _isEdited = true;
                          });
                        }
                      : null,
                );
              },
            ),
          ),
          FadeInLeft(
            delay: const Duration(milliseconds: 500),
            child: RawMaterialButton(
              onPressed: _isEnabled ? () => _selectDate(context) : null,
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
          ),
          CustomInput(
            delay: const Duration(milliseconds: 600),
            initialValue: _user.motorcycle,
            padding: const EdgeInsets.symmetric(vertical: 8),
            enabled: _isEnabled,
            hintText: 'Marca de tu motocicleta',
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            prefixIcon: const Icon(Icons.two_wheeler_rounded),
            onChanged: (val) => setState(() {
              _user.motorcycle = val;
              _isEdited = true;
            }),
          ),
          CustomInput(
            delay: const Duration(milliseconds: 700),
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
            onChanged: (val) => setState(() {
              _user.cubiccapacity = val;
              _isEdited = true;
            }),
          ),
          CustomInput(
            delay: const Duration(milliseconds: 800),
            initialValue: _user.color,
            padding: const EdgeInsets.symmetric(vertical: 8),
            enabled: _isEnabled,
            hintText: 'Color',
            keyboardType: TextInputType.text,
            prefixIcon: const Icon(Icons.palette_rounded),
            onChanged: (val) => setState(() {
              _user.color = val;
              _isEdited = true;
            }),
            onEditingComplete: _isEnabled &&
                    _isEdited &&
                    backend.checkProfileCompleted(image: _image)
                ? () => _submit()
                : null,
          ),
          CustomButton(
            padding: const EdgeInsets.only(top: 18),
            child: const Text('Continuar'),
            onPressed: _isEnabled &&
                    _isEdited &&
                    backend.checkProfileCompleted(image: _image)
                ? () => _submit()
                : null,
          ),
        ],
      ),
    );
  }

  void _submit() async {
    FocusScope.of(context).unfocus();
    setState(() => _isEnabled = false);
    try {
      if (_image != null) {
        final result = await FlutterImageCompress.compressWithFile(
          _image!.path,
          quality: 50,
          format: CompressFormat.jpeg,
          keepExif: false,
          minWidth: 512,
          minHeight: 512,
        );
        await BlackBellsApi.dUploadImage(
            '/uploads/users/${_user.uid}', result!);
      }
      await ref.read(backendProvider).modifyUser(_user).then((value) {
        if (!value) return;
        return NavigationService.replaceAnimatedTo(const LoadingScreen());
      });
      setState(() => _isEnabled = true);
    } catch (e) {
      setState(() => _isEnabled = true);
    }

    setState(() => _isEnabled = true);
  }
}
