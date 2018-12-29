//
//  JXBCommon.h
//  JXBContainer
//
//  Created by 金修博 on 2018/11/27.
//  Copyright © 2018 金修博. All rights reserved.
//

#ifndef JXBCommon_h
#define JXBCommon_h

// Debug Logging
#ifdef DEBUG
#define MagicLog(x, ...) NSLog(x, ## __VA_ARGS__);
#else
#define MagicLog(x, ...)
#endif

#endif /* JXBCommon_h */
