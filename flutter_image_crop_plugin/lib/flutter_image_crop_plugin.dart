import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FlutterImageCropPlugin {

  static const BasicMessageChannel _getOriginalImageChannel = const BasicMessageChannel('com.MingNiao/send_original_image', StandardMessageCodec());

  // 获取原图
  static getOriginalImage(handler(String imageBase64)) {
    _getOriginalImageChannel.setMessageHandler((value) async {
      handler(value);
    });
  }

  static const BasicMessageChannel _getCropImageChannel = const BasicMessageChannel('com.MingNiao/send_crop_image', StandardMessageCodec());

  // 获取裁剪图片
  static getCropImage(handler(Uint8List imageData)) {
    _getCropImageChannel.setMessageHandler((value) async {
      Uint8List imageDataList = base64Decode(value);
      handler(imageDataList);
    });
  }

  static const BasicMessageChannel _recognizeCompletedChannel = const BasicMessageChannel('com.MingNiao/recognize_completed', StandardMessageCodec());

  // 发送识别完成消息
  static recognizeCompleted() {
    _recognizeCompletedChannel.send(null);
  }

  static const BasicMessageChannel _removeCropImageChannel = const BasicMessageChannel('com.MingNiao/remove_crop_image', StandardMessageCodec());

  // 移除裁剪图片组件
  static removeCropImageWidget() {
    _removeCropImageChannel.send(null);
  }

  static const BasicMessageChannel _backChannel = const BasicMessageChannel('com.MingNiao/back', StandardMessageCodec());

  // 返回
  static back(handler()) {
    _backChannel.setMessageHandler((value) async {
      handler();
    });
  }

  static Widget cameraWidget() {
    return UiKitView(
      viewType: 'com.MingNiao/camera',
    );
  }
}
