import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  final Function()? onPressed;
  final String text;

  const BotonAzul({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        elevation: 5,
      ),
      onPressed: onPressed,
      child: SizedBox(
        height: 55,
        width: double.infinity,
        child: Center(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 17),
          ),
        ),
      ),
    );
  }
}
