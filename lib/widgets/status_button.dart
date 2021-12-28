import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(status.buttonColor)),
                child: Stack(children: [
                  SpinKitFadingCircle(
                      color: Colors.black54, size: status.loadingCircleSize),
                  Center(
                    child: Text(
                      status.text,
                      maxLines: 1,
                      style: const TextStyle(
                          color: Colors.black54, fontWeight: FontWeight.w700),
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
  Color buttonColor;
  double loadingCircleSize;
  ButtonStatus buttonStatus;

  MyButtonStatus(
      {this.text = "Status Button",
      this.buttonColor = Colors.purple,
      this.loadingCircleSize = 0.0,
      required this.buttonStatus}) {
    if (buttonStatus == ButtonStatus.DEFAULT) {
      loadingCircleSize = 0.0;
    } else if (buttonStatus == ButtonStatus.BUSY) {
      text = "";
      loadingCircleSize = 25.0;
    } else if (buttonStatus == ButtonStatus.CONNECTED) {
      text = "Connected";
      buttonColor = Colors.green;
    } else if (buttonStatus == ButtonStatus.WARNING) {
      text = "Couldn't connect";
      buttonColor = Colors.yellow;
    } else if (buttonStatus == ButtonStatus.ERROR) {
      text = "No device";
      buttonColor = Colors.red;
    }
  }
}
