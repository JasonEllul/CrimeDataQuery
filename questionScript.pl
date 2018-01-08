#!/usr/bin/perl
#
#   Packages and modules

#QUESTION SCRIPT BY JASON ELLUL AND NICK FLORIAN
#
use strict;
use warnings;
use version;   our $VERSION = qv('5.16.0');   # This is the version of Perl to be used
use Text::CSV  1.32;   # We will be using the CSV module (version 1.32 or higher)
use Path::Class;
use Switch;

use Path::Class;

#file stuff from Nicks file
my $EMPTY = q{};
my $SPACE = q{ };
my $COMMA = q{,};

my $csv          = Text::CSV->new({ sep_char => $COMMA });

my $YLC_file = $EMPTY;
my $YLC_URL;
my @YLC;

my $count;

my $quit = 0;
my $questionValid = 0;
my $valid = 0;
my $input;
my $input2;
my $input3;
my $input4;
my $part1;
my $part2;
my $part3;
my $part4;
my $record_count;
my $filename = "out.csv";

my @records;
my @crime;
my @loc;

my @locationU;
my @crimeU;

my $LUCount = 0;
my $CUCount = 0; #use for multiple stuff late -nick

my $LUFirst = 0; #check to make sure they dont type stop on their first attempt
my $CUFirst = 0;

my $LUCheck = 0; #check to make sure they dont type stop on their first attempt
my $CUCheck = 0;

my $yearMax = 0;
my $yearMin = 1998;

my $crimeOption;
my $crimeField;


my $locationOption;
my $locationField;

my $year;
my $year1 = 1998;
my $year2 = 2015; # TODO make dynamic - nick
my $yearOption;
my $temp;

my $statisticOption;
my $statisticString;
my $questionOption;

my $xOption;
my $yOption;
my$maxMinOption;

my @line;
my $o = 0;
my $p = 0;

my $outfile = 'question.csv';


#
# compare variables
#

# this file will take in (P)rocessed (D)ata from stats canada
my $PD_file = $EMPTY;
my $PD_URL = "out.csv";
my @PD;
my $line_count=  0;

my $i = 0;
my $j = 0; # this value works in the do while to get the years

my $flagF = 0;
my $checkF = 1;

my $f = 0;  # go through lines of the file
my $u = 0;  # go through user years
my $y = 0;  # go through years in the file

my @locationF;
my @crimeF;
my @yearsF;

my @yearsU;

my @years;
my $years_count = 0;

if ($#ARGV !=0 ) {
    
    print "Usage: questionScript.pl <refrence file> \n" or
    die "Print failure\n";
    exit;
    
} else {
    
    $PD_URL = $ARGV[0];
    
}

#
#   Open the input file and load the contents into records array
#

# Jasons read

open my $script1_fh, '<', $PD_URL
or die "Unable to open file: out.csv\n";

@records = <$script1_fh>;

close $script1_fh or
die "Unable to close: out.csv\n";

foreach my $name_record ( @records ) {
    if ( $csv->parse($name_record) ) {
        my @master_fields = $csv->fields();
        $record_count++;
        $loc[$record_count] = $master_fields[0];
        $crime[$record_count]     = $master_fields[1];

        $i = 0; #location in array
        $j = 0;
        
        #get max year
        do{
            
            $yearMax = $master_fields[$j];
            
            $i++;
            $j++;
            
        }while($master_fields[$j] ne "");
        
    } else {
        warn "Line/record could not be parsed: $records[$record_count]\n";
    }
}


