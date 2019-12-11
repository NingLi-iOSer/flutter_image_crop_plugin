//
//  ImageCropView.swift
//  flutter_image_crop_plugin
//
//  Created by Ning Li on 2019/12/10.
//

import UIKit
import Flutter

class ImageCropView: UIScrollView, FlutterPlatformView {
    
    private var originalImage = UIImage()
    private var imageView: TKImageView!
    /// 遮罩
    private var frontMaskView: UIView?
    /// 占位图
    private lazy var placeholderImageView = UIImageView()
    /// 通信通道
    private var sendImageChannel: FlutterBasicMessageChannel?
    /// 识别完成
    private var completedChannel: FlutterBasicMessageChannel?
    /// 定时器
    private var timer: Timer?
    /// 当前计数
    private var currentTime: Int = 0
    
    init(image: UIImage, messenger: FlutterBinaryMessenger) {
        super.init(frame: UIScreen.main.bounds)
        self.originalImage = image
        self.backgroundColor = UIColor.white
        
        backgroundColor = UIColor.black
        
        // 注册通信通道
        sendImageChannel = FlutterBasicMessageChannel(name: "com.MingNiao/send_crop_image", binaryMessenger: messenger)
        completedChannel = FlutterBasicMessageChannel(name: "com.MingNiao/recognize_completed", binaryMessenger: messenger)
        completedChannel?.setMessageHandler { [weak self] (_, _) in
            self?.settingImageView()
            self?.frontMaskView?.removeFromSuperview()
            self?.placeholderImageView.removeFromSuperview()
        }
        
        settingPlaceholderImage()
        settingMaskView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func settingPlaceholderImage() {
        let screenWidth = UIScreen.main.bounds.width
        let height = originalImage.size.height * screenWidth / originalImage.size.width
        let size = CGSize(width: screenWidth, height: height)
        placeholderImageView.image = originalImage
        placeholderImageView.frame = CGRect(origin: CGPoint(), size: size)
        placeholderImageView.contentMode = .scaleAspectFill
        addSubview(placeholderImageView)
    }
    
    private func settingMaskView() {
        frontMaskView = UIView(frame: UIScreen.main.bounds)
        frontMaskView?.backgroundColor = UIColor.black.withAlphaComponent(0.35)
        
        let indicator = UIActivityIndicatorView(style: .white)
        indicator.center = CGPoint(x: UIScreen.main.bounds.width * 0.5 - 30, y: UIScreen.main.bounds.height - 201)
        indicator.startAnimating()
        frontMaskView?.addSubview(indicator)
        
        let tipLabel = UILabel()
        tipLabel.text = "正在识别..."
        tipLabel.font = UIFont.systemFont(ofSize: 12)
        tipLabel.textColor = UIColor.white
        tipLabel.sizeToFit()
        tipLabel.frame.origin = CGPoint(x: indicator.frame.maxX + 10, y: UIScreen.main.bounds.height - 206)
        frontMaskView?.addSubview(tipLabel)
        
        addSubview(frontMaskView!)
    }
    
    private func settingImageView() {
        let screenWidth = UIScreen.main.bounds.width
        let height = originalImage.size.height * screenWidth / originalImage.size.width
        let size = CGSize(width: screenWidth, height: height)
        imageView = TKImageView(frame: CGRect(origin: CGPoint(), size: size))
        imageView.toCropImage = originalImage
        imageView.showMidLines = false
        imageView.needScaleCrop = false
        imageView.showCrossLines = false
        imageView.cornerBorderInImage = false
        imageView.cropAreaCornerWidth = 44
        imageView.cropAreaCornerHeight = 44
        imageView.minSpace = 30
        imageView.cropAreaCornerLineWidth = 3
        imageView.cropAreaCornerLineColor = UIColor.white
        imageView.cropAreaBorderLineWidth = 0
        imageView.cropAreaMidLineWidth = 0
        imageView.cropAreaMidLineHeight = 0
        imageView.cropAreaCrossLineWidth = 0
        imageView.maskColor = UIColor.black.withAlphaComponent(0.22)
        imageView.cropAspectRatio = 0
        imageView.delegate = self;
        
        insertSubview(imageView, at: 0)
        contentSize = size
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
        sendImageChannel?.sendMessage(imageBase64)
    }
    
    override func removeFromSuperview() {
        invalidateTimer()
        super.removeFromSuperview()
    }
}

// MARK: - TKImageViewDelegate
extension ImageCropView: TKImageViewDelegate {
    func imageViewDidEndChangeCropArea(_ imageView: TKImageView!) {
        settingTimer()
    }
    
    func imageViewDidBeginChangeCropArea(_ imageView: TKImageView!) {
        invalidateTimer()
    }
}
