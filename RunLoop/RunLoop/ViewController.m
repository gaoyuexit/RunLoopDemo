//
//  ViewController.m
//  RunLoop
//
//  Created by 郜宇 on 16/6/18.
//  Copyright © 2016年 郜宇. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    [self runloopObserve];
    
    

    
}





- (void)runloopObserve
{
    // 这个方法是KVO,并不是观察runloop的状态,下面的方法才是监听状态
    //    [NSRunLoop currentRunLoop] addObserver:<#(nonnull NSObject *)#> forKeyPath:<#(nonnull NSString *)#> options:<#(NSKeyValueObservingOptions)#> context:<#(nullable void *)#>
    
    
    /**
     *  创建runloop观察着
     *
     *  @param allocator#>  默认的allocator 点进去选择默认的即可
     *  @param activities#> 监听的状态(即将进入runloop,即将处理timer,即将处理source,即将进入休眠,刚从休眠中唤醒,即将退出runloop,监听所有状态)
     *  @param repeats#>    是否重复监听 YES 重复监听 description#>
     *  @param order#>      传0即可, description#>
     *  @param observer     runloop观察着
     *  @param activity     监听到的状态(枚举值)
     *
     *  @return runloop观察着
     */
    CFRunLoopObserverRef observe = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        
        NSLog(@"监听到runloop状态发生改变---%zd", activity);
        // 这个方法也挺有用的,比如我们想在处理timer之前做一些事情,处理事件之前做一些事情
    });
    
    
    /**
     *  添加观察着,监听runloop的状态
     *
     *  @param rl#>       runloop对象 description#>
     *  @param observer#> runloop观察着 description#>
     *  @param mode#>     runloop的模式 description#>
     */
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observe, kCFRunLoopDefaultMode);
    
    /**
     *  CF CoreFounction框架的东西不受ARC控制,需要自己手动释放
     *  释放observe
     */
    CFRelease(observe);
    
    /**
     ARC只管OC的东西
     CF CoreFounction的内存管理:
     * 1.凡是带有Create,Copy,Retain等字眼的函数,创建出来的对象,都要在最后做一次release操作
     * 2.release函数:CFRelease(对象);
     
     */
}




/**
 *  runloop与线程关系
 */
- (void)thread
{
    // 主线程中打印的mainRunLoop, currentRunLoop内存地址是相同的
    //    NSLog(@"%p---%p", [NSRunLoop mainRunLoop], [NSRunLoop currentRunLoop]);
    //
    //    // 创建一个子线程
    //    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(run) object:nil];
    //    [thread start];
}





- (void)timer
{
    
    /**
     *  这个方法内部实现是: 创建timer,添加到RunLoop中的默认的Mode中,RunLoop启动这个mode,取出这个mode中timer来用
     */
    // 调用了scheduledTimer返回的NSTimer的定时器对象,已经被自动添加到当前的runLoop中(一个线程对应一个runloop,如果在子线程中添加定时器..添加到子线程的runloop中),默认为NSDefaultRunLoopMode模式
    //    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(run) userInfo:nil repeats:YES];
    
    
    /**
     *  上面的代码等同于下面的
     */
    // 创建Timer
    //    NSTimer *timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(run) userInfo:nil repeats:YES];
    
    //    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    /**
     *  定时器会跑在标记为common modes的模式下(这个模式只是个标记)
     *  RunLoop会寻找带有common标签的模式,有这个标签的,都可以跑
     *  打印当前的RunLoop信息输出为:(有common modes标签的有两个,UITrackingRunLoopMode和kCFRunLoopDefaultMode),所以定时器可以在这两个模式下跑
     
     common modes = <CFBasicHash 0x7fb8b2700490 [0x10ec6ba40]>{type = mutable set, count = 2,
     entries =>
     0 : <CFString 0x10fba2210 [0x10ec6ba40]>{contents = "UITrackingRunLoopMode"}
     2 : <CFString 0x10ec8c5e0 [0x10ec6ba40]>{contents = "kCFRunLoopDefaultMode"}
     }
     
     
     */
    //    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    //    NSLog(@"-----------%@", [NSRunLoop currentRunLoop]);
    //
    //
    //
    //    [[NSRunLoop currentRunLoop] addTimer:timer forMode:UITrackingRunLoopMode];
    //
    //
    //    
    //    
    //    CADisplayLink *link;
}



- (void)run
{
    // 开启的子线程默认是没有runloop的
    
    // 手动创建runloop对象, [NSRunLoop currentRunLoop]创建, 懒加载的创建方法,第一次访问创建,以后就不会创建了
//    NSRunLoop *currentLoop = [NSRunLoop currentRunLoop];
//    
//    [currentLoop runMode:<#(nonnull NSString *)#> beforeDate:<#(nonnull NSDate *)#>];
//    
//    NSLog(@"thred--%p", currentLoop); //打印的内存地址和主线程的不同
}




- (IBAction)ButtonClick:(id)sender {
    
    NSLog(@"---ButtonClick---");
    
}









@end
