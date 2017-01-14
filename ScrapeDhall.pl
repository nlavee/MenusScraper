#!/usr/bin/perl

use strict;

print "\n===============================================================================\n";
print "\nHello there, seems like you want to know what's available in Dhall Today.\n";
print "\n===============================================================================\n";

## Find the current position on the cycle

my $cycle;

{
    my $cal = `ls resources/academiccalendar20*.txt`; # Can be any year in the format of 20**
    chomp $cal;

    my $pattern = "(.*)Classes Begin";
    my $curr_date = `date +"%U"`; # this gives the week of the year

    open($STDIN, "<", $cal) or die ("Could not find academic calendar\n");
    local $/;

    my $line = <$STDIN>;

    # Searching within the first two instances of "Classes Begin" (Fall & Spring)
    for (my $i = 0; $i < 2; $i++) {
        if ($line =~ /^$pattern$/m) {
            my $date_truncate = join ( ' ', split (/\s+/, $1) );
            my $date_converted = `date -d '$date_truncate' '+%U'`; # Getting the week from date truncate

            # Calculating cycle according to how many weeks have passed mod 4
            # There are only 4 cycles
            if ($curr_date >= $date_converted){
                $cycle = ($curr_date - $date_converted) % 4;

                if($cycle == 0) {
                    $cycle = 4;
                }
                last;
            }
        }
        $line = $';
    }
    close $STDIN;
}

# Need to double check cycle
print "You are currently at cycle: $cycle.\n";

my $curr_day = -7 + (`date +"%w"`+ 1);
if ($curr_day == 7) {
    $curr_day = -7;
}
#TODO: Add a skip for Thanksgiving and Spring Break?

## Parsing the menu according to cycle
my $debug = 1;
$cycle = 1 if $debug;

my @array = `find resources/ -regextype posix-extended -regex '(.*)(Cycle)$cycle(.*)'`;
my %hash;
foreach my $element(reverse (@array)) {
    chomp($element);

    open($STDIN, "<", $element) or die("Error opening file $element. Please double-check.\n");
    local $/;
    while(my $line = <$STDIN>) {
            &matches($line);
    }
    close $STDIN;
}

sub matches {
    my ($file) = @_;

    if ($file =~ /LUNCH/) {
        print "         Lunch\n";
    } else {
        print "         Dinner\n";
    }

    # print $file if $debug;
    if($file =~ /(Emily's\ Entrée's(\s*)(.*))(THE\ DINER)/s) {
        
        print "\n========================\n";
        print "      Emily's Garden\n";
        print "========================\n\n";
        &output(split(/\n/m, $3));
    }
    if($file =~ /(THE\ DINER(\s*)(.*))(PASTA)/s) {
        print "\n========================\n";
        print "        The Diner\n";
        print "========================\n\n";
        &output(split(/\n/m, $3));
    }
    if($file =~ /(PASTA(\s*)(.*))(GLOBAL)/s) {
        print "\n========================\n";
        print "        Semolina's\n";
        print "========================\n";
        &output(split(/\n/m, $3));
    }
    if($file =~ /(GLOBAL(\s*)(.*))/s) {
        print "\n========================\n";
        print "        Global Cafe\n";
        print "========================\n\n";
        &output(split(/\n/m, $3));
    }
    print "\n~~~~~~~~~~~~~~~~~~~~~~~\n";
}

sub output {
        foreach my $s(@_) {
            chomp $s;

            my @select_day = split (/\s{2,34}/s, $s);
            print $select_day[$curr_day] . "\n" unless $select_day[$curr_day] =~ m/^\s*$/m;
    }
}