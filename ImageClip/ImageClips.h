//
//  ImageClips.h
//  ImageClip
//
//  Created by yang on 15/8/13.
//  Copyright (c) 2015年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void  (^returnClipImage)(UIImage *img_clip);

@interface ImageClips : UIViewController<UIScrollViewDelegate>
@property(strong,nonatomic) IBOutlet UILabel *lbl_topShow;
@property(strong,nonatomic) IBOutlet UILabel *lbl_midShow;
@property(strong,nonatomic) IBOutlet UILabel *lbl_bottomShow;

@property(strong,nonatomic) IBOutlet UIScrollView *scroll;
@property(strong,nonatomic) IBOutlet UIImageView *img;
@property(strong,nonatomic) IBOutlet UIImageView *img_clip;

@property (copy,nonatomic) returnClipImage returnImg;

@property(strong,nonatomic) UIImage *img_in;
@property float clipControl;
@property CGSize midsize;

-(void)setReturnBlock:(returnClipImage)ret image:(UIImage*)img control:(float)clipControl;

@end
