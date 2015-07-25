//
//  properties.cpp
//  properties
//
//  Created by Shun Yu on 2/28/15.
//  Copyright (c) 2015 workday. All rights reserved.
//

#include <iostream>
#include <fstream>

#include "inc/property.h"
#include "inc/properties.h"

namespace properties
{
    // public
    properties::properties(const std::string& path)
    : _path(path), _properties(parse())
    {}
    
    std::string properties::path() const
    {
        return _path;
    }
    
    properties_t properties::all() const
    {
        return _properties;
    }
    
    std::string properties::operator[](const std::string& key) const
    {
        for(const property p : _properties)
        {
            if (p.get_key() == key) {
                return p.get_value();
            }
        }
        
        return "";
    }
    
    // private
    properties_t properties::parse() const
    {
        std::ifstream file(_path.c_str());
        properties_t temp;
        
        if (file.is_open())
        {
            std::cout << "Hello!" << std::endl;
        }
        else
            throw std::exception();
        
        return temp;
    }
}

