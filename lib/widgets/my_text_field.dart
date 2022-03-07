import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
  TextEditingController textEditingController = TextEditingController();
  String hintText = "Text Field";
  String regExp;
  TextInputType inputType;
  Function(String text) onChanged;

  MyTextField(
      {Key? key,
      required this.onChanged,
      required this.textEditingController,
      required this.hintText,
      this.inputType = TextInputType.text,
      this.regExp = '.*'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      onChanged: (text) => onChanged(text),
      controller: textEditingController,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(regExp))],
      keyboardType: inputType,
      maxLines: 1,
      decoration: InputDecoration(
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          hintText: hintText),
    );
  }

  MyTextField setText(String text) {
    textEditingController.text = text;
    return MyTextField(hintText: hintText, textEditingController: textEditingController,onChanged: onChanged);
  }
}
