import 'package:blackbells/global/blackbells_api.dart';
import 'package:blackbells/models/event_model.dart';
import 'package:blackbells/models/user_model.dart';
import 'package:blackbells/services/navigation_service.dart';
import 'package:blackbells/providers/secure_storage_provider.dart';
import 'package:blackbells/services/snackbar_service.dart';
import 'package:blackbells/providers/socket_provider.dart';
import 'package:blackbells/routes/routes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

enum Authenticated { logged, invalid, error, waiting }

final userProvider = StateProvider<User>((_) => User.copyWith());

final backendProvider = Provider<Backend>((ref) => Backend(ref.read));

class Backend {
  Backend(this.read);
  final Reader read;

  Future<bool> login(String email, String password) async {
    final data = {
      'email': email,
      'password': password,
    };

    try {
      final json = await BlackBellsApi.dPost('/auth/login', data: data);
      await SecureStorage.saveToken(json.data['token']);
      await BlackBellsApi.init();
      read(userProvider.state).state = User.fromJson(json.data['user']);
      return true;
    } on DioError catch (e) {
      SnackService.showBanner(
        backgroundColor: Colors.redAccent,
        content: e.response!.statusCode != 404
            ? e.response!.data['msg']
            : 'No hay conexión con el servidor.',
        actions: [
          TextButton(
              onPressed: () => SnackService.close(),
              child: const Text('Cerrar'))
        ],
        onVisible: () async => await Future.delayed(const Duration(seconds: 3))
            .whenComplete(() => SnackService.close()),
      );
      return false;
    }
  }

  Future<bool> register(
      String email, String password, String phonenumber) async {
    final data = {
      'email': email,
      'password': password,
      'phonenumber': phonenumber.toString(),
    };

    try {
      await BlackBellsApi.dPost('/users/', data: data);

      return true;
    } on DioError catch (e) {
      if (e.response != null) {
        final errors = e.response!.data['errors'] as List;
        for (var error in errors) {
          SnackService.showBanner(
            backgroundColor: Colors.redAccent,
            content: error['msg'],
            actions: [
              TextButton(
                  onPressed: () => SnackService.close(),
                  child: const Text('Cerrar'))
            ],
            onVisible: () async =>
                await Future.delayed(const Duration(seconds: 3))
                    .whenComplete(() => SnackService.close()),
          );
        }
        return false;
      } else {
        SnackService.showBanner(
          backgroundColor: Colors.redAccent,
          content: 'No hay conexión con el servidor.',
          actions: [
            TextButton(
                onPressed: () => SnackService.close(),
                child: const Text('Cerrar'))
          ],
          onVisible: () async =>
              await Future.delayed(const Duration(seconds: 3))
                  .whenComplete(() => SnackService.close()),
        );
        return false;
      }
    }
  }

  Future<Authenticated> authenticate() async {
    try {
      final json = await BlackBellsApi.dGet('/auth/');
      await SecureStorage.saveToken(json.data['token']);
      read(userProvider.state).state = User.fromJson(json.data['user']);
      return Authenticated.logged;
    } on DioError catch (e) {
      if (e.response != null && e.response!.statusCode != 404) {
        if (e.response!.statusCode == 400) {
          SnackService.showBanner(
            backgroundColor: Colors.amberAccent,
            contentTextStyle: const TextStyle(color: Colors.black),
            content: e.response != null
                ? e.response!.data['msg']
                : 'No hay conexión con el servidor.',
            actions: [
              TextButton(
                  onPressed: () => SnackService.close(),
                  child: const Text(
                    'Cerrar',
                    style: TextStyle(color: Colors.black),
                  ))
            ],
            onVisible: () async =>
                await Future.delayed(const Duration(seconds: 3))
                    .whenComplete(() => SnackService.close()),
          );
          return Authenticated.invalid;
        }
      } else {
        SnackService.showBanner(
          backgroundColor: Colors.redAccent,
          content: 'No hay conexión con el servidor.',
          actions: [
            TextButton(
              onPressed: () => SnackService.close(),
              child: const Text(
                'Cerrar',
              ),
            )
          ],
          onVisible: () async =>
              await Future.delayed(const Duration(seconds: 3))
                  .whenComplete(() => SnackService.close()),
        );
        return Authenticated.error;
      }
      return Authenticated.invalid;
    }
  }

