def togetKey(obj: dict):
    keys = list(obj)
    if len(keys) != 1:
        raise Exception('You have entered multiple key or empty dictionary')
    else:
        return keys[0]

def togetNestedValue(obj: dict, key: str, isFound = False):
    if type(obj) is not dict and not isFound:
        return None
    if (isFound or (key in obj.keys())) :
        if type(obj[key]) is dict:
            return togetNestedValue(obj[key], togetKey(obj[key]), True)
        else:
            return obj[togetKey(obj)]
    else:
        nestedKey = togetKey(obj)
        return togetNestedValue(obj[nestedKey], key, False)

if __name__ == '__main__':
    obj = {'x': {'y': {'z': 'a'}}}
    value = togetNestedValue(obj, 'x')
    print(value)
