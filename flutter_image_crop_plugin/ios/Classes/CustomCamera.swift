//
//  CustomCamera.swift
//  CustomCamera
//
//  Created by Ning Li on 2019/12/10.
//  Copyright © 2019 yzh. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

protocol CustomCameraDelegate: class {
    func camera(_ camera: CustomCamera, takePicture image: UIImage)
    
    func cameraDidClickBack(_ camera: CustomCamera)
}

class CustomCamera: UIView {
    
    weak var delegate: CustomCameraDelegate?
    
    private var device: AVCaptureDevice! /// 获取设备：如摄像头
    var captureSession: AVCaptureSession! /// 会话，协调着input到output的数据传输，input和output的桥梁
    private var previewLayer: AVCaptureVideoPreviewLayer! /// 图像预览层，实时显示捕获的图像
    // 输入流
    private var input: AVCaptureDeviceInput!
    private var output:  AVCaptureVideoDataOutput! /// 图像流输出
    private var beganTakePicture:Bool = false /// 相机开始拍照
    
    class func camera(delegate: CustomCameraDelegate?) -> CustomCamera {
        let v = UINib(nibName: "CustomCamera", bundle: nil).instantiate(withOwner: nil, options: nil).first as! CustomCamera
        v.frame = UIScreen.main.bounds
        v.delegate = delegate
        v.isAvailableCamera { (isSuccess) in
            if isSuccess {
                v.initCamera()
            }
        }
        return v
    }
    
    /// 检测相机是否可用
    private func isAvailableCamera(completion: @escaping (_ isSuccess: Bool)->()) {
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            // 模拟器不支持相机
            return
        }
        // 获取相机授权状态
        let state = AVCaptureDevice.authorizationStatus(for: .video)
        if state == .authorized {
            completion(true)
        } else {
            // 请求相机权限
            requestCameraAuthorization(completion: completion)
        }
    }
    
    /// 初始化相机
    private func initCamera() {
        // SessionPreset,用于设置output输出流的画面质量
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        
        // 获取输入设备,builtInWideAngleCamera是通用相机,AVMediaType.video代表视频媒体,back表示前置摄像头,如果需要后置摄像头修改为front
        device = AVCaptureDevice.default(for: .video)
        
        captureSession.beginConfiguration()
        do {
            // 将后置摄像头作为session的input 输入流
            input = try AVCaptureDeviceInput(device: device)
            captureSession.addInput(input)
        } catch {
            print(error.localizedDescription)
        }
        // 设定视频预览层,也就是相机预览layer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        layer.insertSublayer(previewLayer, at: 0)   /// >>> sessionView 中
        previewLayer.frame = UIScreen.main.bounds
        //previewLayer.videoGravity = AVLayerVideoGravity(rawValue: "AVLayerVideoGravityResizeAspectFill")
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill /// 相机页面展现形式-拉伸充满frame
        
        // 设定输出流
        output = AVCaptureVideoDataOutput()
        // 是否直接丢弃处理旧帧时捕获的新帧,默认为True,如果改为false会大幅提高内存使用
        output.alwaysDiscardsLateVideoFrames = true
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        // beginConfiguration()和commitConfiguration()方法中的修改将在commit时同时提交
        captureSession.commitConfiguration()
        captureSession.startRunning()
        // 开新线程进行输出流代理方法调用
        let queue = DispatchQueue(label: "custom.camera")
        output.setSampleBufferDelegate(self, queue: queue)
        
        let captureConnection = output.connection(with: .video)
        if captureConnection?.isVideoStabilizationSupported == true {
            /// 这个很重要 这个是为了拍照完成，防止图片旋转90度
            captureConnection?.videoOrientation = self.getCaptureVideoOrientation()
        }
    }
    
    /// 旋转方向
    func getCaptureVideoOrientation() -> AVCaptureVideoOrientation {
        switch UIDevice.current.orientation {
        case .portrait,.faceUp,.faceDown:
            return .portrait
        case .portraitUpsideDown: // 如果这里设置成AVCaptureVideoOrientationPortraitUpsideDown,则视频方向和拍摄时的方向是相反的。
            return .portrait
        case .landscapeLeft:
            return .landscapeRight
        case .landscapeRight:
            return .landscapeLeft
        default:
            return .portrait
        }
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate
extension CustomCamera: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if beganTakePicture == true {
            beganTakePicture = false
            /// 注意在主线程中执行
            DispatchQueue.main.async {
                if let image = self.imageConvert(sampleBuffer: sampleBuffer) {
                    self.captureSession.stopRunning()
                    self.delegate?.camera(self, takePicture: image)
                }
            }
        }
    }
    
    /// CMSampleBufferRef=>UIImage
    func imageConvert(sampleBuffer:CMSampleBuffer?) -> UIImage? {
        guard sampleBuffer != nil && CMSampleBufferIsValid(sampleBuffer!) == true else { return nil }
        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer!)
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer!)
        return UIImage(ciImage: ciImage)
    }
}