  Future<bool> sendPushNotification(String title, {String? body}) async {
    try {
      final json = await BlackBellsApi.dPost('/notifications/notifications',
          data: {'title': title, 'body': body});

      if (json.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> modifyUser(User user, {bool delete = false}) async {
    try {
      Response json;

      if (delete) {
        json = await BlackBellsApi.dDelete('/users/${user.uid}');
      } else {
        json =
            await BlackBellsApi.dPut('/users/${user.uid}', data: user.toJson());
      }

      if (json.statusCode != 200) return false;

      return true;
    } on DioError catch (e) {
      SnackService.showBanner(
        backgroundColor: Colors.redAccent,
        content: e.response != null
            ? '${e.response?.data['msg']}'
            : 'Revisa tu conexión a internet.',
        actions: [
          TextButton(
            onPressed: () => SnackService.close(),
            child: const Text(
              'Cerrar',
            ),
          )
        ],
        onVisible: () async => await Future.delayed(const Duration(seconds: 3))
            .whenComplete(() => SnackService.close()),
      );
      return false;
    }
  }

  Future<bool> modifyEvent(Event event, {bool? enroll}) async {
    try {
      await BlackBellsApi.dPut(
        '/events/${event.uid}/?${enroll != null ? 'enroll=$enroll' : ''}',
        data: event.toJson(),
      );
      return true;
    } on DioError catch (e) {
      SnackService.showBanner(
        backgroundColor: Colors.redAccent,
        content: e.response != null
            ? '${e.response?.data['msg']}'
            : 'Revisa tu conexión a internet.',
        actions: [
          TextButton(
            onPressed: () => SnackService.close(),
            child: const Text(
              'Cerrar',
            ),
          )
        ],
        onVisible: () async => await Future.delayed(const Duration(seconds: 3))
            .whenComplete(() => SnackService.close()),
      );
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    try {
      await BlackBellsApi.dPost('/auth/resetpassword', data: {'email': email});
      return true;
    } on DioError catch (e) {
      SnackService.showBanner(
        backgroundColor: Colors.redAccent,
        content: e.response!.statusCode != 404
            ? e.response!.data['msg']
            : 'No hay conexión con el servidor.',
        actions: [
          TextButton(
              onPressed: () => SnackService.close(),
              child: const Text('Cerrar'))
        ],
        onVisible: () async => await Future.delayed(const Duration(seconds: 3))
            .whenComplete(() => SnackService.close()),
      );
      return false;
    }
  }

  Future<bool> validateCode(String email, String code) async {
    try {
      await BlackBellsApi.dPost('/auth/resetpassword/code',
          data: {'email': email, 'code': code});
      return true;
    } on DioError catch (e) {
      SnackService.showBanner(
        backgroundColor: Colors.redAccent,
        content: e.response!.statusCode != 404
            ? e.response!.data['msg']
            : 'No hay conexión con el servidor.',
        actions: [
          TextButton(
              onPressed: () => SnackService.close(),
              child: const Text('Cerrar'))
        ],
        onVisible: () async => await Future.delayed(const Duration(seconds: 3))
            .whenComplete(() => SnackService.close()),
      );
      return false;
    }
  }

  Future<bool> changePassword(
      String email, String code, String password) async {
    try {
      await BlackBellsApi.dPost('/auth/resetpassword/password',
          data: {'email': email, 'code': code, 'password': password});
      await login(email, password);
      return true;
    } on DioError catch (e) {
      SnackService.showBanner(
        backgroundColor: Colors.redAccent,
        content: e.response!.statusCode != 404
            ? e.response!.data['msg']
            : 'No hay conexión con el servidor.',
        actions: [
          TextButton(
              onPressed: () => SnackService.close(),
              child: const Text('Cerrar'))
        ],
        onVisible: () async => await Future.delayed(const Duration(seconds: 3))
            .whenComplete(() => SnackService.close()),
      );
      return false;
    }
  }

  bool checkProfileCompleted({XFile? image}) {
    final user = read(userProvider);

    if (user.name.isEmpty) return false;
    if (user.bloodtype.isEmpty) return false;
    if (user.allergies.isEmpty) return false;
    if (user.motorcycle.isEmpty) return false;
    if (user.cubiccapacity.isEmpty) return false;
    if (user.color.isEmpty) return false;
    if (user.img.isEmpty && image == null) return false;
    return true;
  }

  Future<void> logout() async {
    read(userProvider.state).state = User.copyWith();
    final socket = read(socketProvider);
    if (socket.serverStatus == ServerStatus.online) {
      socket.disconnect();
    }
    await SecureStorage.deleteToken();
    NavigationService.replaceTo(BlackbellsRoutes.loading);
  }
}
