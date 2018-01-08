#!/usr/bin/perl
#
#   Packages and modules
#

use strict;
use warnings;
use Class::Struct;
use version;   our $VERSION = qv('5.16.0');   # This is the version of Perl to be used
use Text::CSV  1.32;

# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #
#
#   getYearLocationCrime.pl
#   Nicholas Florian,
#   Team Belleville,
#
#   Functional Summar:
#
#       This code will interperet a large crime stats file in order to verify when certian crimes
#       were recorded in certian locations at certian times. This will allow later code to avoid
#       getting data that does not exsist. The new order of data will be; Location, crime, years.
#
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #


#
#   Variables
#

my $EMPTY = q{};
my $SPACE = q{ };
my $COMMA = q{,};

my $csv          = Text::CSV->new({ sep_char => $COMMA });

# this file will take in data from stats canada that is sorted based on year->location->crime;
my $YLC_file = $EMPTY;
my $YLC_URL;
my @YLC;

my $count;

# Location
my @location;       # @location[location]               Locations stored as l++; starting from 0
my $location_count; #                                   Final value of l (# of locations -1)

my $location_cur;   #                                   Store the current location that is being sorted through
my $location_temp;

# Crime
my @crime;          # @crime[location][crime]           Crimes stored as c++; starting from 0
my @crime_count;    # @crime[location][count]           Final value of c (# of crimes -1)

my $crime_cur;      #                                   Store the current crime that is being sorted through
my $crime_temp;

# Years
my @year;           # @year[location][crime][year]      Years stored as y++; starting from 0
my @year_count;     # @year[location][crime][count]     Final value of y (# of years -1)


my $type;           # the type of data, verifying only for "Actual incidents"

my $newlinecheck = 0;
#
#   Code
#


# load the file
if ($#ARGV !=1 ) {
    
    print "Usage: verifyData.pl <refrence file> -> <output file>\n" or
    die "Print failure\n";
    exit;
    
} else {
    
    $YLC_URL = $ARGV[0];
    
}

open my $YLC_fh, '<', $YLC_URL
or die "Unable to open file $YLC_URL\n";

@YLC = <$YLC_fh>;

close $YLC_fh or
die "Unable to close file $YLC_URL\n";   # Close the input file


# set starting values
$count = 1;

$location_cur = "NA";   #
$crime_cur = "NA";      # NA is a temp value which will never match with anything

$location_count = -1;


# as the data is processed it is outputed, the data is still stored dynamically
# and could be changed if the output were to change order.

# 558691
# 609219
# these lines are still uncomissioned

foreach my $YLC_record ( @YLC ) {
    if ( $csv->parse($YLC_record) ) {
        my @master_fields = $csv->fields();
        
        
        # count up the lines
        $count++;
        
        
        # get the data of the new line
        $location_temp = $master_fields[1];
        $crime_temp = $master_fields[2];
        
        $type = $master_fields[3];
        
        # verify the location, act based on if its a new location or the current
        if( $location_cur eq $location_temp ){
        
            # agian, verify the crime, act based on if its a new crime or the current
            if( ( $crime_cur eq $crime_temp ) && ( (length $crime_cur) == (length $crime_temp) ) ) { #if they are the same then sort through the years
                
                # store the year at the current line
                if( $type eq "Actual incidents"){
                    
                    # $year[$location_count][$crime_count[$location_count]][$year_count[$location_count][$crime_count[$location_count]]] = $master_fields[0];
                    
                    $year_count[$location_count][$crime_count[$location_count]]++;
                    
                    #print rest of years
                    print $master_fields[0]."," or die;
                }
                
            }
            else { # if they are not the same then start a new crime
                
                $crime_cur = $crime_temp;                               # update the new current crime
                
                $crime_count[$location_count]++;                        # update the amount of crimes
                $crime[$location_count][$crime_count[$location_count]] = $crime_temp;    # record the crime to the array.
                
                # record first
                $year_count[$location_count][$crime_count[$location_count]] = 0;
                
                # this is line works like using the power of 3 if that makes any sense. All data is a sub set of the other.
                $year[$location_count][$crime_count[$location_count]][$year_count[$location_count][$crime_count[$location_count]]] = $master_fields[0];
                $year_count[$location_count][$crime_count[$location_count]]++;
                
                
                print "\n" or die;
                
                # print out location, crime, then the years that is has data for.
                print "\"".$location_cur."\",\"".$crime_cur."\", ".$master_fields[0].", ";
                $newlinecheck = 0;
                
            }
            
        }
        else {  # if they are not the same then start a new location
            
            $location_cur = $location_temp;                 # update the new current location
            
            $location_count++;                              # update the amount of locations
            $location[$location_count] = $location_temp;    # record the location to the array
            
            $crime_cur = $crime_temp;
            
            # record first
            $crime_count[$location_count] = 0;
            
            $crime[$location_count][$crime_count[$location_count]] = $crime_temp;
            $crime_count[$location_count]++;
            
        }
        
    } else {
        #warn "Line could not be parsed at: $count\n";
    }
}




#
#   End of Script
#
