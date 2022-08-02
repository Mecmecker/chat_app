import 'package:chat_app/models/usuarios.dart';
import 'package:chat_app/models/usuarios_response.dart';
import 'package:chat_app/services/auth_service.dart';

import '../global/enviroments.dart';
import 'package:http/http.dart' as http;

class UsuariosService {
  Future<List<Usuario>> getUsuarios() async {
    try {
      final Uri uri = Uri.http(Enviroment.apiUrl, '/api/usuarios');

      final resp = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken() ?? '',
      });

      final usuariosResponse = UsuariosResponse.fromJson(resp.body);

      return usuariosResponse.usuarios;
    } catch (e) {
      return [];
    }
  }
}
