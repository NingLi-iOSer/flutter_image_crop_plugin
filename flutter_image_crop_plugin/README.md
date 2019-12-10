<!--
 * @Author: Ning
 * @Date: 2019-12-05 17:12:41
 * @LastEditTime: 2019-12-10 10:23:53
 * @LastEditors: Please set LastEditors
 * @Description: Flutter Image Crop Plugin
 * @FilePath: /flutter_image_crop_plugin/README.md
 -->
# flutter_image_crop_plugin

A flutter image crop plugin.

## Screensnot
<img src="https://github.com/NingLi-iOSer/flutter_image_crop_plugin/blob/master/preview.png" width="300">

## Example

Setting imageCropWidget parameters:
```dart
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
```

Create imageCropWidget:
```dart
FlutterImageCropPlugin.imageCropWidget(parameters)
```

Receive the callback image:
```dart
FlutterImageCropPlugin.getImage((imageData) {
  setState(() {
    _imageData = imageData;
  });
});
```