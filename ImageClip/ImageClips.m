//
//  ImageClips.m
//  ImageClip
//
//  Created by yang on 15/8/13.
//  Copyright (c) 2015年 yang. All rights reserved.
//

#import "ImageClips.h"

@interface ImageClips ()

@end

@implementation ImageClips

-(void)setReturnBlock:(returnClipImage)ret image:(UIImage*)img control:(float)clipControl{
    self.returnImg = ret;
    self.img_in = img;
    self.clipControl = clipControl;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //状态栏占据位置
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //状态栏显示
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.img_in!=nil){
        self.img.image = self.img_in;
    }
    
    float width = [[UIScreen mainScreen] bounds].size.width;
    float height = [[UIScreen mainScreen] bounds].size.height;
    if(self.clipControl==0){
        self.clipControl = 1;
    }
    self.midsize = CGSizeMake(width, width*self.clipControl);
    CGSize c = self.img.image.size;
    
    float img_height = c.height*width/c.width;
    
    
    
    
    
    self.scroll.minimumZoomScale = 1.0f;
    self.scroll.maximumZoomScale = 5.0f;
    self.scroll.bouncesZoom = YES;
    self.scroll.userInteractionEnabled = YES;
    self.scroll.delegate = self;
//    self.scroll.backgroundColor = [UIColor clearColor];
    self.scroll.showsHorizontalScrollIndicator    = NO;
    self.scroll.showsVerticalScrollIndicator      = NO;
//    self.scroll.panGestureRecognizer.delaysTouchesBegan = self.scroll.delaysContentTouches;

    self.scroll.contentMode = UIViewContentModeCenter;
    self.scroll.scrollEnabled = YES;
    self.img.frame = CGRectMake(0,(height-60-self.midsize.height)/2, width, img_height);
    self.scroll.contentSize = CGSizeMake(width, img_height+(height-60-self.midsize.height));
    self.scroll.frame =  CGRectMake(0,0, width, height-60);
    self.scroll.clipsToBounds = NO;
    
    self.lbl_topShow.frame = CGRectMake(0, 0, width, (height-60-self.midsize.height)/2);
    self.lbl_midShow.frame = CGRectMake(0, (height-60-self.midsize.height)/2, width, self.midsize.height);
    self.lbl_midShow.layer.borderColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.6].CGColor;
    self.lbl_midShow.layer.borderWidth = 1.0;
    self.lbl_bottomShow.frame = CGRectMake(0, height-60- (height-60-self.midsize.height)/2, width, (height-60-self.midsize.height)/2);
    
    [self.scroll setContentOffset:CGPointMake(0, (img_height-self.midsize.height)/2) animated:NO];
    
    
    if(self.returnImg==nil){
        self.img_clip.hidden = NO;
    }else{
        self.img_clip.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)closeView:(id)sender{
    UINavigationController *navigationController = self.navigationController;
    if(navigationController==nil){
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}


#pragma mark - scroll delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    NSLog(@"viewForZoomingInScrollView");
    return self.img;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
//    CGFloat xcenter = scrollView.center.x, ycenter = scrollView.center.y;
//    if(xcenter>=480){
//        xcenter=160;
//    }
//    xcenter = scrollView.contentSize.width > scrollView.frame.size.width ? scrollView.contentSize.width/2 :xcenter;
//    
//    ycenter = scrollView.contentSize.height > scrollView.frame.size.height ? scrollView.contentSize.height/2 :ycenter;
//    
//    self.img.center = CGPointMake(xcenter, ycenter);
    
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    if(scrollView.zoomScale==1){
//        m_imageView.frame =self.bounds;
        float width = [[UIScreen mainScreen] bounds].size.width;
        float height = [[UIScreen mainScreen] bounds].size.height;
        CGSize c = self.img.image.size;
        
        float img_height = c.height*width/c.width;
        self.scroll.contentSize = CGSizeMake(width, img_height+(height-60-self.midsize.height));

    }else{
        CGSize s = self.scroll.contentSize;
        float width = [[UIScreen mainScreen] bounds].size.width;
        float height = [[UIScreen mainScreen] bounds].size.height;
        CGSize c = self.img.image.size;
        
        float img_height = c.height*width/c.width;
        self.scroll.contentSize = CGSizeMake(s.width,s.width/width*(img_height)+(height-60-self.midsize.height));
    }
    
}


-(IBAction)clipImage:(id)sender{
    if(self.img.image==nil){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"原图不存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    CGPoint cg = self.scroll.contentOffset;
    
    CGSize c = self.img.image.size;
    

    
    NSLog(@"cg_width:%lf  cg_height:%lf",cg.x,cg.y);
    float zoom = self.img.frame.size.width/c.width;
    
    CGRect rec = CGRectMake(cg.x/zoom, cg.y/zoom, self.midsize.width/zoom, self.midsize.height/zoom);
    CGImageRef imageRef = CGImageCreateWithImageInRect([[self fixOrientation:self.img.image] CGImage],rec);
    UIImage *clipImage = [[UIImage alloc] initWithCGImage:imageRef];
    
    if(self.returnImg==nil){
        self.img_clip.image = clipImage;
    }else{
        self.returnImg(clipImage);
        [self closeView:nil];
    }
//    self.img_clip.image = clipImage;
//    self.img_clip.hidden = NO;
    
    
}

//修改拍摄照片的水平度不然会旋转90度
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


@end
