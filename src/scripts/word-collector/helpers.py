#!/usr/bin/env python
# -*- coding: utf-8 -*-

import re

from sets import Set

def contains_special_characters(word):
  """
  Checks whether or not the given word contains any of the special characters for the
  language we are collecting words for (For now only Swedish is supported).

  This function assumes that the word comes in as all lowercase.
  """

  # TODO Support more languages
  return u"å" in word or u"ä" in word or u"ö" in word

def parse_strings(strings):
    """
    Takes a list of raw strings and searches it for words that contain special characters.
    A set containing unique words with special characters will be returned.

    This function utilizes parse_string to parse each string. See its' documentation
    for further details regarding parsing.
    """

    result = Set()
    for string in strings:
        result.update(parse_string(string))

    return result

def parse_string(string):
    """
    Takes a raw string and searches it for words that contain special characters. A set
    containing unique words with special characters will be returned.

    Words in the text that contain special characters (non-alphabetic) will be cleaned up.
    Thus all unique words returned in the set will be alphabetic only. Furthermore, all
    words are compared as lowercase letters, and are returned as such as well.
    """

    result = Set()
    for word in string.split():
        # We always compare strings with lowercase
        lowerWord = word.lower()

        # Check if the word contains any of the special characters defined for the active
        # language
        if not contains_special_characters(lowerWord):
            continue

        # Remove any non-alphabetic characters
        cleanedWord = re.sub(u'[^a-zåäö]', '', lowerWord)

        # Add the cleaned up word to the set of unique words
        result.add(cleanedWord)

    return result

