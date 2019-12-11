//
//  CustomCamera.swift
//  flutter_image_crop_plugin
//
//  Created by Ning Li on 2019/12/10.
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
    
    /// 获取设备
    private var device: AVCaptureDevice!
    /// 会话
    var session: AVCaptureSession!
    /// 图像预览层，实时显示捕获的图像
    private var previewLayer: AVCaptureVideoPreviewLayer!
    /// 输入流
    private var input: AVCaptureDeviceInput!
    /// 图像流输出
    private var photoOutput:  AVCaptureStillImageOutput!
    /// 相机开始拍照
    private var beganTakePicture:Bool = false
    
    private var channel: FlutterBasicMessageChannel!
    
    /// 返回图片
    @IBOutlet weak var backImageView: UIImageView!
    /// 切换摄像头图片
    @IBOutlet weak var switchImageView: UIImageView!
    /// 打开相册图片
    @IBOutlet weak var openPhotoAlbumImageView: UIImageView!
    /// 拍照图片
    @IBOutlet weak var takePhotoImageView: UIImageView!
    
    class func camera(delegate: CustomCameraDelegate?, messenger: FlutterBinaryMessenger) -> CustomCamera {
        let bundle = Bundle(for: self)
        let v = UINib(nibName: "CustomCamera", bundle: bundle).instantiate(withOwner: nil, options: nil).first as! CustomCamera
        v.frame = UIScreen.main.bounds
        v.delegate = delegate
        v.settingUI(messenger: messenger)
        v.isAvailableCamera { (isSuccess) in
            if isSuccess {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    v.initCamera()
                }
            }
        }
        return v
    }
    
    private func settingUI(messenger: FlutterBinaryMessenger) {
        let bundle = Bundle(for: CustomCamera.self)
        backImageView.image = UIImage(named: "nav_back_white", in: bundle, compatibleWith: nil)
        switchImageView.image = UIImage(named: "icon-qiehuan", in: bundle, compatibleWith: nil)
        openPhotoAlbumImageView.image = UIImage(named: "icon-tupian", in: bundle, compatibleWith: nil)
        takePhotoImageView.image = UIImage(named: "icon-posits", in: bundle, compatibleWith: nil)
        
        channel = FlutterBasicMessageChannel(name: "com.MingNiao/send_original_image", binaryMessenger: messenger)
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
        // 获取输入设备
        device = AVCaptureDevice.default(for: .video)
        
        // 初始化输入流
        input = try? AVCaptureDeviceInput(device: device)
        
        // 初始化输出流
        photoOutput = AVCaptureStillImageOutput()
        
        // 生成会话
        session = AVCaptureSession()
        if session.canSetSessionPreset(AVCaptureSession.Preset.high) {
            session.sessionPreset = .high
        }
        if session.canAddInput(input) {
            session.addInput(input)
        }
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        }
        
        // 初始化预览层
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = UIScreen.main.bounds
        previewLayer.videoGravity = .resizeAspectFill
        layer.insertSublayer(previewLayer, at: 0)
        
        session.startRunning()
        // 自动白平衡
        if (try? device.lockForConfiguration()) != nil {
            if device.isWhiteBalanceModeSupported(.autoWhiteBalance) {
                device.whiteBalanceMode = .autoWhiteBalance
            }
            device.unlockForConfiguration()
        }
    }
}

extension CustomCamera {
    /// 拍照
    @IBAction private func takePhoto() {
        let videoConnection = photoOutput.connection(with: .video)
        if videoConnection == nil {
            return
        }
        
        photoOutput.captureStillImageAsynchronously(from: videoConnection!) { [unowned self] (buffer, error) in
            guard let buffer = buffer else { return }
            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(buffer)!
            let image = UIImage(data: imageData)!
            self.session.stopRunning()
            self.delegate?.camera(self, takePicture: image)
            let imageBase64 = imageData.base64EncodedString()
            self.channel.sendMessage(imageBase64)
        }
    }
    
    /// 切换摄像头
    @IBAction private func switchDevicePosition() {
        if device == nil {
            return
        }
        // 获取需要切换的摄像头
        let targetPosition: AVCaptureDevice.Position = (device.position == .back) ? .front : .back
        // 创建新设备
        let devices = AVCaptureDevice.devices(for: .video)
        // 取出摄像头
        guard devices.count > 0 else { return }
        guard let device = devices.filter({  return $0.position == targetPosition }).first else { return }
        self.device = device
        
        // 切换摄像头
        session.beginConfiguration()
        session.removeInput(input)
        input = try? AVCaptureDeviceInput(device: device)
        session.addInput(input)
        session.commitConfiguration()
    }
    
    /// 返回
    @IBAction private func back() {
        session?.stopRunning()
        session = nil
        input = nil
        device = nil
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
        
        session?.stopRunning()
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
                        UIApplication.shared.openURL(url)
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
            self.session?.startRunning()
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
            let imageData = image.jpegData(compressionQuality: 0.8) {
            self.session?.stopRunning()
            let imageBase64 = imageData.base64EncodedString()
            self.channel.sendMessage(imageBase64)
            self.delegate?.camera(self, takePicture: image)
            picker.dismiss(animated: true, completion: nil)
        }
    }
}
