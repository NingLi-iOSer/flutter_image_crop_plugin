# flutter_image_crop_plugin

[![Pub](https://img.shields.io/pub/v/flutter_image_crop_plugin)](https://pub.dev/packages/flutter_image_crop_plugin)
[![GitHub](https://img.shields.io/github/license/NingLi-iOSer/flutter_image_crop_plugin)](https://github.com/NingLi-iOSer/flutter_image_crop_plugin)
[![support](https://img.shields.io/badge/support-flutter%20%7C%20iOS-orange)](https://github.com/NingLi-iOSer/flutter_image_crop_plugin)
[![language](https://img.shields.io/badge/language-dart%20%7C%20swift-blue)](https://github.com/NingLi-iOSer/flutter_image_crop_plugin)

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
### Take photo or select photo from the album
<img src="https://github.com/NingLi-iOSer/flutter_image_crop_plugin/blob/master/select_image.png" width="300">

### Crop Image
<img src="https://github.com/NingLi-iOSer/flutter_image_crop_plugin/blob/master/crop_image.png" width="300">

## Example

Create CameraWidget
```dart
FlutterImageCropPlugin.cameraWidget()
```

Get the original photo:
```dart
FlutterImageCropPlugin.getOriginalImage((imageBase64) {
});
```

Notification of completion of operation, remove mask view:
```dart
FlutterImageCropPlugin.recognizeCompleted();
```

Get the Crop Image:
```dart
FlutterImageCropPlugin.getCropImage((imageData) {
});
```

Remove image crop widget:
```dart
FlutterImageCropPlugin.removeCropImageWidget();
```

Exit camera:
```dart
FlutterImageCropPlugin.back(() {
});
```
