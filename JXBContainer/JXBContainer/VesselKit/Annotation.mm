//
//  Annotation.m
//  VesselKitDemo
//
//  Created by apple on 2022/7/17.
//

#import "Annotation.h"
#include <mach-o/getsect.h>
#include <mach-o/loader.h>
#include <mach-o/dyld.h>
#include <mach-o/ldsyms.h>
#include <dlfcn.h>
#import <vector>
#import <string>
#include "vessel_singleton.hpp"
#include "vessel_temp_context.hpp"
#import "ModuleManager.h"
#import "ServiceManager.h"

@implementation Annotation

std::vector<std::string> vessel_read_configuration_from_image(std::string sectionName, const struct mach_header *mhp) {
    std::vector<std::string> configs;
    unsigned long size = 0;
    const char *secname = sectionName.c_str();
#ifndef  __LP64__
    intptr_t *memory = (intptr_t *)getsectiondata(mhp, SEG_DATA, secname, &size);
#else
    const struct mach_header_64 *mhp64 = (const struct mach_header_64 *)mhp;
    uintptr_t *memory = (uintptr_t *)getsectiondata(mhp64, SEG_DATA, secname, &size);
#endif
    unsigned long counter = size / sizeof(void*);
    for (int idx = 0; idx < counter; ++idx) {
        char *data = (char *)memory[idx];
        std::string str = data;
        if (str.empty()) continue;
        if (str.length() > 0) configs.push_back(str);
    }
    return configs;
}

static void dyld_callback(const struct mach_header *mhp, intptr_t vmaddr_slide) {
    std::vector<std::string> modules = vessel_read_configuration_from_image(ModuleSectName, mhp);
    if (!modules.empty()) {
        VesselSingleton<TempContext>::instance().save_modules(modules);
    }
    
    std::vector<std::string> services = vessel_read_configuration_from_image(ServiceSectName, mhp);
    if (!services.empty()) {
        VesselSingleton<TempContext>::instance().save_services(services);
    }
}

__attribute__((constructor))
void initProphet(void) {
    _dyld_register_func_for_add_image(dyld_callback);
}



@end
