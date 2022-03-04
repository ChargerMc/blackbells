import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../global/blackbells_api.dart';
import '../models/establishment_model.dart';
import '../services/snackbar_service.dart';

final establishmentProvider = FutureProvider<List<Establishment>>((_) async {
  List<Establishment> establishments = [];
  try {
    final json = await BlackBellsApi.dGet('/establishments/');
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
