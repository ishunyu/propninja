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
CTYPE_COMMENT_STARTER = 2
CTYPE_ASSIGNER = 3

C_ESCAPE = "\\"

A_WHITESPACE = [" ", "\t", "\f"]
A_ASSIGNERS = ["=", ":"]
A_COMMENT_STARTERS = ["#", "!"]

def parse(r):
    root = None
    prev = None

    while r.has_next():
        block = _parse_block(r)
        if block:
            if root is None:
                root = block

            if prev:
                prev.next = block

            block.prev = prev
            prev = block

    return root

def _parse_block(r):
    t, x = _parse_item(r)
    if t is T_DATA:
        yield x
    elif t is T_NON_DATA:
        cs = [x]
        while True:
            _t, _x = _parse_item(r)
            if _t is T_DATA:
                yield Comment(cs)
                yield _x
            elif _t is T_NON_DATA:
                cs.append(_x)
            else:
                raise Exception("Invalid condition. t:%s, x: %s, _t:%s, _x: %s" % (t, x, _t, _x)) 
    else:
        raise Exception("Invalid condition. t:%s, x: %s" % (t, x)) 


def _parse_item(r):
    line = r.next()
    begin = r.where()

    if not line:
        return (T_NON_DATA, line)
    
    key = -1
    wsAssignerStart = -1
    assigner = -1
    wsElementStart -1
    elementStart = -1

    escape = False

    for i, c in enumerate(line):
        ctype = None
        if escape:
            ctype = CTYPE_CHAR
        elif c == C_ESCAPE:
            escape = True
            continue
        elif c in A_WHITESPACE:
            ctype = CTYPE_WHITESPACE
        elif c in A_COMMENT_STARTERS:
            ctype = CTYPE_COMMENT_STARTER
        elif c in A_ASSIGNERS and not assigner >= 0:
            ctype = CTYPE_ASSIGNER
        else:
            ctype = CTYPE_CHAR

        if ctype == CTYPE_WHITESPACE:
            if elementStart >= 0:
                pass
            elif assigner >= 0:
                pass
            elif keyEnd:
                pass
            elif keyStart:
                keyEnd = True
        elif ctype == CTYPE_COMMENT_STARTER:
            if not keyStart:
                return (T_NON_DATA, line)
        elif ctype == CTYPE_ASSIGNER:
            if elementStart:
                pass
            elif assigner:
                elementStart = True
            elif keyEnd:
                assigner = True
            elif keyStart:
                keyEnd = True


def _parse_multiline_property(r):
    start = r.where()

    while r.has_next():
        next_line = r.peek()
        next_line = clean(next_line)

        if _is_whitespace_or_comments(next_line):
            break

        r.next() # advance because it's going to be part of this property
        line = next_line # next_line becomes current line
            
        # depending on what the next line is, we will continue to accumulate this property
        if _is_multiline_property(line):  
            continue

        # or skip
        break

    return Property(r[start:r.where()+1])
