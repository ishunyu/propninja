//
//  properties.h
//  properties
//
//  Created by Shun Yu on 2/28/15.
//  Copyright (c) 2015 workday. All rights reserved.
//

#ifndef properties_property_h
#define properties_property_h

#include <string>

namespace properties
{
    class property
    {
    public:
        property(const std::string key, const std::string value);
        
        std::string get_key() const;
        std::string get_value() const;
        
    private:
        const std::string _key;
        const std::string _value;
    };
}

#endif
