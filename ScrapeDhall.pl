#!/usr/bin/perl

use strict;

print "\n===============================================================================\n";
print "\nHello there, seems like you want to know what's available in Dhall Today.\n";
print "\n===============================================================================\n";

## Find the current position on the cycle
my $cal = `ls resources/academiccalendar2016.txt`;
my $pattern = "(.*)Classes Begin";

my $curr_date = `date +"%U"`;
my $cycle;
chomp $cal;

{
    open($STDIN, "<", $cal) or die ("Could not find academic calendar\n");
    local $/;

    my $line = <$STDIN>;

    for (my $i = 0; $i < 2; $i++) {
        if ($line =~ /^$pattern$/m) {
        my $date_converted = `date -d '$1' '+%U'`;

            if ($curr_date >= $date_converted){
                $cycle = ($curr_date - $date_converted) % 4;

                if($cycle == 0) {
                    $cycle = 4;
                }
                last;
            }
        }
        print "The cycle is equal to" . $cycle . "\n";
        $line = $';
    }
    close $STDIN;
}
#TODO: Add a skip for Thanksgiving and Spring Break?

`rm resources/academiccalendar2016.txt`;

my $debug = 1;

my @array = `find resources/ -regextype posix-extended -regex '(.*)(Cycle)$cycle(.*)'`;
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
