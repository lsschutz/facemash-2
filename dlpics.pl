#!/usr/bin/perl
# dlpics.pl
#use strict; 
#use warnings;

my $URL='http://ails.arc.nasa.gov/ails/?jp=ssp&ti=NASA%20Ames%202013%20Summer%20Intern%20Portraits&1=1&so=cdate&v=thumbs&&o=0&h=1page=1';
my $THUMBS = 'thumbs';
my $HIGHRES = 'highres';

# clean up working directory
`rm *.jpg`;
`rm -rf $THUMBS $HIGHRES`;

# get the page
print "fetching page...\n";
my $page=`curl $URL > /dev/null 2>&1`;

print "### Get the thumbnails ###\n";
unless ( -d $THUMBS) {

  `mkdir $THUMBS`;

  while ($page =~ /<img src=([^\s]*)/g) {
    # get the http urls only
    if( substr($1, 1, 4) eq 'http' ) {
      print "downloading $1\n";
      `wget $1 > /dev/null 2>&1`;
    }
  }
  `mv *.jpg thumbs`;
}

print "### Get the highres ###\n";
unless ( -d $HIGHRES) {

  `mkdir $HIGHRES`;

  ### Get the highres ###
  while ($page =~ /<a href="JustInPreview[.]php[?]fname=([^>]*)/g) {
    print "downloading $1\n";
    `wget \"$1 > /dev/null 2>&1`;
  }
  `mv *.jpg highres`;
}
