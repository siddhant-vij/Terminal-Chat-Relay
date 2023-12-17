import 'dart:io';
import 'dart:convert';

class Client {
  final String name;
  late final Socket _socket;

  Client(this.name);

  void connect() async {
    try {
      _socket = await Socket.connect('localhost', 3000);
      print('Connected to the server as $name.');
      _socket.listen(
        (data) => print(utf8.decode(data)),
        onDone: () => _socket.destroy(),
        onError: (e) => print(e),
      );
      Stream<String?> inputStream =
          stdin.transform(utf8.decoder).transform(const LineSplitter());
      await for (var line in inputStream) {
        if (line == null || line.toLowerCase() == 'exit') break;
        _socket.write('$name: $line\n');
      }
      await _socket.close();
    } catch (e) {
      print('Unable to connect to the server: $e');
    }
  }
}
