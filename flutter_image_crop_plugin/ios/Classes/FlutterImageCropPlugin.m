#import "FlutterImageCropPlugin.h"
#import <flutter_image_crop_plugin/flutter_image_crop_plugin-Swift.h>

@implementation FlutterImageCropPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterImageCropPlugin registerWithRegistrar:registrar];
}
@end
