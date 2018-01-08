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
#       This code will the hub to run all the perl scripts related to this assignment
#
# * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * #


#
#   Variables
#

my $EMPTY = q{};
my $SPACE = q{ };
my $COMMA = q{,};

my $csv          = Text::CSV->new({ sep_char => $COMMA });

my $in;
my $inCheck;
my $flag = 0;

my $a;

# create the process to verify
printf("Verifing, verify.pl <All CANSIM data> -> <verified data>\n");
system("/usr/bin/perl verify.pl alldata.csv -> verifiedData.csv");
system("clear");


while($flag == 0){
    
    $inCheck = 0;
    
    while($inCheck == 0){
        
        print "Would you like to check data(D), ask a Census data question(C), look at premade question(P), or ask a question(Q): ";
        
        chomp ($in = <STDIN>);
        
        if($in eq "D"){
            
            # check data for a question
            print "Meta verify, metaVerify.pl <verified data>\n";
            system("/usr/bin/perl metaVerify.pl verifiedData.csv");
            
        }
        elsif($in eq "C"){
            
            # create the question
            print "Census Data Question, censusQuestion.pl\n";
            system("/usr/bin/perl ");
            
        }
        elsif($in eq "P"){
            
            # run the premade questions
            
            #A1
            print "A former chemistry teacher wants to teach in a city that has the highest incidents of drug possession and production.\n";
            
            chomp ($a = <STDIN>);
            
            system("/usr/bin/perl readfile.pl questionA1.csv -> answer2.csv");
            
            chomp ($a = <STDIN>);
            
            #A2
            
            
            #B1
            
            
            #C1
            
            #C2
            
            #C3
            
            
            
        }
        elsif($in eq "Q"){
            
            # create the question
            printf"Questions, questionScript.pl <verified data> -> <question file>\n";
            system("/usr/bin/perl questionScript.pl verifiedData.csv");
            
            
            
        }
        
    }
    
        
    $inCheck = 0;
    
    while($inCheck == 0){
        
        print "Would you like to go again(Y/N): ";
        
        chomp ($in = <STDIN>);
        
        if($in eq "Y"){
            
            $inCheck = 1;
            
        }
        elsif($in eq "N"){
            
            $inCheck = 1;
            $flag = 1;
            
        }
        
    }
    
}


#
#   End of Script
#
