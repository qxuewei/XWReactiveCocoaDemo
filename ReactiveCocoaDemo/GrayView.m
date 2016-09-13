//
//  GrayView.m
//  ReactiveCocoaDemo
//
//  Created by 邱学伟 on 16/9/13.
//  Copyright © 2016年 邱学伟. All rights reserved.
//

#import "GrayView.h"



@implementation GrayView

-(RACSubject *)subject{
    if (!_subject) {
        _subject = [RACSubject subject];
    }
    return _subject;
}

-(IBAction)btnClick:(id)sender{
    NSLog(@"点击灰色View上的按钮了!!");
    [self.subject sendNext:@{@"name":@"qxuewei"}];
}

@end
