import Flutter
import UIKit

public class FlutterImageCropPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
        let factory = TestViewFactory(messenger: registrar.messenger())
        registrar.register(factory, withId: "com.MingNiao/tk_platform_view")
    }
}
