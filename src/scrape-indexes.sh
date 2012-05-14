#!/bin/sh

# This script will scrape parishmaps.lands.nsw.gov.au of all maps listed in the
# collection and save all these scraped HTML documents in a working directory.

# This file is licensed CC0 by Andrew Harvey <andrew.harvey4@gmail.com>
#
# To the extent possible under law, the person who associated CC0
# with this work has waived all copyright and related or neighboring
# rights to this work.
# http://creativecommons.org/publicdomain/zero/1.0/


# we need this to prepend to file references where those files are in the same
# directory as this script
cwd=`dirname $0`

# a working directory used to store temporary files
wd=scraped_pages
mkdir $wd

# get the HTML pages indexing Pastoral Maps
wget -O $wd/pastoral-query.html 'http://parishmaps.lands.nsw.gov.au/search/pmap_websearch.query?mname=&mtype=PL'

# and the same for Parish, Town, County and Municipality maps
# But because the request will timeout for the empty string we need to limit the
# results. Since the search is on the map name, I start with a search for a
# single letter...
mkdir $wd/parish-query
for q in C D F H J K P Q S T V X Y Z ; do
  echo "PH $q"
  wget -O $wd/parish-query/$q.html "http://parishmaps.lands.nsw.gov.au/search/pmap_websearch.query?mname=$q&mtype=PH"
  ret=$?
  [ $ret == 0 ] || echo "Search failed on $q"
done

# ...but then some still time out so we need to try a two letter combo to avoid
# the timeout being reached. Note that these are based on my observed timeouts
# and they may vary for you.
for qa in A B E G I L M N O R U ; do
  for qb in A B C D E F G H I J K L M N O P Q R S T U V W X Y Z ; do
    echo "PH $qa$qb"
    wget -O $wd/parish-query/$qa$qb.html "http://parishmaps.lands.nsw.gov.au/search/pmap_websearch.query?mname=$qa$qb&mtype=PH"
    ret=$?
    [ $ret == 0 ] || echo "Search failed on $q"
  done
done


# extract the links from these pages
cat $wd/pastoral-query.html | grep -o 'href="[^"]*query[^"]*"' | sed 's/^href="/http:\/\/parishmaps.lands.nsw.gov.au\/search\//' | sed 's/"$//' | sort | uniq > $wd/pastoral-pages.txt

cat $wd/parish-query/*.html | grep -o 'href="[^"]*query[^"]*"' | sed 's/^href="/http:\/\/parishmaps.lands.nsw.gov.au\/search\//' | sed 's/"$//' | sort | uniq > $wd/parish-pages.txt

# download each of these links found
mkdir $wd/PL_HTML/
wget --directory-prefix="$wd/PL_HTML/" -i $wd/pastoral-pages.txt

mkdir $wd/PH_HTML/
wget --directory-prefix="$wd/PH_HTML/" -i $wd/parish-pages.txt

