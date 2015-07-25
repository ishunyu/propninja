//
//  properties.cpp
//  properties
//
//  Created by Shun Yu on 2/28/15.
//  Copyright (c) 2015 workday. All rights reserved.
//

#include "inc/property.h"

namespace properties
{
    property::property(const std::string key, const std::string value)
    : _key(key), _value(value)
    {
    }
    
    
    std::string property::get_key() const
    {
        return _key;
    }
    
    std::string property::get_value() const
    {
        return _value;
    }
}