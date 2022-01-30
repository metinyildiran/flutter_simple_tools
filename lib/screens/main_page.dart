import 'dart:io';
import 'package:flutter/material.dart';
import 'package:simple_tools/util/utils.dart';
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

    Stream _stream = await Utils.runConsoleCommand("adb devices");
    _stream.listen((data) {
      print('data: $data');
      if (data.contains(PreferenceUtils.getString("IP"))) {
        setState(() {
          connectButtonStatus = ButtonStatus.CONNECTED;
        });
      }
    });

    setState(() {
      connectButtonStatus = ButtonStatus.DEFAULT;
    });
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Settings Button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/settings");
                  },
                  icon: const Icon(IconData(0xe57f, fontFamily: 'MaterialIcons'),
                      color: Colors.grey)),
            ),
            // Connect Button
            StatusButton(
              onPressed: () async {
                setState(() {
                  connectButtonStatus = ButtonStatus.BUSY;
                });
                ipAddress = PreferenceUtils.getString("IP");
                Stream _stream = await Utils.runConsoleCommand(
                    "adb connect $ipAddress:5555");
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
            // Reset Button
            StatusButton(
              onPressed: () async {
                setState(() {
                  connectButtonStatus = ButtonStatus.BUSY;
                  resetButtonStatus = ButtonStatus.BUSY;
                });
                await Utils.runConsoleCommand("adb kill-server");
                await Utils.runConsoleCommand("adb start-server");
                setState(() {
                  connectButtonStatus = ButtonStatus.DEFAULT;
                  resetButtonStatus = ButtonStatus.DEFAULT;
                });
              },
              status: MyButtonStatus(
                  text: "Reset ADB", buttonStatus: resetButtonStatus),
            ),
            // Download Button
            StatusButton(
                onPressed: () async {
                  Navigator.pushNamed(context, "/download_video");
                },
                status: MyButtonStatus(
                    text: "Download Video",
                    buttonStatus: ButtonStatus.DEFAULT)),
          ],
        ),
      ),
    );
  }
}
