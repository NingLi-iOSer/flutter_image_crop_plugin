//
//  TKPlatformView.swift
//  flutter_image_crop_plugin
//
//  Created by Ning Li on 2019/12/6.
//

import UIKit
import Flutter

class TKPlatformView: UIScrollView, FlutterPlatformView {
    
    private var viewId: Int64 = 0
    private var imageView: TKImageView!
    /// 通信通道
    private var channel: FlutterBasicMessageChannel?
    /// 定时器
    private var timer: Timer?
    /// 当前计数
    private var currentTime: Int = 0
    
    init(frame: CGRect, viewId: Int64, arguments: Any?, messenger: FlutterBinaryMessenger) {
        var newFrame = frame
        let screenWidth = UIScreen.main.bounds.width
        if frame.width == 0 {
            newFrame = CGRect(origin: frame.origin, size: UIScreen.main.bounds.size)
        }
        super.init(frame: newFrame)
        self.backgroundColor = UIColor.white
        self.viewId = viewId
        
        if let infos = arguments as? [String: Any],
            let imageBase64 = infos["toCropImage"] as? String,
            let imageData = Data(base64Encoded: imageBase64),
            let image = UIImage(data: imageData) {
            let height = image.size.height * screenWidth / image.size.width
            let size = CGSize(width: screenWidth, height: height)
            imageView = TKImageView(frame: CGRect(origin: CGPoint.zero, size: size))
            imageView.toCropImage = image
            imageView.showMidLines = (infos["showMidLines"] as? Bool) ?? false
            imageView.needScaleCrop = (infos["needScaleCrop"] as? Bool) ?? false
            imageView.showCrossLines = (infos["showCrossLines"] as? Bool) ?? false
            imageView.cornerBorderInImage = (infos["cornerBorderInImage"] as? Bool) ?? false
            imageView.cropAreaCornerWidth = (infos["cropAreaCornerWidth"] as? CGFloat) ?? 0
            imageView.cropAreaCornerHeight = (infos["cropAreaCornerHeight"] as? CGFloat) ?? 0
            imageView.minSpace = (infos["minSpace"] as? CGFloat) ?? 0
            imageView.cropAreaCornerLineWidth = (infos["cropAreaCornerLineWidth"] as? CGFloat) ?? 0
            imageView.cropAreaCornerLineColor = UIColor.white;
            imageView.cropAreaBorderLineWidth = (infos["cropAreaBorderLineWidth"] as? CGFloat) ?? 0
            imageView.cropAreaMidLineWidth = (infos["cropAreaMidLineWidth"] as? CGFloat) ?? 0
            imageView.cropAreaMidLineHeight = (infos["cropAreaMidLineHeight"] as? CGFloat) ?? 0
            imageView.cropAreaCrossLineWidth = (infos["cropAreaCrossLineWidth"] as? CGFloat) ?? 0
            imageView.maskColor = UIColor.black.withAlphaComponent(0.22)
            imageView.cropAspectRatio = (infos["cropAspectRatio"] as? CGFloat) ?? 1
            imageView.delegate = self;
            
            addSubview(imageView)
            contentSize = size
        }
        
        // 注册通信通道
        channel = FlutterBasicMessageChannel(name: "com.MingNiao/send_image", binaryMessenger: messenger)
        
        sendImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func view() -> UIView {
        return self
    }
    
    /// 创建定时器
    private func settingTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(calculateTime), userInfo: nil, repeats: true)
        }
    }
    
    /// 销毁定时器
    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func calculateTime() {
        currentTime += 1
        if currentTime >= 10 {
            currentTime = 0
            invalidateTimer()
            
            sendImage()
        }
    }
    
    /// 发送图片
    private func sendImage() {
        let image = imageView.currentCroppedImage()
        guard let imageData = image?.jpegData(compressionQuality: 0.8) else {
            return
        }
        let imageBase64 = imageData.base64EncodedString()
        channel?.sendMessage(imageBase64)
    }
}

extension TKPlatformView: TKImageViewDelegate {
    func imageViewDidEndChangeCropArea(_ imageView: TKImageView!) {
        settingTimer()
    }
    
    func imageViewDidBeginChangeCropArea(_ imageView: TKImageView!) {
        invalidateTimer()
    }
}
