import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FlutterImageCropPlugin {
  static const BasicMessageChannel _getImageChannel = const BasicMessageChannel('com.MingNiao/send_image', StandardMessageCodec());

  static getImage(handler(Uint8List imageData)) {
    _getImageChannel.setMessageHandler((value) async {
      Uint8List imageDataList = base64Decode(value);
      handler(imageDataList);
    });
  }

  /*
   * @description: create TKImageView
   * @param creationParams: {
   *    toCropImage:  待裁剪的图片 base64 字符串
   *    showMidLines: 是否需要显示每条边中间的线，这条中间线支持拖动手势
   *    needScaleCrop: 是否需要缩放裁剪。
   *    showCrossLines: 是否显示裁剪框内的交叉线
   *    cornerBorderInImage: 裁剪边框的四个角是否可以超出图片显示
   *    cropAreaCornerWidth: 设置裁剪边框四个角的宽度，这里指角的横边的长度
   *    cropAreaCornerHeight: 设置裁剪边框四个角的高度，这里指角的竖边的长度
   *    minSpace: 相邻角之间的最小距离
   *    cropAreaCornerLineWidth: 设置裁剪边框四个角的线宽
   *    cropAreaBorderLineWidth: 设置裁剪边框的线宽
   *    cropAreaMidLineWidth: 裁剪边框每条边中间线的长度
   *    cropAreaMidLineHeight: 裁剪边框每条边中间线的线宽
   *    cropAreaCrossLineWidth: 裁剪框内交叉线的宽度
   *    cropAspectRatio: 设置裁剪框的宽高比
   * }
   */  
  static Widget imageCropWidget(Map creationParams) {
    return UiKitView(
      viewType: 'com.MingNiao/tk_platform_view',
      creationParams: creationParams,
      creationParamsCodec: StandardMessageCodec(),
    );
  }
}
