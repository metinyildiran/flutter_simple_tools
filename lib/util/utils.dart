import 'dart:convert';
import 'dart:io';

class Utils {
  static Future<Stream> runConsoleCommand(String command) async {
    if (Platform.isWindows) {
      var process = await Process.start(command, [], runInShell: true);
      return process.stdout.transform(utf8.decoder);
    }
    return const Stream.empty();
  }
}
