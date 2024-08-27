import 'package:consoler/consoler.dart';

final class UnknownProgram extends ConsoleProgram {
  @override
  void run(List<String> args) {
    print(
        "Command not found. Type `help` to see an overview about all commands");
  }

  @override
  String? getDescription() => null;
}
