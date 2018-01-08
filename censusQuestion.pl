#!/usr/bin/perl

#CENSUS SCRIPT BY EVERET GARRISON

use strict;
use warnings;
use version;   our $VERSION = qv('5.16.0');
use Text::CSV  1.32;
use Path::Class;
use Switch;

use Path::Class;

# Census Data from:
# Statistics Canada. 2012. Census Profile. 2011 Census.
# Statistics Canada Catalogue no. 98-316-XWE. Ottawa. Released May 21 2014.
# http://www12.statcan.gc.ca/census-recensement/2011/dp-pd/prof/index.cfm?Lang=E

my $EMPTY = q{};
my $SPACE = q{ };
my $COMMA = q{,};


my @file_big;
my @file_small;

my @geo_code;
my @prov_name;
my @cmaca_name;
my @topic;
my @characteristics;
my @total;
my @flag_total;
my @male;
my @flag_male;
my @female;
my @flag_female;

my $ageSubset1Input = 0;
my $ageSubset2Input = 0;
my $ageSubset3Input = 0;
my $ageSubset4Input = 0;
my $record_count    = 0;
my $bigRecord       = 0;
my $cityInput       = 0;
my $filenameCensusSmall = "censusSmallScale.csv";
my $filenameCensusLarge = "censusLargeScale.csv";
my $provinceInput   = 0;
my $scaleInput      = 0;
my $setInput        = 0;
my $smallRecord     = 0;
my $subset1Input    = 0;
my $subset2Input    = 0;
my $subset3Input    = 0;
my $needBigScale    = 0;
my $needSmallScale  = 0;

my $lineNeeded      = 1;

my $csv                 = Text::CSV->new({ sep_char => $COMMA });

do{
   
   print "I would like to look at the 2011 Census Data for..\n";
   print "1. All of Canada\n";
   print "2. A Province/Territory\n";
   print "3. A City/Municipality\n";
    
   chomp ($scaleInput = <STDIN>);

}while ($scaleInput !~ /^[1-3]$/);

switch ($scaleInput){
    
    case 1 {$needBigScale   = 1}
    case 2 {$needBigScale   = 1}
    case 3 {$needSmallScale = 1}

}



if($needBigScale == 1){
    
    
   open (my $big_fh, "<", $filenameCensusLarge)
   or die "Could not open file '$filenameCensusLarge'\n";
    
   @file_big = <$big_fh>;
    
   close $big_fh
   or die "Unable to close: '$filenameCensusLarge'\n";

    foreach my $record_count ( @file_big ) {
        if ( $csv->parse( $record_count) ) {
            my @master_fields = $csv->fields();
            $record_count++;
            $geo_code[$record_count] = $master_fields[0];
            $prov_name[$record_count] = $master_fields[1];
            $cmaca_name[$record_count] = $master_fields[2];
            $topic[$record_count] = $master_fields[3];
            $characteristics[$record_count] = $master_fields[4];
            $total[$record_count] = $master_fields[5];
            $flag_total[$record_count] = $master_fields[6];
            $male[$record_count] = $master_fields[7];
            $flag_male[$record_count] = $master_fields[8];
            $female[$record_count] = $master_fields[9];
            $flag_female[$record_count] = $master_fields[10];
    }
    
        else{
            
            warn "Line/record could not be parsed: $file_big[$record_count]\n";
            
        }
    
    }

}


if($needSmallScale == 1){
    
   open (my $small_fh, "<", $filenameCensusSmall)
   or die "Could not open file '$filenameCensusSmall'\n";
    
   @file_small = <$small_fh>;
    
   close $small_fh
   or die "Unable to close: '$filenameCensusSmall'\n";

    
    foreach my $record_count ( @file_small ) {
        if ( $csv->parse( $record_count ) ) {
            my @master_fields = $csv->fields();
            $record_count++;
            $geo_code[$record_count] = $master_fields[0];
            $prov_name[$record_count] = $master_fields[1];
            $cmaca_name[$record_count] = $master_fields[2];
            $topic[$record_count] = $master_fields[3];
            $characteristics[$record_count] = $master_fields[4];
            $total[$record_count] = $master_fields[5];
            $flag_total[$record_count] = $master_fields[6];
            $male[$record_count] = $master_fields[7];
            $flag_male[$record_count] = $master_fields[8];
            $female[$record_count] = $master_fields[9];
            $flag_female[$record_count] = $master_fields[10];
        }
        
        else{
            
            warn "Line/record could not be parsed: $file_small[$record_count]\n";
            
        }
        
    }

}

