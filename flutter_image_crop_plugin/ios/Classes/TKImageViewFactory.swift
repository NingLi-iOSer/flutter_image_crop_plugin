//
//  TKImageViewFactory.swift
//  flutter_image_crop_plugin
//
//  Created by Ning Li on 2019/12/6.
//

import Foundation
import Flutter

class TestViewFactory: NSObject, FlutterPlatformViewFactory {
    
    private var messenger: FlutterBinaryMessenger
    
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        let v = TKPlatformView(frame: frame, viewId: viewId, arguments: args, messenger: messenger)
        return v
    }
    
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}
