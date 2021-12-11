import 'dart:io';
import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() {
  runApp(const MaterialApp(home: Home(), debugShowCheckedModeBanner: false));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String connectButtonText = "Connect";
  String resetADBButtonText = "Reset ADB";
  Color buttonColor = Colors.purple;
  double loadingCircleSize = 0.0;

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
                    connectButtonText = "Connected";
                    buttonColor = Colors.green;
                  });
                }
              },
              child: Text(connectButtonText, style: myTextStyle()),
              style: myButtonStyle(buttonColor: buttonColor),
            ),
            const SizedBox(height: 10.0),
            TextButton(
              onPressed: () async {
                setState(() {
                  resetADBButtonText = "";
                  loadingCircleSize = 25.0;
                });
                await runConsoleCommand("adb kill-server");
                await runConsoleCommand("adb start-server");
                setState(() {
                  connectButtonText = "Connect";
                  buttonColor = Colors.purple;
                  resetADBButtonText = "Reset ADB";
                  loadingCircleSize = 0.0;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(resetADBButtonText, style: myTextStyle()),
                  SpinKitFadingCircle(color: Colors.black54, size: loadingCircleSize),
                ],
              ),
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
