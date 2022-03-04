import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../global/blackbells_api.dart';
import '../models/event_model.dart';
import '../services/snackbar_service.dart';

final eventsProvider = FutureProvider<List<Event>>((_) async {
  List<Event> events = [];
  try {
    final json = await BlackBellsApi.dGet('/events/');

    events = List<Event>.from(
        (json.data['events'] as List).map((e) => Event.fromJson(e)));

    events.sort(((a, b) => b.start.compareTo(a.start)));

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
