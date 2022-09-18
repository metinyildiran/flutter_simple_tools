import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:simple_tools/widgets/status_button.dart';
import '../util/utils.dart';
import '../widgets/my_text_field.dart';

class DownloadVideo extends StatefulWidget {
  const DownloadVideo({Key? key}) : super(key: key);

  @override
  _DownloadVideoState createState() => _DownloadVideoState();
}

class _DownloadVideoState extends State<DownloadVideo> {
  ButtonStatus downloadButtonStatus = ButtonStatus.DEFAULT;
  String downloadButtonText = "Download";
  String videoLink = "";
  TextEditingController ipTextEditingController = TextEditingController();

  var streamController = StreamController.broadcast();

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: AppBar(
            title: const Text("Download Video"),
            centerTitle: true,
          )),
      body: Column(
        children: [
          MyTextField(
              onChanged: (text) {
                videoLink = text;
              },
              regExp: '.*',
              hintText: 'Video Link',
              inputType: TextInputType.multiline,
              textEditingController: ipTextEditingController),
          StatusButton(
              onPressed: () async {
                if (videoLink.isEmpty) {
                  setState(() {
                    downloadButtonText = "Enter a URL";
                  });
                }

                String _result = "";
                String _username = getUsername();
                Stream _stream = await Utils.runConsoleCommand(
                    "cd C:/Users/$_username/Desktop"
                    " && "
                    "youtube-dl "
                    "$videoLink");
                streamController.addStream(_stream);
                if (!streamController.hasListener) {
                  streamController.stream.listen((data) {
                    if (data.toString().contains("%")) {
                      _result = data.substring(11, data.indexOf("%")).trim();
                      if (mounted) {
                        setState(() {
                          downloadButtonText = "Downloading: $_result%";
                        });
                      }
                    }
                    if (data
                        .toString()
                        .contains("has already been downloaded")) {
                      setState(() {
                        downloadButtonText = "File Exists";
                      });
                    }
                    if (data.toString().contains("Merging")) {
                      setState(() {
                        downloadButtonText = "Downloaded";
                      });
                      streamController.close();
                    }
                    print(data);
                  });
                }
              },
              status: MyButtonStatus(
                  text: downloadButtonText,
                  buttonStatus: downloadButtonStatus)),
        ],
      ),
    );
  }
}

String getUsername() {
  String _username = "";
  Platform.environment.forEach((key, value) {
    if (key == "USERNAME") {
      _username = value;
      return;
    }
  });
  return _username;
}
