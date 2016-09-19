//
//  ViewController.m
//  ReactiveCocoaDemo
//
//  Created by 邱学伟 on 16/9/12.
//  Copyright © 2016年 邱学伟. All rights reserved.
//

#import "ViewController.h"
#import "TwoVC.h"
#import "GlobalHeader.h"
//#import "NSObject+RACKVOWrapper.h"
#import "GrayView.h"
#import "Model.h"

@interface ViewController ()
@property (nonatomic, strong) id<RACSubscriber> subscriber;
@property (weak, nonatomic) IBOutlet UIButton *BTN;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet GrayView *grayView;
@end

@implementation ViewController
- (IBAction)modelTwoVC:(id)sender {
    // 创建第二个控制器
    TwoVC *twoVC = [[TwoVC alloc] init];
    // 设置代理信号
    twoVC.delegateSubject = [RACSubject subject];
    // 订阅代理信号
    [twoVC.delegateSubject subscribeNext:^(id x) {
        NSLog(@"我要进行  %@  操作!!",x);
    }];
    [self presentViewController:twoVC animated:YES completion:^{
        NSLog(@"1VC->2VC");
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    // RACSingal 使用
//    [self RACSingal2];
    
    //RACSubject的使用
//    [self RACSubject];
//    [self RACSubject2];
    
    //RACSubject 代替代理
//    [self.grayView.subject subscribeNext:^(id x) {
//        NSLog(@"点击了灰色View的按钮,传递过来了->%@",x);
//    }];
    
    //RACReplaySubject
//    [self RACReplaySubject];
//    [self RACReplaySubject2];
    
//    [self RACTuple];
    
//    [self RACSequence];
    
//    [self RACSequenceToModel];
    
//    [self RAC_Delegate];
    
//    [self RAC_KVO1];
//    [self RAC_KVO2];
//    [self.grayView setFrame:CGRectZero];
    
//    [self RAC_Event];
    
//    [self RAC_Noti];
    
//    [self RAC_Text];
    
//    [self liftSelector];
    
    [self macro];
}



//常用宏
-(void)macro{
    //1.`RAC(TARGET, [KEYPATH, [NIL_VALUE]])`:用于给某个对象的某个属性绑定。
    RAC(self.label,text) = self.textField.rac_textSignal;
    //相当于:
//    [self.textField.rac_textSignal subscribeNext:^(id x) {
//        self.label.text = x;
//    }];
    
    //`RACObserve(self, name) `:监听某个对象的某个属性,返回的是信号。
//    [RACObserve(self.view,frame) subscribeNext:^(id x) {
//        NSLog(@"x:%@",x);
//    }];
    
    //4. `RACTuplePack`：把数据包装成RACTuple（元组类）
    //把一个对象包装成元组对象
    RACTuple *tuple = RACTuplePack(@"Xuewei",@"18");
    //解包元组,把元组的值，按顺序给参数里面的变量赋值
    RACTupleUnpack(NSString *name,NSString *age) = tuple;
    NSLog(@"name:%@  -  age:%@",name,age);
}


-(void)liftSelector{
    RACSignal *network0 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"AFN -> 第一个网络请求!");
        [subscriber sendNext:@[@0,@1,@2]];
        return nil;
    }];
    RACSignal *network1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"AFN -> 第二个网络请求!");
        [subscriber sendNext:@[@3,@4,@5]];
        return nil;
    }];
    //当所有信号都请求完成数据,并发送数据时,执行
    /**
     *  所有信号发送数据之后执行 Selector 方法
     *
     *  @param SEL 所执行的方法,注意应该有几个信号就需要有几个参数,一一对应!
     *  @param NSArray 所有信号包装成的数组
     *
     */
    [self rac_liftSelector:@selector(updateMainUIWithNet0:andNet1:) withSignalsFromArray:@[network0,network1]];
}
-(void)updateMainUIWithNet0:(NSArray *)net0Arr andNet1:(NSArray *)net1Arr{
    NSLog(@"主线程更新UI net0Arr:%@   net1Arr:%@",net0Arr,net1Arr);
}

//5.RAC作用五:监听文本框输入
-(void)RAC_Text{
    [_textField.rac_textSignal subscribeNext:^(id x) {
        NSLog(@"当前输入框值:%@",x);
    }];
}

//4.RAC作用四:代替通知
-(void)RAC_Noti{
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidShowNotification object:nil] subscribeNext:^(id x) {
        NSLog(@"监听键盘弹出的通知!");
    }];
}

//3.RAC作用三:监听事件
-(void)RAC_Event{
    [[_BTN rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"按钮被点击了!");
    }];
}

//2.RAC作用二:代理KVO
//*首先需要导入头文件   #import "NSObject+RACKVOWrapper.h"
-(void)RAC_KVO1{
    [self.grayView rac_observeKeyPath:@"frame" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
       //代理系统KVO
        NSLog(@"grayView 的Frame发生了改变! 变为:value:%@",value);
    }];
}
-(void)RAC_KVO2{
    [[self.grayView rac_valuesForKeyPath:@"frame" observer:nil] subscribeNext:^(id x) {
        NSLog(@"grayView 的frame发生的改变,变成了:%@",x);
    }];
}

//1.RAC作用一:代替代理
-(void)RAC_Delegate{
    [[self.grayView rac_signalForSelector:@selector(btnClick:)] subscribeNext:^(id x) {
        NSLog(@"按钮被点击了!");
    }];
}


//利用  RACSequence 字典转模型
-(void)RACSequenceToModel{
    
    NSMutableArray *arrM = [NSMutableArray array];
    //1. KVO
    NSArray *localArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"flags" ofType:@"plist"]];
