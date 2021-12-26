import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_tools/util/preference_utils.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String ipAddress = "";
  bool quitOnConnect = false;

  final textEditingController = TextEditingController();

  initialSetup() async {
    ipAddress = PreferenceUtils.getString("IP");

    textEditingController.text = ipAddress;
    setState(() {
      quitOnConnect = PreferenceUtils.getBool("quitOnConnect");
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: AppBar(
            title: const Text("Settings"),
            centerTitle: true,
          )),
      body: Column(
        children: [
          TextField(
            style: const TextStyle(color: Colors.white),
            onChanged: (text) {
              PreferenceUtils.setString("IP", text);
            },
            controller: textEditingController,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
            ],
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                hintText: "IP Address"),
          ),
          Row(
            children: [
              const Text("Quit On Connect",
                  style: TextStyle(color: Colors.white)),
              Checkbox(
                  value: quitOnConnect,
                  onChanged: (newValue) {
                      PreferenceUtils.setBool("quitOnConnect", newValue!);
                    setState(() {
                      quitOnConnect = newValue;
                    });
                  }),
            ],
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    initialSetup();
    PreferenceUtils.init();
    super.initState();
  }
}
