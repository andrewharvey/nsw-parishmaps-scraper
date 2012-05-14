
# This file is licensed CC0 by Andrew Harvey <andrew.harvey4@gmail.com>
#
# To the extent possible under law, the person who associated CC0
# with this work has waived all copyright and related or neighboring
# rights to this work.
# http://creativecommons.org/publicdomain/zero/1.0/

all : clean scrape make_index sid_urls download_sids

# remove all files and directories created by make all
clean :
	rm -rf scraped_pages index url_lists images

# scrape all HTML documents with details of all maps in the collection
scrape :
	./src/scrape-indexes.sh

# make a CSV index of these files (into ./index/)
make_index :
	./src/make_index.pl scraped_pages/PL_HTML/* scraped_pages/PH_HTML/*

# generate lists of URLs of the .sid files which we can download
sid_urls :
	mkdir "url_lists"
	cat index/CY.csv | tail -n +2 | cut -d',' -f7,8 | tr ',' '/' | sed 's/^/http:\/\/parishmaps.lands.nsw.gov.au\/mrsid\/image_sid.pl?client=pmap\&image=/' | sed s/$$/.sid/ > url_lists/CY.txt
	cat index/PL.csv | tail -n +2 | cut -d',' -f8,9 | tr ',' '/' | sed 's/^/http:\/\/parishmaps.lands.nsw.gov.au\/mrsid\/image_sid.pl?client=pmap\&image=/' | sed s/$$/.sid/ > url_lists/PL.txt
	cat index/PH.csv | tail -n +2 | cut -d',' -f8,9 | tr ',' '/' | sed 's/^/http:\/\/parishmaps.lands.nsw.gov.au\/mrsid\/image_sid.pl?client=pmap\&image=/' | sed s/$$/.sid/ > url_lists/PH.txt
	cat index/ML.csv | tail -n +2 | cut -d',' -f8,9 | tr ',' '/' | sed 's/^/http:\/\/parishmaps.lands.nsw.gov.au\/mrsid\/image_sid.pl?client=pmap\&image=/' | sed s/$$/.sid/ > url_lists/ML.txt
	cat index/TN.csv | tail -n +2 | cut -d',' -f7,8 | tr ',' '/' | sed 's/^/http:\/\/parishmaps.lands.nsw.gov.au\/mrsid\/image_sid.pl?client=pmap\&image=/' | sed s/$$/.sid/ > url_lists/TN.txt

# download each .sid file which we have found through the scraping process and
# rename the downloaded files into a clean structure
download_sids :
	./src/download-sids.sh


