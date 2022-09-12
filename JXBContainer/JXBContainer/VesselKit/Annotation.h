//
//  Annotation.h
//  VesselKitDemo
//
//  Created by apple on 2022/7/17.
//

#import <Foundation/Foundation.h>

#ifndef ModuleSectName
#define ModuleSectName "VesselModules"
#endif

#ifndef ServiceSectName
#define ServiceSectName "VesselServices"
#endif

#define VesselData(sectname) __attribute((used, section("__DATA,"#sectname" ")))

#define Module(name) \
class Annotation; char * k##name##_mod VesselDATA(VesselModules) = ""#name"";

#define Service(servicename, impl) \
class Annotation; char * k##servicename##_service VesselDATA(VesselServices) = "{ \""#servicename"\" : \""#impl"\"}";


@interface Annotation : NSObject

@end
