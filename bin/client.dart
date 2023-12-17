import 'dart:io';
import 'package:terminal_chat_relay/client/client_core.dart';

void main() {
  stdout.write("Enter your name: ");
  String name = stdin.readLineSync() ?? "Anonymous";
  Client(name).connect();
}