if($scaleInput == 2){

    do{
    
      print "Please select which Province/Territory you would like to view.\n";
      print "1. Newfoundland & Labrador\n";
      print "2. Prince Edward Island\n";
      print "3. Nova Scotia\n";
      print "4. New Brunswick\n";
      print "5. Quebec\n";
      print "6. Ontario\n";
      print "7. Manitoba\n";
      print "8. Saskatchewan\n";
      print "9. Alberta\n";
      print "10. British Columbia\n";
      print "11. Yukon\n";
      print "12. Northwest Territories\n";
      print "13. Nunavut\n";
    
      chomp ($provinceInput = <STDIN>);
    
   }while ($provinceInput < 1 && $provinceInput > 13);
    
}

if($needSmallScale == 0 && $needBigScale == 1){

   $lineNeeded += ($provinceInput * 40);

}

if($scaleInput == 3){

    do{

       print "Please enter the code of the City/Municipality you would like to view.\n(This can be found in your Manual)\n";
    
       chomp ($cityInput = <STDIN>);

    }while ($cityInput < 1 && $cityInput > 30);
 
    $cityInput--;
    
    $lineNeeded += ($cityInput * 40)
    
}

do{

   print "Please select the Data Set you would like to use.\n";
   print "1. Total Population & Dwelling Counts\n";
   print "2. Age Characteristics\n";
   print "3. Marital Status\n";
   print "4. Family Characteristics\n";
   
   chomp ($setInput = <STDIN>);
    
}while ($setInput !~ /^[1-4]$/);



if($setInput == 1){
    
   do{

      print "Which Subset would you like to view?\n";
      print "1. Population in 2011\n";
      print "2. Population in 2006\n";
      print "3. 2006 - 2011 Population Change (%)\n";
      print "4. Total Number of Private Dwellings\n";
      print "5. Number of Private Dwellings Occupied by Usual Residents\n";
      print "6. Population Density Per Square KM\n";
      print "7. Land Area of Selected Location\n";

      chomp ($subset1Input = <STDIN>);

   }while ($subset1Input !~ /^[1-7]$/);

    switch($subset1Input){
        
        case 1 {$lineNeeded += 1}
        case 2 {$lineNeeded += 2}
        case 3 {$lineNeeded += 3}
        case 4 {$lineNeeded += 4}
        case 5 {$lineNeeded += 5}
        case 6 {$lineNeeded += 6}
        case 7 {$lineNeeded += 7}
            
            }
    
    if($lineNeeded > 1 && $lineNeeded < 5){

        if($needBigScale == 0 && $needSmallScale == 1){
            print "The $characteristics[$lineNeeded] in $cmaca_name[$lineNeeded] was $total[$lineNeeded].\n";
        }
    
        elsif($needSmallScale == 1 && $needBigScale == 0){
            print "The $characteristics[$lineNeeded] in $prov_name[$lineNeeded] was $total[$lineNeeded].\n";
        }
        
     }

    elsif($lineNeeded >= 5){
        
        if($needBigScale == 0 && $needSmallScale == 1){
            print "In 2011, the $characteristics[$lineNeeded] in $cmaca_name[$lineNeeded] was $total[$lineNeeded].\n";
        }
        
        elsif($needSmallScale == 1 && $needBigScale == 0){
            print "In 2011, the $characteristics[$lineNeeded] in $prov_name[$lineNeeded] was $total[$lineNeeded].\n";
        }
        
    }
    
    
}



