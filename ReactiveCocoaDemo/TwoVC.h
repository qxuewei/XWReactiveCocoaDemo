//
//  TwoVC.h
//  ReactiveCocoaDemo
//
//  Created by 邱学伟 on 16/9/13.
//  Copyright © 2016年 邱学伟. All rights reserved.
//

#import "ViewController.h"
#import "GlobalHeader.h"
@interface TwoVC : ViewController
@property (nonatomic, strong) RACSubject *delegateSubject;
@end
