#!/usr/bin/perl -w

# Make a series of csv index from downloaded HTML indexes

# This file is licensed CC0 by Andrew Harvey <andrew.harvey4@gmail.com>
#
# To the extent possible under law, the person who associated CC0
# with this work has waived all copyright and related or neighboring
# rights to this work.
# http://creativecommons.org/publicdomain/zero/1.0/

use strict;
use Switch;
use HTML::TableExtract;

# check program is invoked as expected
die "Usage: $0 [HTML_FILE]...\n" unless (@ARGV > 0);

# open output CSV files for writing
mkdir "index";
open (my $CY, '>', "index/CY.csv") or die;
open (my $PL, '>', "index/PL.csv") or die;
open (my $PH, '>', "index/PH.csv") or die;
open (my $ML, '>', "index/ML.csv") or die;
open (my $TN, '>', "index/TN.csv") or die;

# print csv header line
print $CY "mid,county,barcode,edition,sheet,year,cd_title,image_id\n";
print $PL "mid,run_name,run_number,barcode,map_no,sheet,division,cd_title,image_id\n";
print $PH "mid,parish,county,barcode,edition,sheet,year,cd_title,image_id\n";
print $ML "mid,municipality,county,barcode,edition,sheet,year,cd_title,image_id\n";
print $TN "mid,town,barcode,edition,sheet,year,cd_title,image_id\n";

# now for each html file given as a program argument
foreach my $file (@ARGV) {
    my $HTML;
    open ($HTML, '<', "$file") or die $!;
    my $html_string = join("\n", <$HTML>);

    my $mtype;
    my $mapid;
    if ($file =~ /mid=(\d+)&mtype=(\w+)/) {
        $mapid = $1;
        $mtype = $2;
    }else{
        die "Unexpected filename $file\n";
    }

    my $initial_columns = "$mapid,";
    my $fh;
    my $te = HTML::TableExtract->new( headers => ['Barcode', 'Edition', 'Sheet', 'Year', 'CD Title', 'Image ID'] );
    switch ($mtype) {
        case "CY" { # county
            $fh = $CY;
            if ($html_string =~ /<td>County:<\/td><td><b>([^<]*)<\/b><\/td>/) {
                $initial_columns .= "$1";
            }else{
                warn "Could not find first details in $file\n";
            }
        }
        case "ML" { # municipality
            $fh = $ML;
            if ($html_string =~ /<td>Municipality:<\/td><td><b>([^<]*)<\/b><\/td><\/tr><tr><td>County:<\/td><td><b>([^<]*)<\/b><\/td>/) {
                $initial_columns .= "$1,$2";
            }else{
                warn "Could not find first details in $file\n";
            }
        }
        case "PH" { # parish
            $fh = $PH;
            if ($html_string =~ /<td>Parish:<\/td><td><b>([^<]*)<\/b><\/td><\/tr><tr><td>County:<\/td><td><b>([^<]*)<\/b><\/td>/) {
                $initial_columns .= "$1,$2";
            }else{
                warn "Could not find first details in $file\n";
            }
        }
        case "TN" { # town
            $fh = $TN;
            if ($html_string =~ /<td>Town:<\/td><td><b>([^<]*)<\/b><\/td>/) {
                $initial_columns .= "$1";
            }else{
                warn "Could not find first details in $file\n";
            }
        }
        case "PL" { # pastoral
            $fh = $PL;
            if ($html_string =~ /<td>Run Name:<\/td><td><b>([^<]*)<\/b><\/td><\/tr><tr><td>Run Number:<\/td><td><b>([^<]*)<\/b><\/td>/) {
                $initial_columns .= "$1,$2";
            }else{
                warn "Could not find first details in $file\n";
            }
            $te = HTML::TableExtract->new( headers => ['Barcode', 'Map No', 'Sheet', 'Division', 'CD Title', 'Image ID'] );
        }
        else {
            die "Unexpected mtype '$mtype' in '$file'\n";
        }
    }

    #now look for the table with the sheet details
    $te->parse($html_string);

    foreach my $ts ($te->tables){
        foreach my $row ($ts->rows) {
            my $row_text = join(',', @$row);
            $row_text =~ s/\n//g;
            $row_text =~ s/,\s+,/,,/g; # if a column is just whitespace, reduce it to empty
            print $fh "$initial_columns,$row_text\n";
        }
    }
    close $HTML;
}

close $CY;
close $ML;
close $PH;
close $TN;
close $PL;

