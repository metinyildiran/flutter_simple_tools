import 'dart:io';
import 'package:flutter/material.dart';
import 'package:process_run/shell.dart';
import 'package:simple_tools/widgets/status_button.dart';
import '../util/preference_utils.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String ipAddress = "";
  ButtonStatus connectButtonStatus = ButtonStatus.DEFAULT;
  ButtonStatus resetButtonStatus = ButtonStatus.DEFAULT;

  initialSetup() async {
    setState(() {
      connectButtonStatus = ButtonStatus.BUSY;
    });
    String _result = await runConsoleCommand("adb devices");

    setState(() {
      connectButtonStatus = ButtonStatus.DEFAULT;
    });

    if (_result.contains(PreferenceUtils.getString("IP"))) {
      setState(() {
        connectButtonStatus = ButtonStatus.CONNECTED;
      });
    }
  }

  @override
  void initState() {
    PreferenceUtils.init();
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
            // Settings Button
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, "/settings");
                },
                icon: const Icon(IconData(0xe57f, fontFamily: 'MaterialIcons'),
                    color: Colors.grey)),
            // Connect Button
            StatusButton(
              onPressed: () async {
                setState(() {
                  connectButtonStatus = ButtonStatus.BUSY;
                });
                ipAddress = PreferenceUtils.getString("IP");
                String result =
                    await runConsoleCommand("adb connect $ipAddress:5555");
                if (result.contains("connected to")) {
                  setState(() {
                    connectButtonStatus = ButtonStatus.CONNECTED;
                  });

                  if (PreferenceUtils.getBool("quitOnConnect")) {
                    await Future.delayed(const Duration(milliseconds: 1000));
                    exit(0);
                  }
                } else if (result.contains("No such host is known")) {
                  setState(() {
                    connectButtonStatus = ButtonStatus.ERROR;
                  });
                } else if (result
                    .contains("the target machine actively refused it")) {
                  setState(() {
                    connectButtonStatus = ButtonStatus.WARNING;
                  });
                } else if (result.contains("A connection attempt failed")) {
                  setState(() {
                    connectButtonStatus = ButtonStatus.WARNING;
                  });
                } else if (result.contains("no host in")) {
                  setState(() {
                    connectButtonStatus = ButtonStatus.ERROR;
                  });
                }
              },
              status: MyButtonStatus(
                  text: "Connect", buttonStatus: connectButtonStatus),
            ),
            const SizedBox(height: 10.0),
            // Reset Button
            StatusButton(
              onPressed: () async {
                setState(() {
                  connectButtonStatus = ButtonStatus.BUSY;
                  resetButtonStatus = ButtonStatus.BUSY;
                });
                await runConsoleCommand("adb kill-server");
                await runConsoleCommand("adb start-server");
                setState(() {
                  connectButtonStatus = ButtonStatus.DEFAULT;
                  resetButtonStatus = ButtonStatus.DEFAULT;
                });
              },
              status: MyButtonStatus(
                  text: "Reset", buttonStatus: resetButtonStatus),
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
