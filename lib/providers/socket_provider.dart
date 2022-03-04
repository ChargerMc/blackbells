import 'package:blackbells/global/environment.dart';
import 'package:blackbells/providers/secure_storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

final socketProvider = Provider<SocketService>((_) => SocketService());

enum ServerStatus { online, offline, connecting }

class SocketService {
  ServerStatus _serverStatus = ServerStatus.connecting;
  late IO.Socket _client;

  ServerStatus get serverStatus => _serverStatus;

  IO.Socket get client => _client;
  Function get emit => _client.emit;

  Future<void> connect() async {
    final token = await SecureStorage.getToken();

    _client = IO.io(
        Environment.config.socketURL,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableForceNew()
            .setExtraHeaders({
              'x-token': token,
            })
            .build());

    _client.onConnect((_) {
      _serverStatus = ServerStatus.online;
    });

    _client.onDisconnect((_) {
      _serverStatus = ServerStatus.offline;
    });
  }

  void disconnect() {
    _client.disconnect();
  }
}
