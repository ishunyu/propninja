"""
Parses the .properties file according to java.util.Properties#load(Reader)
(https://docs.oracle.com/javase/7/docs/api/java/util/Properties.html#load(java.io.Reader)).
Unicode currently not supported.

Details
Parses line by line, and has a collector to do the work of gathering the 
whitespaces/comments into a single block. It tries to defeat lookahead by doing
this complicated generator(yield) thing. Time will tell if this was a good idea.

The result is a linked list of key/element data pairs and whitespace/comment 
non-data blocks.

Examples
Below are all valid key/element data pairs. Pairs except for the first one are
equivalent.
key
key value
key:value
key=value
key = value
key=v\
alue
key=v\
 alue
key=v\
    alue
key=v\
a\
l\
u\
e
"""

from property import Property, Comment

T_DATA = 0
T_NON_DATA = 1

CTYPE_CHAR = 0
CTYPE_WHITESPACE = 1
CTYPE_ASSIGNER = 2
CTYPE_COMMENT_STARTER = 3

C_ESCAPE = "\\"

A_WHITESPACE = [" ", "\t", "\f"]
A_ASSIGNERS = ["=", ":"]
A_COMMENT_STARTERS = ["#", "!"]

def parse(r):
    root = None
    curr = None

    for item in _parse_properties_item(r):        
        if root is None:
            root = item

        if curr:
            curr.next = item

        item.prev = curr
        curr = item

    return root

def _parse_properties_item(r):
    while r.has_next():
        t, x = _parse_item(r)
        if t is T_DATA:
            yield Property(x[0], x[1], x[2], x[3], x[4])
        elif t is T_NON_DATA:
            cs = [x]
            while True:
                if not r.has_next():
                    yield Comment(cs)
                    break

                _t, _x = _parse_item(r)
                if _t is T_DATA:
                    yield Comment(cs)
                    yield Property(_x[0], _x[1], _x[2], _x[3], _x[4])
                    break
                elif _t is T_NON_DATA:
                    cs.append(_x)
                else:
                    raise Exception("Invalid condition. t:%s, x: %s, _t:%s, _x: %s" % (t, x, _t, _x))
        else:
            raise Exception("Invalid condition. t:%s, x: %s" % (t, x)) 


def _parse_item(r):
    line = r.next()
    
    if not line:
        return (T_NON_DATA, line)
    
    key = -1
    wsAssigner = -1
    assigner = -1
    wsElement = -1
    element = -1

    escape = False

    for i, c in enumerate(line):
        ctype = None
        if escape:
            ctype = CTYPE_CHAR
            escape = False
        elif c == C_ESCAPE:
            escape = True
            continue
        elif c in A_WHITESPACE:
            ctype = CTYPE_WHITESPACE
        elif c in A_COMMENT_STARTERS:
            ctype = CTYPE_COMMENT_STARTER
        elif c in A_ASSIGNERS and assigner < 0:
            ctype = CTYPE_ASSIGNER
        else:
            ctype = CTYPE_CHAR

        if ctype == CTYPE_CHAR:
            if element >= 0:
                pass
            elif wsElement >= 0:
                element = i
            elif assigner >= 0:
                wsElement = i
                element = i
            elif wsAssigner >= 0:
                assigner = i
                wsElement = i
                element = i
            elif key >= 0:
                pass
            elif key < 0:
                key = i
        elif ctype == CTYPE_WHITESPACE:
            if element >= 0:
                pass
            elif wsElement >= 0:
                pass
            elif assigner >= 0:
                pass
            elif wsAssigner >= 0:
                pass
            elif key >= 0:
                wsAssigner = i
        elif ctype == CTYPE_COMMENT_STARTER:
            if key < 0:
                return (T_NON_DATA, line)
        elif ctype == CTYPE_ASSIGNER:
            assigner = i
            wsElement = i + 1
            if wsAssigner < 0:
                wsAssigner = i
            if key < 0:
                key = i
        else:
            raise Exception("Unknown type: %s" % (ctype))

    elements = [[line[wsElement:element], line[element:]]]
    data = (
        line[:key],
        line[key:wsAssigner],
        line[wsAssigner:assigner],
        line[assigner:wsElement],
        elements
    )

    _parse_multiline(r, elements, escape)

    return (T_DATA, data)

def _parse_multiline(r, elements, escape):
    while escape and r.has_next():
        line = r.next()
        escape = False

        ctype = None
        element = -1
        for i, c in enumerate(line):
            if escape:
                ctype = CTYPE_CHAR
                escape = False
            elif c == C_ESCAPE:
                escape = True
                continue
            elif c in A_WHITESPACE:
                ctype = CTYPE_WHITESPACE
            else:
                ctype = CTYPE_CHAR

            if ctype == CTYPE_CHAR and element < 0:
                element = i

        elements.append([line[:element], line[element:]])
 