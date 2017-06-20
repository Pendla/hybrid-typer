#!/usr/bin/env python
# -*- coding: utf-8 -*-

import re
import xml.etree.ElementTree as ET

from sets import Set

from helpers import parse_string, parse_strings

def parse_xdxf(source_path):
    """
    Takes a file on the standardised format of XDXF and returns a set containining unique
    words from the lexicon that include special characters å, ä or ö.

    Any words that include spaces, commas or pipes ("|") will be separated and added to
    the set individually. For example <k>ölands|bron<k> will add ölands, and then try to
    add bron, but as it doesn't contain any special characters, it wont be added.
    Furthermore this function uses the parse_string helper for parsing the words defined
    in the lexicon. See its' documentation for more details regarding parsing.
    """

    result = Set()

    # Convert the XML structure into an ElementTree
    root = ET.parse(source_path).getroot()

    # Iterate the words in the lexicon
    for word in root.iter('k'):
        wordText = word.text
        # Check for special cases where words contain spaces, commas or pipes. We handle
        # these separately.
        split_by = None
        if " " in wordText:
            split_by = " "
        elif "|" in wordText:
            split_by = "|"
        elif "," in wordText:
            split_by = ","

        if split_by != None:
            result.update(parse_strings(wordText.split(split_by)))
        else:
            result.update(parse_string(wordText))

    return result
