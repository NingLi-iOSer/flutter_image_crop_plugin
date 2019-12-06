import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_crop_plugin/flutter_image_crop_plugin.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Future _future;
  // 裁剪后的图片数据
  Uint8List _imageData;

  @override
  void initState() {
    super.initState();

    _future = _getImageData();

    FlutterImageCropPlugin.getImage((imageData) {
      setState(() {
        _imageData = imageData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          width: 375,
          height: 667,
          child: FutureBuilder(
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Stack(
                  children: <Widget>[
                    Container(
                      width: 375,
                      height: 667,
                      child: FlutterImageCropPlugin.imageCropWidget(_setCreationParams(snapshot.data)),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        height: 100,
                        width: 100,
                        child: (_imageData == null) ? Container() : Image.memory(_imageData),
                      ),
                    )
                  ],
                );
              } else {
                return Container();
              }
            },
            future: _future,
          ),
        ),
      ),
    );
  }

  Map _setCreationParams(String imageBase64) {
    return {
      'toCropImage': imageBase64,
      'showMidLines': false,
      'needScaleCrop': false,
      'showCrossLines': false,
      'cornerBorderInImage': false,
      'cropAreaCornerWidth': 44,
      'cropAreaCornerHeight': 44,
      'minSpace': 30,
      'cropAreaCornerLineWidth': 3,
      'cropAreaBorderLineWidth': 0,
      'cropAreaMidLineWidth': 0,
      'cropAreaMidLineHeight': 0,
      'cropAreaCrossLineWidth': 0,
      'cropAspectRatio': 0,
    };
  }

  Future<String> _getImageData() async {
    ByteData imageData = await rootBundle.load('images/image.jpeg');
    String imageBase64 = base64Encode(imageData.buffer.asUint8List());
    return imageBase64;
  }
}
