import 'package:chat_app/global/enviroments.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/cupertino.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;

  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;
  void connect() async {
    final token = await AuthService.getToken();

    // Dart client
    _socket = IO.io(
        Enviroment.socketUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableForceNew()
            .setExtraHeaders({'x-token': token ?? ""})
            .build());

    _socket.onConnect((_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    /*socket.on('nuevo-mensaje', (payload) {
      print('nombre:' + payload['nombre']);
      print('mensaje:' + payload['mensaje']);
      notifyListeners();
    });*/
  }

  void disconnect() {
    socket.disconnect();
  }
}
