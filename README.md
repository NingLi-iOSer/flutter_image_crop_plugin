# flutter_image_crop_plugin

[![Pub](https://img.shields.io/pub/v/flutter_image_crop_plugin)](https://pub.dev/packages/flutter_image_crop_plugin)
[![GitHub](https://img.shields.io/github/license/NingLi-iOSer/flutter_image_crop_plugin)](https://github.com/NingLi-iOSer/flutter_image_crop_plugin)
[![support](https://img.shields.io/badge/platform--flutter-flutter%20%7C%20iOS-orange)](https://github.com/NingLi-iOSer/flutter_image_crop_plugin)

## Get started
### Add this to your package's pubspec.yaml file:
```
dependencies:
  flutter_image_crop_plugin: ^1.1.1
```

### Import it
```
import 'package:flutter_image_crop_plugin/flutter_image_crop_plugin.dart';
```

## ScreenShot
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