extension CustomCamera {
    /// 拍照
    @IBAction private func takePhoto() {
        beganTakePicture = true
    }
    
    /// 切换摄像头
    @IBAction private func switchDevicePosition() {
        captureSession.stopRunning()
        
        let targetPosition: AVCaptureDevice.Position = (device.position == .back) ? .front : .back
        if #available(iOS 10.0, *) {
            device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: targetPosition)
        } else {
            let devices = AVCaptureDevice.devices(for: .video)
            guard devices.count > 0 else { return } /// 初始化摄像头设备
            guard let device = devices.filter({  return $0.position == targetPosition }).first else { return }
            self.device = device
        }
        
        captureSession.removeInput(input)
        input = try? AVCaptureDeviceInput(device: device)
        captureSession.addInput(input)
        
        captureSession.startRunning()
    }
    
    /// 返回
    @IBAction private func back() {
        delegate?.cameraDidClickBack(self)
    }
    
    /// 打开相册
    @IBAction private func openPhotoAlbum() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            showImagePickerVC()
        } else {
            requestPhotoAlbumAuthorization()
        }
    }
    
    private func showImagePickerVC() {
        // 打开相册
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.sourceType = .photoLibrary
        imagePickerVC.delegate = self
        self.window?.rootViewController?.present(imagePickerVC, animated: true, completion: nil)
        
        captureSession?.stopRunning()
    }
}

extension CustomCamera {
    /// 请求相机权限
    private func requestCameraAuthorization(completion: @escaping (_ isSuccess: Bool)->()) {
        AVCaptureDevice.requestAccess(for: .video) { (success) in
            DispatchQueue.main.async {
                if success {
                    completion(true)
                } else {
                    let message = "请到【设置】->【隐私】->【相机】\n开启相机的访问权限"
                    let alertVC = UIAlertController(title: "相机权限未开启", message: message, preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "好", style: .cancel, handler: nil))
                    alertVC.addAction(UIAlertAction(title: "去设置", style: .default, handler: { (_) in
                        let url = URL(string: UIApplication.openSettingsURLString)!
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }))
                    self.window?.rootViewController?.present(alertVC, animated: true, completion: nil)
                    completion(false)
                }
            }
        }
    }
    
    /// 请求相册权限
    private func requestPhotoAlbumAuthorization() {
        PHPhotoLibrary.requestAuthorization { (state) in
            DispatchQueue.main.async {
                switch state {
                case .authorized:
                    // 选择图片
                    self.showImagePickerVC()
                default:
                    let message = "请到【设置】->【隐私】->【相册】\n开启相册的访问权限"
                    let alertVC = UIAlertController(title: "相册权限未开启", message: message, preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "好", style: .cancel, handler: nil))
                    alertVC.addAction(UIAlertAction(title: "去设置", style: .default, handler: { (_) in
                        let url = URL(string: UIApplication.openSettingsURLString)!
                        
//                        UIApplication.shared.op
//                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }))
                    self.window?.rootViewController?.present(alertVC, animated: true, completion: nil)
                }
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension CustomCamera: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            self.captureSession?.startRunning()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            picker.dismiss(animated: true) {
                self.delegate?.camera(self, takePicture: image)
            }
        }
    }
}
