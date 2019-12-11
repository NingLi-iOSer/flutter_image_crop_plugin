import Flutter
import UIKit

public class SwiftFlutterImageCropPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let factory = LNPlatformViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "com.MingNiao/camera")
    }
}
