#!/usr/bin/env python
# -*- coding: utf-8 -*-

import io
import re

from sets import Set

from helpers import parse_string, parse_strings

def parse_txt(source_path):
    """
    Extracts unique words from the file at the given source_path that contains special
    characters.

    This function uses the parse_string helper for parsing the words defined in the
    txt file. See its' documentation for more details regarding parsing.
    """

    # A set that keeps track of the unique words that are in the text
    result = Set()
    for line in io.open(source_path, encoding='utf-8'):
        result.update(parse_string(line))

    return result
