//
//  Model.h
//  ReactiveCocoaDemo
//
//  Created by 邱学伟 on 16/9/13.
//  Copyright © 2016年 邱学伟. All rights reserved.
//  模型

#import <Foundation/Foundation.h>

@interface Model : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *icon;

+(instancetype)ModelWithDict:(NSDictionary *)dict;

@end
