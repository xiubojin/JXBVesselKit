//
//  JXBAnnotation.h
//  JXBContainer
//
//  Created by 金修博 on 2019/1/15.
//  Copyright © 2019 金修博. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXBContainerDefines.h"

#ifndef ContainerModSectName
#define ContainerModSectName  "ContainerMods"
#endif

#define ContainerDATA(sectname) __attribute((used, section("__DATA,"#sectname" ")))


/**
 模块注册宏（同步触发模块的init事件）
 @param name 模块名称
 */
#define ContainerMod(name) \
class JXBContainerDefines; char * k##name##_mod ContainerDATA(ContainerMods) = ""#name"";

@interface JXBAnnotation : NSObject

@end
