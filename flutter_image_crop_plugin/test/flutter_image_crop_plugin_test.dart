import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_image_crop_plugin/flutter_image_crop_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_image_crop_plugin');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterImageCropPlugin.platformVersion, '42');
  });
}
