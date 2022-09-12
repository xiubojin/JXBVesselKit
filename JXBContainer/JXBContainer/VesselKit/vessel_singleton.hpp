//
//  vessel_singleton.hpp
//  VesselKitDemo
//
//  Created by apple on 2022/7/17.
//

#ifndef vessel_singleton_hpp
#define vessel_singleton_hpp

#include <stdio.h>

template <typename  T>
struct VesselSingleton {
    struct object_creator {
        object_creator(){ VesselSingleton<T>::instance(); }
        inline void do_nothing() const {}
    };
    
    static object_creator create_object;
    
public:
    typedef  T object_type;
    static object_type& instance() {
        static object_type obj;
        create_object.do_nothing();
        return obj;
    }
};

template <typename T> typename  VesselSingleton<T>::object_creator VesselSingleton<T>::create_object;

#endif /* vessel_singleton_hpp */
