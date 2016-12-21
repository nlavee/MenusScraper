#!/usr/bin/perl

use strict;

print "\n===============================================================================\n";
print "\nHello there, seems like you want to know what's available in Dhall Today.\n";
print "\n===============================================================================\n";

my $debug = 1;

my @array = `ls resources/*.txt`;
my %hash;
foreach my $element(@array) {
    print $element if $debug;
    chomp($element);

    open($STDIN, "<", $element) or die("Error opening file $element. Please double-check.\n");
    local $/;
    while(my $line = <$STDIN>) {
        # Go through line by line
        # print $line if $debug; 
        &matches($line);
    }

    # print "\n===============================================================================\n";
    # print "\nEND ONE FILE\n";
    # print "\n===============================================================================\n";

    close $STDIN;
}

sub matches {
    my ($file) = @_;
    my $Emily;
    my $Diner;
    my $Pasta;
    my $Global;

    # print $file if $debug;
    if($file =~ /(Emily's\ Entr(.*))(THE\ DINER)/s) {
        # print $1 . "\n" if $debug;
        $Emily = $1;
    }
    if($file =~ /(THE\ DINER(.*))(PASTA)/s) {
        # print $1 . "\n" if $debug;
        $Diner = $1;
    }
    if($file =~ /(PASTA(.*))(GLOBAL)/s) {
        # print $1 . "\n" if $debug;
        $Pasta = $1;
    }
    if($file =~ /(GLOBAL(.*))/s) {
        # print $1 . "\n" if $debug;
        $Global = $1;
    }

    &matchesEmily($Emily);

}

sub matchesEmily {
    my ($Emily) = @_;
    while(1) {
        if($Emily =~ /()/) {
            print $1 . "\n";
            $Emily = $';
        }  
	last;
    }
}
