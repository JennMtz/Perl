#!perl
use warnings;
use strict;
use Data::Dumper qw(Dumper);

#Practica 1, arreglo del uno al 10 que guerda en otro arreglo  los numeros pares 
my @ar=(1..10);
my @ar1=();
foreach my $elem (@ar){
    if($elem % 2 == 0){
       push(@ar1, $elem);        
    }
}
print Dumper @ar1;

