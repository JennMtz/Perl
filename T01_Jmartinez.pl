#!perl
=pod
Tarea 1 
Martinez Casares Jenifer
=head1
Este script da los resultados de la tabla de multiplicar
del #2, tiene declarada una variable llama i, que es utilizada en el for 
para recorrer mientras i sea menor o igual a 1, se estara recorriendo y nos imprimira en 
formato 2x1=2... y define pragma
=cut
use warnings;
use strict;

my $i;
print("Pragma: Son directivas del compilador, el lenguaje cuenta con: \n 1.integer\n 2.strict\n 3.warnigs\n 4.sigtrap\n 5.subs\n 6.less\n");
print("Tabla de multiplicar del 2\n");
	for($i=1; $i<=10; $i++){
		print("2 x $i =" . $i*2 ."\n");

	
}
