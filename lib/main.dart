import 'dart:io';
import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';

void main() {
  runApp(const MaterialApp(home: Home(), debugShowCheckedModeBanner: false));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String buttonText = "Connect";
  Color buttonColor = Colors.purple;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                String result =
                    await runConsoleCommand("adb connect 192.168.1.40:5555");
                if (result.contains("connected")) {
                  setState(() {
                    buttonText = "Connected";
                    buttonColor = Colors.green;
                  });
                }
              },
              child: Text(buttonText, style: myTextStyle()),
              style: myButtonStyle(buttonColor: buttonColor),
            ),
            const SizedBox(height: 10.0),
            TextButton(
              onPressed: () async {
                await runConsoleCommand("adb kill-server");
                await runConsoleCommand("adb start-server");
                setState(() {
                  buttonText = "Connect";
                  buttonColor = Colors.purple;
                });
              },
              child: Text("Reset ADB", style: myTextStyle()),
              style: myButtonStyle(),
            )
          ],
        ),
      ),
    );
  }
}

Future<String> runConsoleCommand(String command) async {
  if (Platform.isWindows) {
    var shell = Shell();
    List<ProcessResult> result = await shell.run(command);
    String outResult = result.first.outText;
    return outResult;
  }
  return "";
}

ButtonStyle myButtonStyle({Color buttonColor = Colors.purple}) {
  return ButtonStyle(
      fixedSize: MaterialStateProperty.all(const Size(150, 40)),
      backgroundColor: MaterialStateProperty.all(buttonColor));
}

TextStyle myTextStyle() {
  return const TextStyle(color: Colors.black54, fontWeight: FontWeight.w700);
}
