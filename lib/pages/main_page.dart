import 'dart:io';
import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String ipAddress = "";
  String connectButtonText = "Connect";
  String resetADBButtonText = "Reset ADB";
  Color buttonColor = Colors.purple;
  double resetButtonLoadingCircleSize = 0.0;
  double connectButtonLoadingCircleSize = 0.0;

  getIPAddress() async {
    ipAddress = await getDataFromPref("IP") as String;
  }

  initialSetup() async {
    setState(() {
      connectButtonLoadingCircleSize = 25.0;
      connectButtonText = "";
    });
    String _result = await runConsoleCommand("adb devices");
    String _ip = await getDataFromPref("IP") as String;

    setState(() {
      connectButtonLoadingCircleSize = 0.0;
      connectButtonText = "Connect";
    });

    if(_result.contains(_ip)){
      setState(() {
        connectButtonText = "Connected";
        buttonColor = Colors.green;
      });
    }
  }

  @override
  void initState() {
    initialSetup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/settings");
                },
                icon: const Icon(IconData(0xe57f, fontFamily: 'MaterialIcons'),
                    color: Colors.grey)),
            // Connect Button
            TextButton(
              onPressed: () async {
                setState(() {
                  buttonColor = Colors.purple;
                  connectButtonText = "";
                  connectButtonLoadingCircleSize = 25.0;
                });
                await getIPAddress();
                String result =
                    await runConsoleCommand("adb connect $ipAddress:5555");
                connectButtonLoadingCircleSize = 0.0;
                if (result.contains("connected to")) {
                  setState(() {
                    connectButtonText = "Connected";
                    buttonColor = Colors.green;
                  });

                  if(await getDataFromPref("quitOnConnect") as bool){
                    await Future.delayed(const Duration(milliseconds: 1000));
                    exit(0);
                  }
                } else if (result.contains("No such host is known")) {
                  setState(() {
                    connectButtonText = "No Device";
                    buttonColor = Colors.red;
                  });
                } else if (result
                    .contains("the target machine actively refused it")) {
                  setState(() {
                    connectButtonText = "Couldn't Connect";
                    buttonColor = Colors.yellow;
                  });
                } else if (result.contains("A connection attempt failed")) {
                  setState(() {
                    connectButtonText = "Couldn't Connect";
                    buttonColor = Colors.yellow;
                  });
                } else if (result.contains("no host in")) {
                  setState(() {
                    connectButtonText = "No Device";
                    buttonColor = Colors.red;
                  });
                }
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(connectButtonText, style: myTextStyle()),
                  SpinKitFadingCircle(
                      color: Colors.black54,
                      size: connectButtonLoadingCircleSize)
                ],
              ),
              style: myButtonStyle(buttonColor: buttonColor),
            ),
            const SizedBox(height: 10.0),
            // Reset Button
            TextButton(
              onPressed: () async {
                setState(() {
                  resetADBButtonText = "";
                  resetButtonLoadingCircleSize = 25.0;
                });
                await runConsoleCommand("adb kill-server");
                await runConsoleCommand("adb start-server");
                setState(() {
                  connectButtonText = "Connect";
                  buttonColor = Colors.purple;
                  resetADBButtonText = "Reset ADB";
                  resetButtonLoadingCircleSize = 0.0;
                  connectButtonLoadingCircleSize = 0.0;
                });
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(resetADBButtonText, style: myTextStyle()),
                  SpinKitFadingCircle(
                      color: Colors.black54,
                      size: resetButtonLoadingCircleSize),
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

Future<Object> getDataFromPref(String key) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.get(key)!;
}

void setDataWithPref(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}
