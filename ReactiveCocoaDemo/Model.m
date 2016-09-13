//
//  Model.m
//  ReactiveCocoaDemo
//
//  Created by 邱学伟 on 16/9/13.
//  Copyright © 2016年 邱学伟. All rights reserved.
//

#import "Model.h"

@implementation Model
+(instancetype)ModelWithDict:(NSDictionary *)dict{
    Model *model = [[Model alloc] init];
    //KVO 字典转模型
    [model setValuesForKeysWithDictionary:dict];
    return model;
}
@end
