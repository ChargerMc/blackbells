import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../global/blackbells_api.dart';
import '../models/user_model.dart';
import '../services/snackbar_service.dart';

final usersProvider = FutureProvider<List<User>>((_) async {
  List<User> users = [];
  try {
    final json = await BlackBellsApi.dGet('/users/');

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
