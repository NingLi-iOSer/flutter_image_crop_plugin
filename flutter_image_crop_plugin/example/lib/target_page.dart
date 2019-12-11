import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_image_crop_plugin/flutter_image_crop_plugin.dart';

class TargetPage extends StatefulWidget {
  TargetPage({Key key}) : super(key: key);

  @override
  _TargetPageState createState() => _TargetPageState();
}

class _TargetPageState extends State<TargetPage> {

  Uint8List _imageData;
  bool _hiddenClose = true;

  @override
  void initState() {
    super.initState();

    // 获取原图
    FlutterImageCropPlugin.getOriginalImage((imageBase64) {
      setState(() {
        _hiddenClose = false;
      });
      Future.delayed(Duration(seconds: 1), () {
        FlutterImageCropPlugin.recognizeCompleted();
      });
    });

    // 获取裁剪后的图片
    FlutterImageCropPlugin.getCropImage((imageData) {
      setState(() {
        _imageData = imageData;
      });
    });

    // 返回
    FlutterImageCropPlugin.back(() {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            FlutterImageCropPlugin.cameraWidget(),
            Positioned(
              left: 0,
              bottom: 50,
              child: Offstage(
                offstage: _hiddenClose,
                child: (_imageData == null) ? Container() : Container(
                  width: 100,
                  height: 100,
                  child: Image.memory(_imageData),
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              right: 20,
              child: Offstage(
                offstage: _hiddenClose,
                child: FloatingActionButton(
                  child: Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _imageData = null;
                      _hiddenClose = true;
                    });
                    FlutterImageCropPlugin.removeCropImageWidget();
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}