//
//  vessel_temp_context.hpp
//  VesselKitDemo
//
//  Created by apple on 2022/7/17.
//

#ifndef vessel_temp_context_hpp
#define vessel_temp_context_hpp

#include <stdio.h>
#include <vector>
#include <string>
#include "vessel_singleton.hpp"
using namespace std;

#ifdef __cplusplus
extern "C" {
#endif
class TempContext {
public:
    TempContext(){};
    ~TempContext(){};
    friend class VesselSingleton<TempContext>;
    void save_modules(vector<string> modules);
    vector<string> get_modules();
    void save_services(vector<string> services);
    vector<string> get_services();
private:
    vector<string> _modules;
    vector<string> _services;
};

#ifdef __cplusplus
}
#endif

#endif /* vessel_temp_context_hpp */
