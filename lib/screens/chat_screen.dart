import 'dart:io';

import 'package:chat_app/models/mensajes_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _estaScribiendo = false;

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  List<ChatMessage> menssages = [];

  @override
  void initState() {
    super.initState();
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);

    socketService.socket.on('mensaje-personal', _escucharMsg);

    _cargarHistorial(chatService.usuarioPara!.uid);
  }

  void _cargarHistorial(String usuarioID) async {
    List<Mensaje> chat = await chatService.getChat(usuarioID);

    final history = chat.map((m) => ChatMessage(
        texto: m.mensaje,
        uid: m.de,
        animationController: AnimationController(
            vsync: this, duration: const Duration(milliseconds: 0))
          ..forward()));

    setState(() {
      menssages.insertAll(0, history);
    });
  }

  void _escucharMsg(dynamic payload) {
    final ChatMessage message = ChatMessage(
      texto: payload['mensaje'],
      uid: payload['de'],
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );

    setState(() {
      menssages.insert(0, message);
    });

    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final usuarioPara = chatService.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              maxRadius: 14,
              backgroundColor: Colors.blue[100],
              child: Text(
                usuarioPara!.nombre.substring(0, 2),
                style: const TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              usuarioPara.nombre,
              style: const TextStyle(color: Colors.black87, fontSize: 12),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              itemCount: menssages.length,
              itemBuilder: (_, i) => menssages[i],
              physics: const BouncingScrollPhysics(),
              reverse: true,
            ),
          ),
          const Divider(
            height: 1,
          ),
          Container(
            color: Colors.white,
            child: _inputChat(),
          )
        ],
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: ((String texto) {
                  setState(() {
                    if (texto.trim().isNotEmpty) {
                      _estaScribiendo = true;
                    } else {
                      _estaScribiendo = false;
                    }
                  });
                }),
                decoration:
                    const InputDecoration.collapsed(hintText: 'Enviar mensaje'),
                focusNode: _focusNode,
              ),
            ),
            //boton de enviar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isIOS
                  ? CupertinoButton(
                      onPressed: _estaScribiendo
                          ? () => _handleSubmit(_textController.text.trim())
                          : null,
                      child: const Text('enviar'),
                    )
                  : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue[400]),
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onPressed: _estaScribiendo
                              ? () => _handleSubmit(_textController.text.trim())
                              : null,
                          icon: const Icon(Icons.send),
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  _handleSubmit(String texto) {
    if (texto.isEmpty) return;

    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      texto: texto,
      uid: authService.usuario!.uid,
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
      ),
    );
    menssages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _estaScribiendo = false;
    });

    socketService.socket.emit('mensaje-personal', {
      'de': authService.usuario!.uid,
      'para': chatService.usuarioPara!.uid,
      'mensaje': texto
    });
  }

  @override
  void dispose() {
    for (ChatMessage message in menssages) {
      message.animationController.dispose();
    }
    socketService.socket.off('mensaje-personal');
    super.dispose();
  }
}
