#!/usr/bin/perl
use strict;
use warnings;

# Define characters and abbreviations
my %characters = ("Jonah", "j",
		  "Dani", "d",
		  "???", "unk",
		  "Ange", "a",
		  "Silas", "s",
		  "Mindy", "m",
		  "Liz", "l");

# Open file to read
my $file_name = $ARGV[0];
open my $in_file, '<:encoding(UTF-8)', $file_name or die "Cannot open $file_name\n";

# Open file to write
$file_name =~ s/^(.*)(\-\d.*\..*)$/$1_ren$2/;
open my $out_file, '>', $file_name or die "Cannot write $file_name\n";
binmode($out_file);

while (my $line = <$in_file>) {
    # Chomp
    $line =~ s/\r?\n$//;
    
    # Get rid of left/right quotes
    $line =~ s/[\x{201C}\x{201D}]/"/g;
    #Get rid of left/right single quotes
    $line =~ s/[\x{2018}\x{2019}]/'/g;
    # Get rid of ellipse single character
    $line =~ s/\x{2026}/.../g;
    # Get rid of em-dashes
    $line =~ s/\x{2014}/-/g;

    # Do nothing if header, author comment, hyphen, quote, or blank line
    if (($line =~ m/^[#*"-]/) or ($line =~ m/^\s*$/)) {
	;
    } elsif ($line =~ m/^([\w?]+):\s?(.*)$/) {
	# Replace character with abbreviation
	if ($1 ~~ %characters) {
	    $line = "$characters{$1} $2";
	}
    } elsif ($line =~ m/^(.*?)\s*$/) {
	# Quote narration
        $line = "\"$1\"";
    }
    
    # Write line
    $line = $line . "\n";
    print $out_file $line;
}

# Close files
close $out_file;
close $in_file;
print "Finished\n";
