# About

The NSW Department of Lands publishes historical Parish maps at [http://parishmaps.lands.nsw.gov.au/pmap.html](http://parishmaps.lands.nsw.gov.au/pmap.html).

Their front end web user interface may be fine if you just wish to find and view
in your web browser a particular area which you know the name of. However it
isn't very machine readable nor suited for the user wishing to download all the
parish maps and the whole collections metadata.

The scripts in this project were born out of my desire to download all the raw
parish maps available through the site and obtain a machine readable index of
the collection. I don't need a reason for this, but one was so I would build a
better front end to the maps.

Currently you should be able to just run `make` and you should end up with a
simple CSV index of the collection and a directory of .sid files. This process
can take (assuming no errors arise) anywhere from several hours to several days,
and consume roughly 83GB of network download and disk space. (creating the
collection index alone will take a few hours)

Since the Department of Lands can change their web service at any time these
scripts may break.

The MrSID files downloaded are good because they are small in file size and are
the original "source" files, but they are bad because they are in a proprietary
format. The GDAL library can read these MrSID files when combined with the
libraries provided by the vendor. Refer to [the instructions](http://trac.osgeo.org/gdal/wiki/MrSID).

# Dependencies
To run these script you will require the following (Debian package names listed)

    libswitch-perl, libhtml-tableextract-perl, wget, make

# Special Request to the NSW Department of Lands
Please release all these map photographs and collection metadata under a free
license. You already make them available through your website for zero charge,
so changing the license won't affect your revenue stream.

Changing the license will allow other parties to do useful things with these
maps that your department would never thought of or have the resources to do
yourselves.

Other parties will be able to mirror your content reducing your internet
bandwidth requirements.

Using a free license will help make these valuable historical documents more
accessible and easier to use.

Many of these maps qualify for the public domain already, but many don't. Some
were initially created more than 50 years ago but have more recent revisions to
them. Additionally it is legally unclear whether your Department can claim a
more recent copyright to these digital photograph copies. The official position
of the Wikimedia Foundation is that "faithful reproductions of two-dimensional
public domain works of art are public domain, and that claims to the contrary
represent an assault on the very concept of a public domain".<sup>[ref] [1]</sup>

The Department of Lands as the publisher of these faithful reproduction should
remove the legal uncertainty by declaring these digital copies into the public
domain.

[1]: http://commons.wikimedia.org/wiki/Template:PD-Art

# Copyright
All the files within this repository are released under the
[CC0](http://creativecommons.org/publicdomain/zero/1.0/) license by
Andrew Harvey <andrew.harvey4@gmail.com>.

    To the extent possible under law, the person who associated CC0
    with this work has waived all copyright and related or neighboring
    rights to this work.
    http://creativecommons.org/publicdomain/zero/1.0/

