//
//  LNPlatformView.swift
//  flutter_image_crop_plugin
//
//  Created by Ning Li on 2019/12/10.
//

import UIKit

class LNPlatformView: UIView {
    
    private var viewId: Int64 = 0
    private var messenger: FlutterBinaryMessenger
    /// 返回
    private var backChannel: FlutterBasicMessageChannel?
    
    /// 相机
    private var camera: CustomCamera?
    /// 裁剪照片 view
    private var imageCropView: ImageCropView?
    
    init(frame: CGRect, viewId: Int64, arguments: Any?, messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init(frame: UIScreen.main.bounds)
        self.backgroundColor = UIColor.white
        self.viewId = viewId
        
        backChannel = FlutterBasicMessageChannel(name: "com.MingNiao/back", binaryMessenger: messenger)
        let removeCropImageChannel = FlutterBasicMessageChannel(name: "com.MingNiao/remove_crop_image", binaryMessenger: messenger)
        removeCropImageChannel.setMessageHandler { (_, _) in
            self.imageCropView?.removeFromSuperview()
            self.imageCropView = nil
            self.camera?.session?.startRunning()
        }
        
        settingCamera()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 设置相机
    private func settingCamera() {
        camera = CustomCamera.camera(delegate: self, messenger: messenger)
        addSubview(camera!)
    }
    
    /// 设置图片裁剪 view
    /// - Parameter image: Image
    private func settingImageCropView(image: UIImage) {
        imageCropView = ImageCropView(image: image, messenger: messenger)
        addSubview(imageCropView!)
    }
}

// MARK: - CustomCameraDelegate
extension LNPlatformView: CustomCameraDelegate {
    /// 拍照
    func camera(_ camera: CustomCamera, takePicture image: UIImage) {
        settingImageCropView(image: image)
    }
    
    /// 返回
    func cameraDidClickBack(_ camera: CustomCamera) {
        backChannel?.sendMessage(nil)
    }
}

// MARK: - FlutterPlatformView
extension LNPlatformView: FlutterPlatformView {
    func view() -> UIView {
        return self
    }
}
