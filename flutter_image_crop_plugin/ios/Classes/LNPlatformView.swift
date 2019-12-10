//
//  LNPlatformView.swift
//  flutter_image_crop_plugin
//
//  Created by Ning Li on 2019/12/10.
//

import UIKit

class LNPlatformView: UIView {
    
    private var viewId: Int64 = 0
    
    init(frame: CGRect, viewId: Int64, arguments: Any?, messenger: FlutterBinaryMessenger) {
        var newFrame = frame
        if frame.width == 0 {
            newFrame = CGRect(origin: frame.origin, size: UIScreen.main.bounds.size)
        }
        super.init(frame: newFrame)
        self.backgroundColor = UIColor.white
        self.viewId = viewId
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - FlutterPlatformView
extension LNPlatformView: FlutterPlatformView {
    func view() -> UIView {
        return self
    }
}
