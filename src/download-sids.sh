#!/bin/sh

# Download all .sid URLs created by make sid_urls and then move the downloaded
# files into a clean file/directory structure.

# This file is licensed CC0 by Andrew Harvey <andrew.harvey4@gmail.com>
#
# To the extent possible under law, the person who associated CC0
# with this work has waived all copyright and related or neighboring
# rights to this work.
# http://creativecommons.org/publicdomain/zero/1.0/

for t in CY PL PH ML TN ; do
    mkdir -p "images/$t"
    wget --directory-prefix=images/$t -i url_lists/$t.txt
    for f in images/$t/*.sid ; do
        n=`echo $f | cut -d'=' -f3 | sed 's/%2F/\//'`
        a=`echo $n | cut -d'/' -f1`
        b=`echo $n | cut -d'/' -f2`
        mkdir -p "images/$t/$a"
        mv "$f" "images/$t/$n"
    done
done
