#!/bin/sh

mkdir doc
cp licenses/MIT.texinfo doc/license.texinfo
cp macros.texinfo doc/

manual_filename='babel'
system='babel'
title='Babel Manual'
subtitle='draft version'
packages='babel babel-encodings'

sed \
   -e "s!%%MANUAL-FILENAME%%!$manual_filename!g" \
   -e "s!%%SYSTEM%%!$system!g" \
   -e "s!%%PACKAGES%%!$packages!g" \
   -e "s!%%MANUAL-TITLE%%!$title!g" \
template.makefile > doc/Makefile

sed \
   -e "s!%%MANUAL-FILENAME%%!$manual_filename!g" \
   -e "s!%%MANUAL-TITLE%%!$title!g" \
   -e "s!%%MANUAL-SUBTITLE%%!$subtitle!g" \
template.texinfo > doc/${manual_filename}.texinfo

echo "Done!  See doc/ subdirectory for new files."
