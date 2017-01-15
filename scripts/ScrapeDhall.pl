#!/usr/bin/perl

# NOTE: CHECK FOR DEBUG OTHERWISE, THE VARIABLES ARE HARDCODED
my $debug = 1;

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

#NOTE: HARDCODED FOR PURPOSE OF TESTING
$cycle = 2 if $debug;
$curr_day = 5 if $debug; # THURSDAY

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
        print "         LUNCH\n";
    } else {
        print "         DINNER\n";
    }

    # print $file if $debug;
    if($file =~ /(Emily's\ Entrée's(\s*)(.*))(THE\ DINER)/s) {
        
        print "\n========================\n";
        print "      Emily's Garden\n";
        print "========================\n\n";
        my $emily = &output(split(/\n/m, $3));
        print $emily;
    }
    if($file =~ /(THE\ DINER(\s*)(.*))(PASTA)/s) {
        print "\n========================\n";
        print "        The Diner\n";
        print "========================\n\n";
        my $diner = &outputDiner(split(/\n/m, $3));
        print $diner;
    }
    if($file =~ /(PASTA(\s*)(.*))(GLOBAL)/s) {
        print "\n========================\n";
        print "        Semolina's\n";
        print "========================\n";
        my $pasta = &output(split(/\n/m, $3));
        print $pasta;
    }
    if($file =~ /(GLOBAL(\s*)(.*))/s) {
        print "\n========================\n";
        print "        Global Cafe\n";
        print "========================\n\n";
        my $global = &output(split(/\n/m, $3));
        print $global;
    }
    print "\n~~~~~~~~~~~~~~~~~~~~~~~\n";
}

sub output {
        my @arr = @_;
        #print scalar @arr . "\n" if $debug; # Gives the number of items in the arrays given

        my $count = 0;
        my $output;
        foreach my $s(@_) {
            $count = $count + 1;
            #print "Count: $count.\n" if $debug;
            chomp $s;

            my @select_day = split (/\s{2,34}/s, $s);

            if($count > 1) {
                #print $select_day[$curr_day + 1] . "\n" unless $select_day[$curr_day + 1] =~ m/^\s*$/;
                $output = $output . "\n" . $select_day[$curr_day + 1] unless $select_day[$curr_day + 1] =~ m/^\s*$/;
            } else {
                #print $select_day[$curr_day] . "\n" unless $select_day[$curr_day] =~ m/^\s*$/;
                $output = $output . "\n" . $select_day[$curr_day] unless $select_day[$curr_day] =~ m/^\s*$/;
            }
        }
        return $output;
}

# Specific parsing for diner due to it having extra information
sub outputDiner {
        my @arr = @_;
        #print scalar @arr . "\n" if $debug; # Gives the number of items in the arrays given

        my $count = 0;
        my $output;
        foreach my $s(@_) {
            $count = $count + 1;
            #print "Count: $count.\n" if $debug;
            chomp $s;

            my @select_day = split (/\s{2,34}/s, $s);

            # the following lines prints out what is in the array for each day
#            print "Item:\n";
#            foreach my $item(@select_day) {
#                print $item . "\n"
#            }
#            print "Done\n";
            #print "First Column: $select_day[0]" . "\n";

            # Distinguishing between lines with "Entree" or "Signature Veggies" as the start instead of the actual dish
            if($select_day[0] =~ "Entree #.") {
                #print $select_day[$curr_day + 1] . "\n" unless $select_day[$curr_day + 1] =~ m/^\s*$/;
                $output = $output . "\n" . $select_day[$curr_day + 1] unless $select_day[$curr_day + 1] =~ m/^\s*$/;
            } elsif ($select_day[1] =~ "Entree #." || $select_day[1] =~ "Signature Veggies") {
                #print $select_day[$curr_day + 2] . "\n" unless $select_day[$curr_day + 2] =~ m/^\s*$/;
                $output = $output . "\n" . $select_day[$curr_day + 2] unless $select_day[$curr_day + 2] =~ m/^\s*$/;
            } else {
                #print $select_day[$curr_day + 1] . "\n" unless $select_day[$curr_day + 1] =~ m/^\s*$/;
                $output = $output . "\n" . $select_day[$curr_day + 1] unless $select_day[$curr_day + 1] =~ m/^\s*$/;
            }
        }
        return $output;
}