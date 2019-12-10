//
//  ImageContainerView.swift
//  CustomCamera
//
//  Created by Ning Li on 2019/12/10.
//  Copyright © 2019 yzh. All rights reserved.
//

import UIKit

class ImageContainerView: UIScrollView {

    private var imageView: TKImageView
    
    init(image: UIImage) {
        let screenWidth = UIScreen.main.bounds.width
        let height = image.size.height * screenWidth / image.size.width
        let size = CGSize(width: screenWidth, height: height)
        imageView = TKImageView(frame: CGRect(origin: CGPoint.zero, size: size))
        
        super.init(frame: UIScreen.main.bounds)
        
        imageView.toCropImage = image
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
        
        addSubview(imageView)
        contentSize = size
        backgroundColor = UIColor.black
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
