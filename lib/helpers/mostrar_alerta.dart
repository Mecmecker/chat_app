import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

mostrarAlerta(
    {required BuildContext context,
    required String titulo,
    required String subtitulo}) {
  final BuildContext cont = context;

  if (Platform.isAndroid) {
    showDialog(
      context: cont,
      builder: (BuildContext context) => AlertDialog(
        title: Text(titulo),
        content: Text(subtitulo),
        actions: [
          MaterialButton(
            onPressed: () => Navigator.pop(context),
            elevation: 5,
            textColor: Colors.blue,
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  } else {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(titulo),
        content: Text(subtitulo),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(context),
            child: const Text('Ok'),
          )
        ],
      ),
    );
  }
}
