import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../global/blackbells_api.dart';
import '../models/benefits_model.dart';
import '../services/snackbar_service.dart';

final benefitsProvider =
    FutureProvider.family<List<Benefit>, String>((_, uid) async {
  List<Benefit> benefits = [];
  try {
    final json = await BlackBellsApi.dGet('/benefits/establishment/$uid');
    benefits = List<Benefit>.from(
        (json.data['benefits'] as List).map((e) => Benefit.fromJson(e)));
    return benefits;
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
    return benefits;
  }
});
