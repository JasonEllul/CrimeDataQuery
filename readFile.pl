#!/usr/bin/perl


use warnings;
use Class::Struct;
use version;   our $VERSION = qv('5.16.0');   # This is the version of Perl to be used
use Text::CSV  1.32;
use Switch;




my $EMPTY = q{};
my $SPACE = q{ };
my $COMMA = q{,};

my $csv          = Text::CSV->new({ sep_char => $COMMA });

# this file will take in data from stats canada that is sorted based on year->location->crime;
my $YLC_file = $EMPTY;
my $YLC_URL;
my @YLC;

my $questionFileCount = 0;

my $count = 0;

# Location
my @location;       # @location[count]               Locations stored as l++; starting from 0

my $location_cur;
my $location_temp;
my $xType;
my $yType;

# Crime
my @crime;          # @crime[count]           Crimes stored as c++; starting from 0

my $crime_cur;
my $crime_temp;

# Years
my @year;           # @year[count][yearcount]      Years stored as y++; starting from 0
my $year2 = 2015;
my $year1 = 1998;

my @dataArray;           # @Data[location#][crime][year]=;
my $l = 0;
my $c = 0;
my $y = 0;

my $g = 0;

my $type;           # the type of data, verifying only for "Actual incidents"

my $newlinecheck = 0;

my $file2 = 'question.csv';
    


my $fileName = 'alldata.csv';



my @questYear;
my @questCrime;
my @questLocation;
my $questType;
# Load the file


open my $YLC_fh, '<', $fileName
or die "Unable to open file $fileName\n";

@YLC = <$YLC_fh>;

close $YLC_fh or
die "Unable to close file $fileName\n";   # Close the input file

open(my $secfh, "<", $file2)
or die "Could not open file '$file2'$!";
@question = <$secfh>;

close $secfh or
die "Unable to close file $file2\n";

# set starting values
$count = 1;

$location_cur = "NA";
$crime_cur = "NA";

$questionFileCount = 0;

$g = 0;
foreach my $record ( @question ) {
    if ( $csv->parse($record) ) {
        my @master_fields = $csv->fields();
        
        
        if($questionFileCount == 1){
            
            $xType        = $master_fields[4];
            $yType        = $master_fields[5];
            $questType    = $master_fields[6];
            
        }
        
        if($questionFileCount > 1){
            
            $questYear[$g] = $master_fields[1];
            $questLocation[$g]   = $master_fields[2];
            $questCrime [$g]    = $master_fields[3];
            
            $g++;
        }
        
        $questionFileCount++;
        
    }   else {
        warn "Line could not be parsed at: $count\n";
    }
}

switch($questType){
    
    case('T') { $questType = "Actual incidents"; }
    case('%') { $questType = "Rate per 100,000 population"; }
    case('D') { $questType = "Percentage change in rate"; }
    else      { $questType = "Actual incidents"; }
    
}

$year1 = $questYear[0];
$year2 = $questYear[$#questYear ];

my $uCheck = 0;
my $lCheck = 0;
my $cCheck = 0;
my $yCheck = 0;

my $tCheck = 0;

$location_cur = "SOMETHING THAT WONT MATCH";
foreach my $YLC_record ( @YLC ) {
    if ( $csv->parse($YLC_record) ) {
        my @master_fields = $csv->fields();
        
        
        # count up the lines
        $count++;
        
        # get the data of the new line
        $location_temp = $master_fields[1];
        $crime_temp = $master_fields[2];
        $year_temp = $master_fields[0];
        
        $type = $master_fields[3];
        
        #check
        $uCheck = 1;    # goes to 0
        
        $lCheck = 0;
        $cCheck = 0;
        
        
        my $z = 0;
        
        if($type eq $questType){
            
            
            
            for($z = 0; $z < $#questLocation; $z++){
                
                if($location_temp eq $questLocation[$z]){
                    
                    $lCheck = 1;
                    
                }
                
            }
            
            for($z = 0; $z < $#questCrime; $z++){
                
                if($crime_temp eq $questCrime[$z]){
                    
                    $cCheck = 1;
                    
                }
                
            }
            
            #if year, type and crime are all valid then move on.
            if($cCheck == 1 && $lCheck == 1){
                
                $uCheck = 1;
                
            }
            else{
                
                $uCheck = 0;
            }
            
        }
        else{
            
            $uCheck = 0;
            
        }
        
        if($count == 2){ $year_temp = -1; }
        
        if( $year_temp <= $year2   &&  $year_temp >= $year1 && $uCheck == 1){
            
            $dataArray[$l][$c][$y] = $master_fields[6];
            print "\"".$location_temp."\",\"".$crime_temp."\",\"".$year_temp."\",\"".$dataArray[$l][$c][$y]. "\",\n";
            
        }
        
        
        
        #get the value
        
        
        
    } else {
        #warn "Line could not be parsed at: $count\n";
    }
}

#my @averagehold;
#my @average;
#my $missingChar;
#my $total = 5;

#for ($x =0; $x < $total; $x++){
#
#    if($xType eq 'C' && $xType eq 'L'){
#
#       $missingChar = 'Y';
#
#    } elsif ($xType eq 'C' && $xType eq 'Y') {
#
#        $missingChar = 'L';
#
#    } elsif ($xType eq 'Y' && $xType eq 'L'){
#
#        $missingChar = 'C';
#    }
#
#
#    # move up later
#    my $count1 = 0; #first thing
#    my $count2 = 0; #seond thing
#    my $count3 = 0; #Missing thing
    
#    my $a = 0;
#    my $b = 0;
    
#    my $q = 0;
    
    #get the count1

#    for($a = 0; $a < $count1; $a++){
        
        #get count 2 based on remaining variable left to use
#        for($b = 0; $b < $count2; $b++){
###              #YLC_>>_>>__>_
#             if($missingChar eq 'L'){
#
#                   #   $dataArray[$a][$q][$b];
                    #TODO fix these to corrispond with the new order
                    
#               }
                
#               if($missingChar eq 'Y'){
                    
                    #            $dataArray[$q][$a][$b];
                    
#               }
                
#               if($missingChar eq 'C'){
                    
                    #$dataArray[$a][$b][$q];
                    
#               }
#           }
#       }
        
        #get average and print for temp checkiong
        
#   }#$average = $total / $#average
#}


