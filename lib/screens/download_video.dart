import 'package:flutter/material.dart';
import 'package:simple_tools/widgets/status_button.dart';

import '../util/utils.dart';

class DownloadVideo extends StatefulWidget {
  const DownloadVideo({Key? key}) : super(key: key);

  @override
  _DownloadVideoState createState() => _DownloadVideoState();
}

class _DownloadVideoState extends State<DownloadVideo> {
  ButtonStatus downloadButtonStatus = ButtonStatus.DEFAULT;
  String downloadButtonText = "Download";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(40.0),
          child: AppBar(
            title: const Text("Download Video"),
            centerTitle: true,
          )),
      body: Center(
        child: StatusButton(
            onPressed: () async {
              setState(() {
                // downloadButtonStatus = ButtonStatus.BUSY;
              });
              String _result = "";
              Stream _stream =
                  await Utils.runConsoleCommand("cd C:/Users/metin/Desktop"
                      " && "
                      "youtube-dl https://www.youtube.com/watch?v=_tV5LEBDs7w");
              _stream.listen((data) {
                print(data);
                // ToDo: bir önceki ekrana dönüp geri gelindiğinde butonun hala yüzdeyi göstermesi lazım
                if (data.toString().contains("%")) {
                  _result = data.substring(11, data.indexOf("%")).trim();
                  if(mounted){
                    setState(() {
                      downloadButtonText = "$_result%";
                    });
                  }
                }
              });
              print(_result);
            },
            status: MyButtonStatus(
                text: downloadButtonText, buttonStatus: downloadButtonStatus)),
      ),
    );
  }
}
