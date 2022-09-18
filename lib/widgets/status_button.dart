import 'package:flutter/material.dart';

enum ButtonStatus { DEFAULT, BUSY, CONNECTED, WARNING, ERROR }

class StatusButton extends StatelessWidget {
  MyButtonStatus status;
  GestureTapCallback onPressed;

  StatusButton({Key? key, required this.onPressed, required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 5.0),
        SizedBox(
            width: 200.0,
            height: 40.0,
            child: Stack(children: [
              ElevatedButton(
                onPressed: onPressed,
                child: Stack(alignment: Alignment.center, children: [
                  if (status.isBusy)
                    const SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(strokeWidth: 2.0)),
                  Center(
                    child: Text(
                      status.text,
                      maxLines: 1,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ]),
              )
            ])),
        const SizedBox(height: 5.0)
      ],
    );
  }
}

class MyButtonStatus {
  String text;
  bool isBusy;
  ButtonStatus buttonStatus;

  MyButtonStatus(
      {this.text = "Status Button",
      this.isBusy = false,
      required this.buttonStatus}) {
    if (buttonStatus == ButtonStatus.DEFAULT) {
      isBusy = false;
    } else if (buttonStatus == ButtonStatus.BUSY) {
      text = "";
      isBusy = true;
    } else if (buttonStatus == ButtonStatus.CONNECTED) {
      text = "Connected";
    } else if (buttonStatus == ButtonStatus.WARNING) {
      text = "Couldn't connect";
    } else if (buttonStatus == ButtonStatus.ERROR) {
      text = "No device";
    }
  }
}
