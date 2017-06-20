#!/usr/bin/env python
# -*- coding: utf-8 -*-

import codecs
import re

from sets import Set
from sys import argv, exit

from xdxf_parser import parse_xdxf
from txt_parser import parse_txt
from html_parser import parse_html

# Read arguments from the command line and construct appropriate variables
source_file_path = 'source.txt'
result_file_path = 'output.txt'
for i, flag in enumerate(argv):

    if flag.startswith('--source') or flag.startswith('-s'):
        if len(argv) >= i + 1:
            source_file_path = argv[i + 1]
            # TODO Check if the sourcesFile exists or not

    elif flag.startswith('--output') or flag.startswith('-o'):
        if len(argv) >= i + 1:
            result_file_path = argv[i + 1]

# Construct an array of source paths, reading them fron the source_file_path provided
# above. One source path per line.
source_paths = []
with open(source_file_path) as file:
    for line in file:
        # TODO Check if this file exists or not
        source_paths.append(re.sub('\n', '', line))

# TODO Do in parallel
# Iterate through all the source_paths (the array) and handle them individually
result = Set()
for i, path in enumerate(source_paths):
    print "Parsing {0} ({1}/{2}), please hold on!".format(path, i, len(source_paths))

    if path.endswith(".txt"):
        result.update(parse_txt(path))
    elif path.endswith(".xdxf"):
        result.update(parse_xdxf(path))
    elif path.endswith(".html") or path.endswith(".xhtml"):
        result.update(parse_html(path))

# Finally we write the final result set to a file, one word per line
with codecs.open(result_file_path, 'w', encoding='utf-8') as file:
    for word in result:
      file.write(word)
      file.write('\n')
