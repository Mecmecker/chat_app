import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/usuarios_screen.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: checkLoginState(context),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            return const Center(
              child: Text('Espere...'),
            );
          }),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final AuthService authService =
        Provider.of<AuthService>(context, listen: false);

    final autenticado = await authService.isLogIn();

    if (autenticado) {
      //TODO:conectar la socket server
      Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: ((_, __, ___) => const UsuariosScreen()),
          transitionDuration: const Duration(milliseconds: 0)));
    } else {
      Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: ((_, __, ___) => const LoginScreen()),
          transitionDuration: const Duration(milliseconds: 0)));
    }
  }
}
