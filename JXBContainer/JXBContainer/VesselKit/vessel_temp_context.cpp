//
//  vessel_temp_context.cpp
//  VesselKitDemo
//
//  Created by apple on 2022/7/17.
//

#include "vessel_temp_context.hpp"

void TempContext::save_modules(vector<string> modules) {
    if (_modules.empty()) _modules = modules;
}

vector<string> TempContext::get_modules() {
    return _modules;
}

void TempContext::save_services(vector<string> services) {
    if (_services.empty()) _services = services;
}

vector<string> TempContext::get_services() {
    return _services;
}
