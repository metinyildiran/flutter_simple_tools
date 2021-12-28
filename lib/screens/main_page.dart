import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
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
  ButtonStatus downloadButtonStatus = ButtonStatus.DEFAULT;
  String downloadButtonText = "Download";

  initialSetup() async {
    setState(() {
      connectButtonStatus = ButtonStatus.BUSY;
    });
    String _result = "";
    Stream _stream = await runConsoleCommand("adb devices");
    _stream.listen((data) {
      _result = data;
    });

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
            StatusButton(
                onPressed: () async {
                  setState(() {
                    // downloadButtonStatus = ButtonStatus.BUSY;
                  });
                  String _result = "";
                  Stream _stream = await runConsoleCommand(
                      "youtube-dl https://www.youtube.com/watch?v=_tV5LEBDs7w");
                  _stream.listen((data) {
                    if(data.toString().contains("%")){
                      _result = data.substring(11, data.indexOf("%")).trim();
                      setState(() {
                        downloadButtonText = _result;
                      });
                    }
                  });
                  print(_result);
                },
                status: MyButtonStatus(
                    text: downloadButtonText,
                    buttonStatus: downloadButtonStatus)),
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
                Stream _stream =
                    await runConsoleCommand("adb connect $ipAddress:5555");
                _stream.listen((result) async {
                  print(result);
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
                });
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

Future<Stream> runConsoleCommand(String command) async {
  if (Platform.isWindows) {
    var process = await Process.start(command, [], runInShell: true);
    return process.stdout.transform(utf8.decoder);
  }
  return const Stream.empty();
}

ButtonStyle myButtonStyle({Color buttonColor = Colors.purple}) {
  return ButtonStyle(
      fixedSize: MaterialStateProperty.all(const Size(150, 40)),
      backgroundColor: MaterialStateProperty.all(buttonColor));
}

TextStyle myTextStyle() {
  return const TextStyle(color: Colors.black54, fontWeight: FontWeight.w700);
}
