import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/screens/loading_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/register_screen.dart';
import 'package:chat_app/screens/usuarios_screen.dart';
import 'package:flutter/material.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'usuarios': (_) => const UsuariosScreen(),
  'chat': (_) => const ChatScreen(),
  'login': (_) => const LoginScreen(),
  'register': (_) => const RegisterScreen(),
  'loading': (_) => const LoadingScreen(),
};
