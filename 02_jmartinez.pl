#!perl
#Pracitica numero 2
#Calculadora de subrutinas que recibe dos parametros. 

#use warnings;
#use strings;

print("Elige una accion\n 1.Suma\n 2.Resta\n 3.Multiplicacion\n 4.Division\n");

my $eleccion=<STDIN>;
print("Dame el primer numero\n");
my $numero1=<STDIN>;
print("Dame el segundo numero\n");

my $numero2=<STDIN>;
my $resultado;
&main;
sub main{
	
	if($eleccion==1){
		&suma($numero1, $numero2);
	}
	if ($eleccion==2){
		&resta($numero1, $numero2);
	}
	if($eleccion==3){
		&multi($numero1, $numero2);
	}
	if ($eleccion==4){
		&divi($numero1, $numero2);
	}
}


sub suma{
	$resultado= $_[0] + $_[1] ;

	print("Tu resultado es:\n", $resultado);
}
	


sub resta{
	$resultado= $_[0] - $_[1] ;
		print("Tu resultado es:\n", $resultado);

}
	


sub multi{
		$resultado= $_[0] * $_[1] ;
		print("Tu resultado es:\n", $resultado);
}

sub divi{
	$resultado= $_[0] % $_[1] ;
		print("Tu resultado es:\n", $resultado);
	}

