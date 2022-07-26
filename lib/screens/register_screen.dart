import 'package:chat_app/services/socket_service.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/widgets/widgets.dart';
import 'package:chat_app/widgets/boton_azul.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:provider/provider.dart';

import '../helpers/mostrar_alerta.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                LogoHeader(
                  titulo: 'Registro',
                ),
                _Formulario(),
                Labels(
                  ruta: 'login',
                  text1: '¿Ya tienes una cuenta?',
                  text2: 'Ingresa ahora!',
                ),
                Text(
                  'Terminos y condiciones de uso',
                  style: TextStyle(fontWeight: FontWeight.w200),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Formulario extends StatefulWidget {
  const _Formulario({Key? key}) : super(key: key);

  @override
  State<_Formulario> createState() => _FormularioState();
}

class _FormularioState extends State<_Formulario> {
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          InputWidget(
            icon: Icons.perm_identity,
            placeholder: 'Nombre',
            keyboardType: TextInputType.text,
            textController: nameController,
          ),
          InputWidget(
            icon: Icons.mail_outline,
            placeholder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailController,
          ),
          InputWidget(
            icon: Icons.lock_outline,
            placeholder: 'Password',
            textController: passController,
            isPassword: true,
          ),
          BotonAzul(
              onPressed:
                  Provider.of<AuthService>(context, listen: true).autenticando
                      ? null
                      : _onPress,
              text: 'Ingresen'),
        ],
      ),
    );
  }

  _onPress() async {
    FocusScope.of(context).unfocus();

    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context, listen: false);
    final registroOk = await authService.register(nameController.text.trim(),
        emailController.text.trim(), passController.text.trim());

    if (registroOk) {
      socketService.connect();
      Navigator.of(context).pushReplacementNamed('usuarios');
    } else {
      //mostrar alerta
      mostrarAlerta(
          context: context,
          titulo: 'Credenciales incorrectas',
          subtitulo: 'Revisen sus credenciales');
    }
  }
}