if($setInput == 2){
    
   do{
        
      print "Which Age Range would you like to view?\n";
      print "1. 0 to 14 years old\n";
      print "2. 15 to 24 years old\n";
      print "3. 25 to 59 years old\n";
      print "4. 60 years old and older\n";

      chomp ($subset2Input = <STDIN>);
        
   }while ($subset2Input !~ /^[1-4]$/);

    
    if($subset2Input == 1){
    
       do{

          print "Which Age Group would you like to view?\n";
          print "1. 0 to 4 years old\n";
          print "2. 5 to 9 years old\n";
          print "3. 10 to 14 years old\n";
        
          chomp ($ageSubset1Input = <STDIN>);

       }while ($ageSubset1Input !~ /^[1-3]$/);

        switch($ageSubset2Input){
            
            case 1 {$lineNeeded += 9}
            case 2 {$lineNeeded += 10}
            case 3 {$lineNeeded += 11}
        }
        
    }
        

    if($subset2Input == 2){
        
       do{
    
          print "Which Age Group would you like to view?\n";
          print "1. 15 to 19 years old\n";
          print "2. Only 15 years old\n";
          print "3. Only 16 years old\n";
          print "4. Only 17 years old\n";
          print "5. Only 18 years old\n";
          print "6. Only 19 years old\n";
          print "7. 20 to 24 years old\n";
           
          chomp ($ageSubset2Input = <STDIN>);
           
       }while ($ageSubset2Input !~ /^[1-7]$/);

        switch($ageSubset2Input){
            
            case 1 {$lineNeeded += 12}
            case 2 {$lineNeeded += 13}
            case 3 {$lineNeeded += 14}
            case 4 {$lineNeeded += 15}
            case 5 {$lineNeeded += 16}
            case 6 {$lineNeeded += 17}
            case 7 {$lineNeeded += 18}
                
        }
        
    }
    
    
    if($subset2Input == 3){
        
        do{
           
           print "Which Age Group would you like to view?\n";
           print "1. 25 to 29 years old";
           print "2. 30 to 34 years old\n";
           print "3. 35 to 39 years old\n";
           print "4. 40 to 44 years old\n";
           print "5. 45 to 49 years old\n";
           print "6. 50 to 54 years old\n";
           print "7. 55 to 59 years old\n";
            
           chomp ($ageSubset3Input = <STDIN>);
            
            
        }while ($ageSubset3Input !~ /^[1-7]$/);

        switch($ageSubset3Input){
            
            case 1 {$lineNeeded += 19}
            case 2 {$lineNeeded += 20}
            case 3 {$lineNeeded += 21}
            case 4 {$lineNeeded += 22}
            case 5 {$lineNeeded += 23}
            case 6 {$lineNeeded += 24}
            case 7 {$lineNeeded += 25}
                
                }
        
        
    }
    
   
    if($subset2Input == 4){
        
        do{
           
           print "Which Age Group would you like to view?\n";
           print "1. 60 to 64 years old\n";
           print "2. 65 to 69 years old\n";
           print "3. 70 to 74 years old\n";
           print "4. 75 to 79 years old\n";
           print "5. 80 to 84 years old\n";
           print "6. 85 years old and older\n";
            
           chomp ($ageSubset4Input = <STDIN>);

        }while ($ageSubset4Input !~ /^ [1-6]$/);
            
            
    switch($ageSubset4Input){
                
        case 1 {$lineNeeded += 26}
        case 2 {$lineNeeded += 27}
        case 3 {$lineNeeded += 28}
        case 4 {$lineNeeded += 29}
        case 5 {$lineNeeded += 30}
        case 6 {$lineNeeded += 31}
                    
        }
            
            
    }

    
    if($needSmallScale == 1 && $needBigScale == 0){
        print "In 2011, the number of people aged $characteristics[$lineNeeded] in $cmaca_name[$lineNeeded] was $total[$lineNeeded]:\n$male[$lineNeeded] males and $female[$lineNeeded] females.\n";
    }

    elsif($needBigScale == 1 && $needSmallScale == 0){
        print "In 2011, the number of people aged $characteristics[$lineNeeded] in $prov_name[$lineNeeded] was $total[$lineNeeded]:\n$male[$lineNeeded] males and $female[$lineNeeded] females.\n";
    }

}


if($setInput == 3){

   do{
    
      print "Which Subset would you like to view?\n";
      print "1. Married or Living with a Common-Law Partner\n";
      print "2. Married (and not Separated)\n";
      print "3. Living Common-Law\n";
      print "4. Not Married and Not Living with a Common-Law Partner\n";
      print "5. Single (Never Legally Married)\n";
      print "6. Separated\n";
      print "7. Divorced\n";
      print "8. Widowed\n";
   
      chomp ($subset3Input = <STDIN>);

   }while ($subset3Input !~ /^[1-8]$/);



   switch($subset3Input){
    
       case 1 {$lineNeeded += 33}
       case 2 {$lineNeeded += 34}
       case 3 {$lineNeeded += 35}
       case 4 {$lineNeeded += 36}
       case 5 {$lineNeeded += 37}
       case 6 {$lineNeeded += 38}
       case 7 {$lineNeeded += 39}
       case 8 {$lineNeeded += 40}

    }

    if($needSmallScale == 1 && $needBigScale == 0){

        print "In 2011, the number of people who were ".$characteristics[$lineNeeded]." in ".$cmaca_name[$lineNeeded]." was ".$total[$lineNeeded].":\n".$male[$lineNeeded]." males and ".$female[$lineNeeded]." females.\n";

    }
    elsif($needBigScale == 1 && $needSmallScale == 0){
        
        print "In 2011, the number of people who were ".$characteristics[$lineNeeded]." in ".$cmaca_name[$lineNeeded]." was ".$total[$lineNeeded].":\n".$male[$lineNeeded]." males and ".$female[$lineNeeded]." females\n";
        
        
    }


}







