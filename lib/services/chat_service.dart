import 'package:chat_app/global/enviroments.dart';
import 'package:chat_app/models/mensajes_response.dart';
import 'package:chat_app/models/usuarios.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatService with ChangeNotifier {
  Usuario? usuarioPara;

  Future<List<Mensaje>> getChat(String usuarioId) async {
    final Uri uri = Uri.http(Enviroment.apiUrl, '/api/mensajes/$usuarioId');

    final resp = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'x-token': await AuthService.getToken() ?? '',
    });

    final MensajesResponse mensajesResponse =
        MensajesResponse.fromJson(resp.body);

    return mensajesResponse.mensajes;
  }
}
