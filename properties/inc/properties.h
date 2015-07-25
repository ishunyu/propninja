//
//  properties.h
//  properties
//
//  Created by Shun Yu on 2/28/15.
//  Copyright (c) 2015 workday. All rights reserved.
//

#ifndef properties_properties_h
#define properties_properties_h

#include <string>
#include <vector>
#include <iostream>
#include <fstream>

#include "property.h"

namespace properties
{
    typedef std::vector<property> properties_t;
    
    class properties
    {
    public:
        properties(const std::string& path);
        
        std::string path() const;
        properties_t all() const;
        
        std::string operator[](const std::string& key) const;
        
    private:
        properties_t parse() const;
        
        
        
        const std::string _path;
        const properties_t _properties;
    };
}

#endif
