def is_same(file_a, file_b):
    import filecmp
    return filecmp.cmp(file_a, file_b, shallow=False)

def read(filepath):
    from properties import Properties
    with open(filepath, "r") as f:
        return Properties(f)

def readExpected(filepath):
    result = {}
    with open(filepath, "r") as f:
        key = None
        for i, l in enumerate(f.readlines()):
            line = l.rstrip("\n")
            if i % 2 == 0:
                key = line
            else:
                result[key] = line

    return result

def write(filepath, obj):
    with open(filepath, "w") as f:
        f.write(str(obj))

def createDirectory(directory):
    import os
    if not os.path.exists(directory):
        os.makedirs(directory)

if __name__ == '__main__':
    pass