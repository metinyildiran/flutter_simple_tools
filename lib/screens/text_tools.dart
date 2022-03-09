import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_tools/theme/custom_colors.dart';
import 'package:simple_tools/widgets/my_text_field.dart';
import 'package:simple_tools/widgets/status_button.dart';

class TextTools extends StatefulWidget {
  const TextTools({Key? key}) : super(key: key);

  @override
  State<TextTools> createState() => _TextToolsState();
}

class _TextToolsState extends State<TextTools> {
  String capitalizedText = "TEXT WILL APPEAR HERE";
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.darkGrey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40.0),
        child: AppBar(
          title: const Text("Text Tools"),
          centerTitle: true,
        ),
      ),
      body: Column(
        children: [
          MyTextField(
              onChanged: (text) {
                setState(() {
                  textEditingController.addListener(() {
                    if (textEditingController.text == "") {
                      capitalizedText = "TEXT WILL APPEAR HERE";
                      return;
                    }
                    capitalizedText = textEditingController.text.toUpperCase();
                  });
                });
              },
              inputType: TextInputType.text,
              textEditingController: textEditingController,
              hintText: "Enter the text"),
          const SizedBox(height: 5),
          const SizedBox(height: 10),
          Text(capitalizedText, style: const TextStyle(color: Colors.grey)),
          StatusButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: capitalizedText));
                setState(() {
                  textEditingController.text = "";
                });
              },
              status: MyButtonStatus(
                  text: "Copy", buttonStatus: ButtonStatus.DEFAULT))
        ],
      ),
    );
  }
}
