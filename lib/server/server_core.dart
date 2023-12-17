import 'dart:io';
import 'dart:convert';

class Server {
  static final List<ClientHandler> clients = [];

  static void start() async {
    final server = await ServerSocket.bind(InternetAddress.anyIPv4, 3000);
    print('Server running on ${server.address.address}:${server.port}');

    await for (var client in server) {
      var clientHandler = ClientHandler(client);
      clients.add(clientHandler);
      clientHandler.handleClient();
    }
  }

  static void broadcastMessage(String message, String senderId) {
    for (var client in clients) {
      if (client.id != senderId) {
        client.sendMessage(message);
      }
    }
  }
}

class ClientHandler {
  Socket client;
  late String id;

  ClientHandler(this.client) {
    id = '${client.remoteAddress.address}:${client.remotePort}';
  }

  void handleClient() {
    client.listen(
      (data) {
        var message = utf8.decode(data).trim();
        Server.broadcastMessage(message, id);
      },
      onDone: () {
        client.close();
        Server.clients.removeWhere((handler) => handler.id == id);
        Server.broadcastMessage('User $id disconnected', id);
      },
      onError: (error) {
        print('Error on client $id: $error');
        client.close();
        Server.clients.removeWhere((handler) => handler.id == id);
      },
    );
  }

  void sendMessage(String message) {
    client.write(message);
  }
}
