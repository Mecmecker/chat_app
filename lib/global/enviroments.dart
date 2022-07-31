import 'dart:io';

class Enviroment {
  static String apiUrl =
      Platform.isAndroid ? '192.168.1.131:3000' : 'http://localhost:3000';
  static String socketUrl =
      Platform.isAndroid ? '192.168.1.131:3000' : 'http://localhost:3000';
}
