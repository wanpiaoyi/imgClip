//
//  ViewController.m
//  ImageClip
//
//  Created by yang on 15/8/13.
//  Copyright (c) 2015年 yang. All rights reserved.
//

#import "ViewController.h"
#import "ImageClips.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)showImageClips:(id)sender{
    ImageClips *img = [[ImageClips alloc] init];
    [img setReturnBlock:nil image:nil control:0.5];
    [self presentViewController:img animated:YES completion:nil];
}

@end
