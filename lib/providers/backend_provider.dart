import 'package:blackbells/global/environment.dart';
import 'package:blackbells/models/establishment_model.dart';
import 'package:blackbells/models/event_model.dart';
import 'package:blackbells/models/user_model.dart';
import 'package:blackbells/providers/navigation_provider.dart';
import 'package:blackbells/providers/secure_storage_provider.dart';
import 'package:blackbells/providers/snackbar_provider.dart';
import 'package:blackbells/providers/socket_provider.dart';
import 'package:blackbells/routes/routes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Authenticated { logged, invalid, error, waiting }

final userProvider = StateProvider<User>((_) => User.copyWith());

final backendProvider = Provider<Backend>((ref) => Backend(ref.read));
final _dio = Dio();

class Backend {
  Backend(this.read);
  final Reader read;

  Future<bool> login(String email, String password) async {
    final data = {
      'email': email,
      'password': password,
    };

    try {
      final json = await _dio.post('/auth/login', data: data);
      await SecureStorage.saveToken(json.data['token']);
      _dio.options.headers = {'x-token': json.data['token']};
      read(userProvider.state).state = User.fromJson(json.data['user']);
      return true;
    } on DioError catch (e) {
      SnackService.showBanner(
        backgroundColor: Colors.redAccent,
        content: e.response != null
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
      await _dio.post('/users/', data: data);
      return true;
    } on DioError catch (e) {
      SnackService.showBanner(
        backgroundColor: Colors.redAccent,
        content: e.response != null
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

  Future<Authenticated> authenticate() async {
    try {
      _dio.options.headers = {'x-token': await SecureStorage.getToken()};
      _dio.options.baseUrl = Environment().config.baseURL;
      _dio.options.connectTimeout = 60 * 1000;
      _dio.options.receiveTimeout = 60 * 1000;

      final json = await _dio.get('/auth/');
      await SecureStorage.saveToken(json.data['token']);
      read(userProvider.state).state = User.fromJson(json.data['user']);
      return Authenticated.logged;
    } on DioError catch (e) {
      if (e.response != null) {
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

  Future<bool> mofifyUser(User user, {bool delete = false}) async {
    try {
      Response json;

      if (delete) {
        json = await _dio.delete('/users/${user.uid}');
      } else {
        json = await _dio.put('/users/${user.uid}', data: user.toJson());
      }

      if (json.statusCode != 200) return false;

      return true;
    } on DioError catch (e) {
      SnackService.showBanner(
        backgroundColor: Colors.redAccent,
        content: '${e.response?.data['msg']}',
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

final eventsProvider = FutureProvider<List<Event>>((_) async {
  List<Event> events = [];
  try {
    final json = await _dio.get('/events/');

    events = List<Event>.from(
        (json.data['events'] as List).map((e) => Event.fromJson(e)));

    return events;
  } on DioError catch (e) {
    SnackService.showBanner(
      backgroundColor: Colors.redAccent,
      content: '${e.response?.data['msg']}',
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
    return events;
  }
});

final establishmentProvider = FutureProvider<List<Establishment>>((_) async {
  List<Establishment> establishments = [];
  try {
    final json = await _dio.get('/establishments/');
    establishments = List<Establishment>.from(
        (json.data['establishments'] as List)
            .map((e) => Establishment.fromJson(e)));
    return establishments;
  } on DioError catch (e) {
    SnackService.showBanner(
      backgroundColor: Colors.redAccent,
      content: '${e.response?.data['msg']}',
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
    return establishments;
  }
});

final usersProvider = FutureProvider<List<User>>((_) async {
  List<User> users = [];
  try {
    final json = await _dio.get('/users/');

    users = List<User>.from(
        (json.data['users'] as List).map((e) => User.fromJson(e)));

    users.removeWhere((user) => user.role == 'ADMIN_ROLE');

    return users;
  } on DioError catch (e) {
    SnackService.showBanner(
      backgroundColor: Colors.redAccent,
      content: '${e.response?.data['msg']}',
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
    return users;
  }
});