//    [localArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSDictionary *dict = obj;
//        Model *KVOModel = [Model ModelWithDict:dict];
//        [arrM addObject:KVOModel];
//    }];
    
    
    //2. RACSequence
//    [localArr.rac_sequence.signal subscribeNext:^(NSDictionary *x) {
//        Model *model = [Model ModelWithDict:x];
//        [arrM addObject:model];
//    }];
    
    //3. RACSequence高级用法  会把集合中的所有元素都映射到一个新的对象
    arrM = [NSMutableArray arrayWithArray:[[localArr.rac_sequence map:^id(NSDictionary *value) {
        return [Model ModelWithDict:value];
    }] array]];
    
    NSLog(@"解析完的模型数组:%@",arrM);
    
}

-(void)RACSequence{
    //****************遍历数组*********************
    // 第一步: 把数组转换成集合RACSequence numbers.rac_sequence
    // 第二步: 把集合RACSequence转换RACSignal信号类,numbers.rac_sequence.signal
    // 第三步: 订阅信号，激活信号，会自动把集合中的所有值，遍历出来。
//     NSArray *numbers = @[@1,@2,@3,@4];
//    [numbers.rac_sequence.signal subscribeNext:^(id x) {
//        NSLog(@"遍历数组:%@",x);
//    }];
    
    //*****************遍历字典*********************
    //遍历出来的键值对会包装成RACTuple(元组对象)
    NSDictionary *dict = @{@"name":@"qxuewei",
                           @"age":@"25",
                           @"phone":@"1851891455"};
    [dict.rac_sequence.signal subscribeNext:^(RACTuple *x) {
       
//        NSString *key = x[0];
//        NSString *value = x[1];
//        NSLog(@"遍历字典:key:%@ <-> value:%@",key,value);
        
        //等同于
        
        //可以用 解包元素宏定义
        RACTupleUnpack(NSString *KEY,NSString *VALUE) = x;
        NSLog(@"遍历字典:key:%@ <-> value:%@",KEY,VALUE);
    }];
}

-(void)RACTuple{
    //元组对象
    NSArray *numbers = @[@1,@2,@3,@4];
    RACTuple *tuple = [RACTuple tupleWithObjects:numbers, nil];
    NSLog(@"tuple:%@",tuple);
}

-(void)RACReplaySubject2{
    //1.创建信号
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    //2.发送信号
    [replaySubject sendNext:@"0"];
    [replaySubject sendNext:@"1"];
    //3.订阅信号
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"第一次订阅:%@",x);
    }];
    [replaySubject subscribeNext:^(id x) {
        NSLog(@"第二次订阅:%@",x);
    }];
}

-(void)RACReplaySubject{
    //1.创建信号
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    //2.RACReplaySubject 可以先发送信号   RACSubject 就不可以!
    [replaySubject sendNext:@"987654321"];
    //3.再订阅信号
    [replaySubject subscribeNext:^(id x) {
       NSLog(@"获取所订阅的信息:%@",x);
    }];
}

-(void)RACSubject2{
    //1.创建信号
    RACSubject *subject = [RACSubject subject];
    //2.订阅信号
    [subject subscribeNext:^(id x) {
        // block调用时刻：当信号发出新值，就会调用.
        NSLog(@"第一个订阅者%@",x);
    }];
    [subject subscribeNext:^(id x) {
        // block调用时刻：当信号发出新值，就会调用.
        NSLog(@"第二个订阅者%@",x);
    }];
    //3.发送信号
    [subject sendNext:@"发送001"];
}

-(void)RACSubject{
    //1.创建信号
    RACSubject *subject = [RACSubject subject];
    //2.订阅信号
    [subject subscribeNext:^(id x) {
        NSLog(@"获取所订阅的信号信息:%@",x);
    }];
    //3.发送信号
    [subject sendNext:@"1"];
}

-(void)RACDisposable{
    //1.创建信号
    RACDisposable *(^disposable)(id<RACSubscriber> subscriber) = ^RACDisposable *(id<RACSubscriber>subscriber){
        //3.发送信号
        _subscriber = subscriber;
        [subscriber sendNext:@"发送信号123"];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"信号被取消订阅了!");
        }];
    };
    RACSignal *signal = [RACSignal createSignal:disposable];
    
    //2.订阅信号
    RACDisposable *Disposable = [signal subscribeNext:^(id x) {
        NSLog(@"获取到所订阅的信号:%@",x);
    }];
    
    //默认信号发送数据完毕后就会主动取消订阅,不过如果订阅者一直存在(成员属性强引用),就不会自动取消订阅 除非 手动取消订阅(dispose)
    [Disposable dispose];
}

// RACSignal:有数据产生的时候,就使用RACSignal
// RACSignal使用步骤: 1.创建信号  2.订阅信号 3.发送信号
-(void)RACSingal{
    RACDisposable *(^disposable)(id<RACSubscriber> subscriber) = ^RACDisposable *(id<RACSubscriber>subscriber) {
        //发送数据
        [subscriber sendNext:@110];
        return NULL;
    };
    
    //1.创建信号(冷信号)
    RACSignal *signal = [RACSignal createSignal:disposable];
//    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        NSLog(@"信号被订阅!");
//        //发送数据
//        [subscriber sendNext:@110];
//        return NULL;
//    }];
    
    //2.订阅信号(热信号)
    [signal subscribeNext:^(id x) {
        // nextBlock调用:只要订阅者发送数据就会调用
        // nextBlock作用:处理数据,展示到UI上面
        // x:信号发送的内容
        NSLog(@"%@",x);
    }];
    
    // 只要订阅者调用sendNext,就会执行nextBlock
    // 只要订阅RACDynamicSignal,就会执行didSubscribe
    // 前提条件是RACDynamicSignal,不同类型信号的订阅,处理订阅的事情不一样
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
