//
//  TKImageView.h
//  TKImageDemo
//
//  Created by yinyu on 16/7/10.
//  Copyright © 2016年 yinyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TKImageView;
@protocol TKImageViewDelegate <NSObject>

@optional
/**
 开始更改裁剪区域
 */
- (void)imageViewDidBeginChangeCropArea:(TKImageView *)imageView;

/**
 更改裁剪区域结束回调
 */
- (void)imageViewDidEndChangeCropArea:(TKImageView *)imageView;

@end

typedef NS_ENUM(NSInteger, TKCropAreaCornerStyle) {
    TKCropAreaCornerStyleRightAngle,
    TKCropAreaCornerStyleCircle
};
@interface TKImageView : UIView
@property (nonatomic, weak) id<TKImageViewDelegate> delegate;
@property (strong, nonatomic) UIImage *toCropImage;
@property (assign, nonatomic) BOOL needScaleCrop;
@property (assign, nonatomic) BOOL showMidLines;
@property (assign, nonatomic) BOOL showCrossLines;
@property (assign, nonatomic) CGFloat cropAspectRatio;
@property (strong, nonatomic) UIColor *cropAreaBorderLineColor;
@property (assign, nonatomic) CGFloat cropAreaBorderLineWidth;
@property (strong, nonatomic) UIColor *cropAreaCornerLineColor;
@property (assign, nonatomic) CGFloat cropAreaCornerLineWidth;
@property (assign, nonatomic) CGFloat cropAreaCornerWidth;
@property (assign, nonatomic) CGFloat cropAreaCornerHeight;
@property (assign, nonatomic) CGFloat minSpace;
@property (assign, nonatomic) CGFloat cropAreaCrossLineWidth;
@property (strong, nonatomic) UIColor *cropAreaCrossLineColor;
@property (assign, nonatomic) CGFloat cropAreaMidLineWidth;
@property (assign, nonatomic) CGFloat cropAreaMidLineHeight;
@property (strong, nonatomic) UIColor *cropAreaMidLineColor;
@property (strong, nonatomic) UIColor *maskColor;
@property (assign, nonatomic) BOOL cornerBorderInImage;
@property (assign, nonatomic) CGFloat initialScaleFactor;
- (UIImage *)currentCroppedImage;
@end
