//
//  JXBAnnotation.h
//  MagicProject
//
//  Created by 金修博 on 2018/11/27.
//  Copyright © 2018 金修博. All rights reserved.
//

#ifndef JXBAnnotation_h
#define JXBAnnotation_h

/**
 将模块注册到容器

 此宏的作用是将模块注册到容器，并在application:didFinishLaunchingWithOptions:中同步执行模块的init事件.
 */
#define magic_module_register \
+ (void)load { [JXBContainer registerModule:[self class]]; }


/**
 将模块注册到容器

 @param isAsync 是否异步执行模块的init事件,如果此处为YES,会将模块的init事件派发到主队列异步执行,优化启动时间;如果此处为NO,效果同第一个宏.
 @return 无
 */
#define magic_module_register_async(isAsync) \
+ (void)load { [JXBContainer registerModule:[self class]]; } \
- (BOOL)async { return [[NSString stringWithUTF8String:#isAsync] boolValue];}

#endif /* JXBAnnotation_h */
