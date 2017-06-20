#!/usr/bin/env python
# -*- coding: utf-8 -*-

import re
import io

from sets import Set

from helpers import parse_string

def parse_html(source_path):
    """
    Takes an HTML file and removes the tags from it. All the text content that resides
    in the file, that is not text within <>, will be used as a search base for unique
    words. Returns a set containing unique words with special characters.

    Uses the parse_strings helper for parsing the words defined in the lexicon. See its'
    documentation for details regarding parsing.
    """

    result = Set()
    with io.open(source_path, encoding='utf-8') as file:
        for line in file:
            # Remove any HTML tags from the file
            cleanedLine = re.sub(u'<(/?)([^<>]*)>', '', line)

            # Parse the remaining content of the line for words
            result.update(parse_string(cleanedLine))

    return result
