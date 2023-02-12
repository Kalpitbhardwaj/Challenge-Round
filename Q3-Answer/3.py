{
 "cells": [
  {
   "cell_type": "code",
   "execution_count": 5,
   "id": "0b5086c9",
   "metadata": {},
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "a\n"
     ]
    }
   ],
   "source": [
    "def getKey(obj: dict):\n",
    "    keys = list(obj)\n",
    "    if len(keys) != 1:\n",
    "        raise Exception('multiple keys or empty dict found')\n",
    "    else:\n",
    "        return keys[0]\n",
    "\n",
    "def getNestedValue(obj: dict, key: str, isFound = False):\n",
    "    if type(obj) is not dict and not isFound:\n",
    "        return None\n",
    "    if (isFound or (key in obj.keys())) :\n",
    "        if type(obj[key]) is dict:\n",
    "            return getNestedValue(obj[key], getKey(obj[key]), True)\n",
    "        else:\n",
    "            return obj[getKey(obj)]\n",
    "    else:\n",
    "        nestedKey = getKey(obj)\n",
    "        return getNestedValue(obj[nestedKey], key, False)\n",
    "\n",
    "if __name__ == '__main__':\n",
    "    obj = {'x': {'y': {'z': 'a'}}}\n",
    "    value = getNestedValue(obj, 'x')\n",
    "    print(value)"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "id": "7f18394f",
   "metadata": {},
   "outputs": [],
   "source": []
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3 (ipykernel)",
   "language": "python",
   "name": "python3"
  },
  "language_info": {
   "codemirror_mode": {
    "name": "ipython",
    "version": 3
   },
   "file_extension": ".py",
   "mimetype": "text/x-python",
   "name": "python",
   "nbconvert_exporter": "python",
   "pygments_lexer": "ipython3",
   "version": "3.9.13"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