do {
    do {
        
        system("clear");
        #CRIME
        do {
            print "Please select how many crimes you would like to consider.\n";
            print "1. Every Crime\n";
            print "2. Only...\n";
            
            chomp ($input = <STDIN>);
            
        } while ($input !~ /^[1-2]$/);
        $crimeOption = $input;
        #all crimes except... AND only this crime
        if($crimeOption == 1){
            
            # defualt value
            $crimeU[0] = "Total, all violations";
            
        }
        
        if ($crimeOption == 2){
            
            do{ # until their done entering
                
                $valid = 0;
                if($crimeOption == 2){
                    print "Please type the crime you would like to use (Type \"S\" to stop):\n";
                }
                
                chomp ($input = <STDIN>);
                
                for my $i ( 1..$record_count) {
                    if ($input eq $crime[$i] && $input ne "Total, all Criminal Code violations (excluding traffic)" && $input ne "Total, all Criminal Code violations (including traffic)") {
                        $valid = 1;
                        $CUFirst = 1; #they entered 1 so they can stop now
                        
                    }
                    
                }
                
                
                
                if($input eq "S"){
                    
                    if($CUFirst == 0){
                        
                        print "ERROR: You must enter one crime.\n";
                        
                    }
                    else{
                        
                        $CUCheck = 1;
                        
                    }
                    
                }
                
                
                # record it
                if($valid == 1){
                    
                    $crimeField = $input;
                    $crimeU[$CUCount] = $input;
                    $CUCount++;
                    
                }
                elsif($input ne "S"){
                    
                    printf("WARNING: invalid crime.\n");
                    
                }
                
            } while( $CUCheck == 0 )
                
                
                }
        
        system("clear");
        
        $valid = 0;
        #LOCATION
        do {
            
            print "Please select how many locations you would like to consider.\n";
            print "1. Every Location in Canada\n";
            print "2. Only...\n";
            
            chomp ($input = <STDIN>);
            
        } while ($input !~ /^[1-2]$/);
        $locationOption = $input;
        if($locationOption == 1){
            
            # defualt value
            $locationU[0] = "Canada";
            
        }
        
        #Selected locations
        if ($locationOption == 2){
            
            do{ # until their done entering
                
                $valid = 0;
                
                print "Please type the location you would like to use (Type \"S\" to Stop):\n";
                
                chomp ($input = <STDIN>);
                
                for my $i ( 1..$record_count) {
                    if ($input eq $loc[$i] && $input ne "Canada") {
                        
                        $valid = 1;
                        $LUFirst = 1; # they entered one now so they can STOP
                        
                    }
                }
                
                if($input eq "S"){
                    
                    if($LUFirst == 0){
                        
                        print "You must enter one location.\n";
                        
                    }
                    else{
                        
                        $LUCheck = 1;
                        
                    }
                    
                }
                
                if($valid == 1){
                    
                    $locationField = $input;
                    $locationU[$LUCount] = $input;
                    $LUCount++;
                    
                }
                elsif($input ne "S"){
                    
                    printf("WARNING: invalid location.\n");
                    
                }
                
                
            }while( $LUCheck == 0 );
            
        }
        
        system("clear");
        
        $valid = 0;
        #YEARs
        do {
            
            print "Please select the year range you would like to use.\n";
            print "1. Every Year\n";
            print "2. Specific Year...\n";
            print "3. Range of Years...\n";
            print "4. Two different years...\n";
            
            chomp ($input = <STDIN>);
            
        } while ($input !~ /^[1-4]$/);
        $yearOption = $input;
        
        #all years
        if ($yearOption == 1){
            
            $year = $input;
            $year1 = $yearMin;
            $year2 = $yearMax;
            
            $years_count = 0;
            
        }
        
        #only specific year
        if ($yearOption == 2){
            do {
                
                print "Please type the year you would like to use. (".$yearMin."-".$yearMax.")\n";
                
                
                chomp ($input = <STDIN>);
                #check if its alphabetical
                if ($input =~ /^[a-zA-Z]+$/){
                    $input = 0;
                }
                
            } while (!(($input >= $yearMin) && ($input <= $yearMax)));
            
            $year = $input;
            $year1 = $input;
            $year2 = $input;
            
            $years_count = 1;
            
        }
        
        #RANGE of years
        if ($yearOption == 3){
            
            
            print "Please type the range of years you would like to use.\n";
            
            do {
                print "First year in the range: (".$yearMin."-".$yearMax.")\n";
                chomp ($input = <STDIN>);
                #check if its alphabetical
                if ($input =~ /^[a-zA-Z]+$/){
                    $input = 0;
                }
                
            } while (!(($input >= $yearMin) && ($input <= $yearMax)));
            
            $year1 = $input;
            do {
                print "Second year in the range: (".$yearMin."-".$yearMax.")\n";
                chomp ($input = <STDIN>);
                #check if its alphabetical
                if ($input =~ /^[a-zA-Z]+$/){
                    $input = 0;
                }
                
            } while (!(($input >= $yearMin) && ($input <= $yearMax)));
            
            $year2 = $input;
            if ($year1 > $year2){
                $temp = $year1;
                $year1 = $year2;
                $year2 = $temp;
            }
            
            $years_count = 0;
            
        }
        #TWO DIFFERNT of years
        if ($yearOption == 4){
            
            
            print "Please type the two years you would like to use (".$yearMin."-".$yearMax."):\n";
            
            do {
                print "First year: ";
                chomp ($input = <STDIN>);
                #check if its alphabetical
                if ($input =~ /^[a-zA-Z]+$/){
                    $input = 0;
                }
                
            } while (!(($input >= $yearMin) && ($input <= $yearMax)));
            
            $yearsU[0] = $input;
            
            do {
                print "Second year: ";
                chomp ($input = <STDIN>);
                #check if its alphabetical
                if ($input =~ /^[a-zA-Z]+$/){
                    $input = 0;
                }
                
            } while (!(($input >= $yearMin) && ($input <= $yearMax)));
            
            $yearsU[1]= $input;
            
            $years_count = 2;
            
        }

        system("clear");
        
        #STAT
        do {
            
            print "Please select the statistic you would like to use in your question.\n";
            print "1. Actual incidents\n";
            print "2. Rate per 100,000 population\n";
            print "3. Percentage change in rate\n";
            
            chomp ($input = <STDIN>);
            
        } while ($input !~ /^[1-3]$/);
        $statisticOption = $input;
        if ($statisticOption == 1){
            $statisticString = "Actual incidents";
        }
        if ($statisticOption == 2){
            $statisticString = "Rate per 100,000 population";
        }
        if ($statisticOption == 3){
            $statisticString = "Percentage change in rate";
        }
        
        system("clear");
        
        #COMPARE X
        do {
            
            #print "How would you like to compare X ways?\n";
            #    print "1. Crime\n";
            #    print "2. Location\n";
            #    print "3. Years\n";
            
            #    chomp ($input = <STDIN>);
            #
            # } while ($input !~ /^[1-3]$/);
        # $xOption = $input;
        
        #COMPARE Y
        #system("clear");
        
        
        
        # do {
            
            #    print "How would you like to compare Y ways? (Cannot choose the same as X)\n";
        #   print "1. Crime\n";
            #    print "2. Location\n";
            #    print "3. Years\n";
            
            #    chomp ($input = <STDIN>);
            
            #} while ($input !~ /^[1-3]$/ || $input == $xOption);
        #$yOption = $input;
        
        #MAX OR MIN - ONLY IF THERES A RANGE
        #system("clear");
        
        #do {
            
        #   print "Do you want a max or min value?\n";
        #    print "1. Maximum value\n";
        #    print "2. Minimum value\n";
            
        #    chomp ($input = <STDIN>);
            
        #} while ($input !~ /^[1-2]$/);
        #$maxMinOption = $input;
        
        
        
        #AFTER GETTING FIELDS
        #crimeOption = 1 every crime
        #crimeOption = 2 all crimes except - $crimeField
        #crimeOption = 3 only a specific crime - $crimeField
        
        #locationOption = 1 every location (canada)
        #locationOption = 2 all location except - $locationField
        #locationOption = 3 one specific location - $locationField
        
        #yearOption = 1 Every year
        #yearOption = 2 specific year - $year
        #yearOption = 3 range of years - $year1 is the first year $year2 is the second year
        #yearOption = 4 two different years - $year1 is first $year2 is second year
        
        #statisticOption = 1 actual incidents
        #statisticOption = 2 rate per 100,000 population
        #statisticoption = 3 percentage change in rate
        
        
        #specific crime location and year
        if ($crimeOption == 3 && $locationOption == 3 && $yearOption == 2 ){
            
            printf ("What is the $statisticString for $crimeField in $year in $locationField?\n?");
            
            
            
        }
        # every crime, every location, every year,
       
        $questionValid = 1;
        
    } while ($questionValid == 0);
    $questionValid = 0;
    
    #temp
    $quit = 1;
} while ($quit == 0);

#
#
#

open my $PD_fh, '<', $PD_URL
or die "Unable to open file $PD_URL\n";

@PD = <$PD_fh>;

close $PD_fh or
die "Unable to close file $PD_URL\n";

foreach my $PD_record ( @PD ) {
    if ( $csv->parse($PD_record) ) {
        
        
        my @master_fields = $csv->fields();
        
        $line_count++;
        
        # get the first two columns
        
        #$temp_string = $master_fields[0];
        $locationF[$line_count - 1] = $master_fields[0];
        
        $crimeF[$line_count - 1]    = $master_fields[1];
        
        $i = 0; #location in array
        $j = 2;
        
        do{
            
            $yearsF[$line_count - 1][$i] = $master_fields[$j];
            
            $i++;
            $j++;
            
        }while($master_fields[$j] ne "");
        
        # print "end found for line ".$line_count." after year # ".($j - 2)."\n";
        
    } else {
        warn "Line could not be parsed at: $line_count\n";
    }
}



#
# Nicks code
#

# convert the year range to an array of year
$i= 0;

for($i = 0; ($year1 + $i) <= $year2; $i++){
    
    $yearsU[$i] = ($year1 + $i);
    $years_count++;
    
}

$i = 0;
$j = 0;

# every user location
for($i = 0; $i < $#locationU + 1; $i++){
    
    $j = 0;
    for($j = 0; $j < $#crimeU + 1; $j++){
        
        # pass through every combination the user can create between locations and crimes
        
        $f = 0;
        $flagF = 0; #
        
        for($f = 0; $f < $line_count; $f++){
            
            # make sure the combination exsists
            
            if(($locationU[$i] eq $locationF[$f]) && ($crimeU[$j] eq $crimeF[$f])){
                
                # check the years next
                
                $u = 0;
                for($u = 0; $u < $years_count; $u++){
                    
                    
                    $flagF = 0;
                    $y = 0;
                    
                    for($y = 0; $y < 18; $y++){
                        
                        # only if its not null
                        if($yearsF[$f][$y]){
                        
                            if($yearsF[$f][$y] == $yearsU[$u] && $yearsF[$f][$y]){
                            
                                #then it exsists
                                $flagF = 1;
                             
                            }
                            
                        
                        }
                    
                    }
                    
                    # if checking a perticular year finds no flag then it failed
                    if( $flagF == 0) {
                        
                        $checkF = 0;
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
}

if($checkF != 0){
    
    print "Creating table...";

unlink $outfile; #remove the last file
open(FILE, ">> $outfile") or die "problem opening $outfile";

#header line,
$line[$p] = "QUESTION, YEARS, LOCATION, CRIMES, X, Y, TYPE, MAXMIN, GRAPH\n";
$p++;

#first line

#Question
$line[$p] = "Q,";

#Years
switch($yearOption){
    
    case(1) { $line[$p] = $line[$p]."A,"; }
    case(2) { $line[$p] = $line[$p]."O,"; }
    case(3) { $line[$p] = $line[$p]."O,"; }
    case(4) { $line[$p] = $line[$p]."O,"; }
    
}

#Location

switch($locationOption){
    
    case(1) { $line[$p] = $line[$p]."A,"; }
    case(2) { $line[$p] = $line[$p]."O,"; }
    
}

#Crimes

switch($crimeOption){
    
    case(1) { $line[$p] = $line[$p]."A,"; }
    case(2) { $line[$p] = $line[$p]."O,"; }
    
}

#X

switch($xOption){
    
    case(1) { $line[$p] = $line[$p]."C,"; }
    case(2) { $line[$p] = $line[$p]."L,"; }
    case(3) { $line[$p] = $line[$p]."Y,"; }
    
}

#Y

switch($yOption){
    
    case(1) { $line[$p] = $line[$p]."C,"; }
    case(2) { $line[$p] = $line[$p]."L,"; }
    case(3) { $line[$p] = $line[$p]."Y,"; }
    
}

#TYPE

switch($yOption){
    
    case(1) { $line[$p] = $line[$p]."T,"; }
    case(2) { $line[$p] = $line[$p]."%,"; }
    case(3) { $line[$p] = $line[$p]."D,"; }
    
}

#MAXMIN
switch($yOption){
    
    case(1) { $line[$p] = $line[$p]."+,"; }
    case(2) { $line[$p] = $line[$p]."-,"; }
    
}

#GRAPH
switch(1){
    
    case(1) { $line[$p] = $line[$p]."NA,"; }

}

$line[$p] = $line[$p]."\n";
$p++;

#Years, Locations, Crimes.
my $largestOne = 0;

#round robin
$largestOne = $#yearsU;
if($largestOne < $#locationU){
    $largestOne = $#yearsU;
}
if($largestOne < $#crimeU){
    $largestOne = $#crimeU;
}

for($o = 0; $o <= $largestOne; $o++){
    
    $line[$p] = ",";
    
    if($yearsU[$o]){
        
        $line[$p] = $line[$p].$yearsU[$o].",";
        
    }
    else{
        
        $line[$p] = $line[$p].",";
        
    }
    
    if($locationU[$o]){
        
        $line[$p] = $line[$p]."\"".$locationU[$o]."\",";
        
    }
    else{
        
        $line[$p] = $line[$p].",";
        
    }
    
    if($crimeU[$o]){
        
        $line[$p] = $line[$p]."\"".$crimeU[$o]."\",";
        
    }
    else{
        
        $line[$p] = $line[$p].",";
        
    }
    
    
    $line[$p] = $line[$p]."\n";
    $p++;
}


$o = 0;

for($o = 0; $o < $p; $o++){

    print FILE $line[$o];

}

}else{
    
    print "WARNING: DATA REQUIRED NOT FOUND!\n";
    
}

if($checkF != 0){
    
    print "GETTING ANSWERS\n";
    system("/usr/bin/perl readFile.pl -> answer.csv");
}
}
