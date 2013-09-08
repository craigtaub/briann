#!/bin/bash -e

echo 'start'

#JSHINT
eval jshint tests/two.js;

#PHP CODE SNIFFER
eval phpcs tests/one.php;

#COMPILE SASS
#FILE=tests/sass/stylesheets/one.css
#rm tests/sass/stylesheets/one.css
#ls tests/sass/stylesheets/
if [  -f $FILE ]; then
    eval rm $FILE;
fi
eval compass compile tests/sass/;

echo 'executed'
