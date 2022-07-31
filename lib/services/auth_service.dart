import 'dart:convert';

import 'package:chat_app/global/enviroments.dart';
import 'package:chat_app/models/login_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

import '../models/usuarios.dart';

class AuthService with ChangeNotifier {
  Usuario? usuario;
  bool _autenticando = false;

  final _storage = const FlutterSecureStorage();

  bool get autenticando => _autenticando;

  set autenticando(bool valor) {
    _autenticando = valor;
    notifyListeners();
  }

  //getters del token static para tener uso en todas las pantallas

  static Future<String?> getToken() async {
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    autenticando = true;

    final data = {'email': email, 'password': password};
    final Uri uri = Uri.http(Enviroment.apiUrl, '/api/login');
    final resp = await http.post(
      uri,
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    //print(resp.body);
    autenticando = false;
    if (resp.statusCode == 200) {
      final loginResponse = LoginResponse.fromJson(resp.body);
      usuario = loginResponse.usuario;

      await _guardarToken(loginResponse.token);

      return true;
    } else {
      return false;
    }
  }

  Future<bool> register(String nombre, String email, String password) async {
    autenticando = true;

    final data = {'nombre': nombre, 'email': email, 'password': password};
    final Uri uri = Uri.http(Enviroment.apiUrl, '/api/login/new');
    final resp = await http.post(
      uri,
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );

    autenticando = false;
    if (resp.statusCode == 200) {
      final loginResponse = LoginResponse.fromJson(resp.body);
      usuario = loginResponse.usuario;

      await _guardarToken(loginResponse.token);

      return true;
    } else {
      return false;
    }
  }

  Future<bool> isLogIn() async {
    final token = await _storage.read(key: 'token');

    if (token == null) return false;
    autenticando = true;

    final Uri uri = Uri.http(Enviroment.apiUrl, '/api/login/renew');
    final resp = await http.get(
      uri,
      headers: {'Content-Type': 'application/json', 'x-token': token},
    );

    if (resp.statusCode == 200) {
      final loginResponse = LoginResponse.fromJson(resp.body);
      usuario = loginResponse.usuario;

      await _guardarToken(loginResponse.token);

      return true;
    } else {
      logOut();
      return false;
    }
  }

  Future _guardarToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logOut() async {
    return await _storage.delete(key: 'token');
  }
}
