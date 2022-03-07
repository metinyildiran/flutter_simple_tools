import 'package:flutter/material.dart';
import 'package:simple_tools/theme/custom_colors.dart';
import 'package:simple_tools/util/preference_utils.dart';
import 'package:simple_tools/widgets/my_text_field.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool quitOnConnect = false;
  TextEditingController ipTextEditingController = TextEditingController();

  initialSetup() async {
    setState(() {
      ipTextEditingController.text = PreferenceUtils.getString("IP");
      quitOnConnect = PreferenceUtils.getBool("quitOnConnect");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.darkGrey,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: AppBar(
            title: const Text("Settings"),
            centerTitle: true,
          )),
      body: Column(
        children: [
          MyTextField(onChanged: (text) {
            PreferenceUtils.setString("IP", text);
          }, regExp: r'[0-9.]', hintText: 'IP Address', textEditingController: ipTextEditingController),
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
    super.initState();
  }
}
