//
//  TwoVC.m
//  ReactiveCocoaDemo
//
//  Created by 邱学伟 on 16/9/13.
//  Copyright © 2016年 邱学伟. All rights reserved.
//

#import "TwoVC.h"

@interface TwoVC ()

@end

@implementation TwoVC
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)method:(id)sender {
    NSLog(@"Two操作!!");
    if (self.delegateSubject) {
        [self.delegateSubject sendNext:@"点击XXX操作!"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
