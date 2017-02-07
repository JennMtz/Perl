use strict;
use warnings;
use diagnostics;
use v5.10;

use Getopt::Std;

# Subrutina que imprime la manera de usar el programa
sub muestra_ayuda {
  print "\nUso:";
  print "\n\n\tNOMBRE $0 -- Lee un archivo y por medio de expresiones regulares nombres de dominio, direcciones IP, correos y URL's";
  print "\n\n\t\t-h Muestra la ayuda";
  print "\n\n\t\t-f ARCHIVO Archivo de entrada ";
  print "\n\n\t\t-o ARCHIVO Archivo de salida (OPCIONAL)";  
  print "\n\n";  
  print "\n\n\tEJEMPLOS";
  print "\n\n\t\t$0 -h";  
  print "\n\n\t\t$0 ARCHIVO (Lee el ARCHIVO y el resultado lo guarda en salida.txt)";  
  print "\n\n\t\t$0 -f ARCHIVO_ENTRADA -o ARCHIVO_SALIDA (Lee el ARCHIVO_ENTRADA y el resultado lo guarda en ARCHIVO_SALIDA)"; 
  print "\n\n";  
}

# Hash en el que guardarémos los argumentos (opciones) que reciba el programa
my %opciones=();
# Se leen las opciones que se le envían al script,
# con el caracter ":"" especificamos las opciones que recibirán algun valor, en este caso f y o
# para leer el archivo de entrada y salida respectivamente
getopts("hf:o:", \%opciones);
# Si mandan el parámetro -h o (no especifican archivo de entrada con -f y no proporcionan un nombre directamente sin -f) mostramos la ayuda
if(defined $opciones{h} or (not defined $opciones{f} and @ARGV != 1)){
	muestra_ayuda();	
}else{

	# Guardamos la lista de patrones en un hash usando el nombre del patrón como llave
	# Si queremos agregar un nuevo patrón sólo tenemos que agregar una nueva pareja nombre_patron => patrón
	my %lista_patrones = (
		'1 IP\'s', '\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b',
		'2 DOMAIN\'s', '\b[a-z0-9][a-z0-9\-\+\.]{1,61}[a-z0-9]\.[a-z]+\b',
		'3 EMAIL\'s', '\b[a-z0-9][a-z0-9]*[a-z0-9\_\+\.]{1}[a-z0-9]*[a-z0-9]@[a-z0-9][a-z0-9\-\+\.]{1,61}[a-z0-9]\.[a-z]+\b',
		'4 URL\'s', '\bhttps?://[a-z0-9][a-z0-9\-\+\.]{1,61}[a-z0-9]\.[a-z]+[/?\w]*[\.\w]+\??[&?\w=\w]*\b',
	);	
	# Si especifican un archivo de entrada con -f, lo usamos, si no usamos el primer argumento que le pasen al programa
	my $nombre_archivo_entrada = defined $opciones{f} ? $opciones{f} : $ARGV[0];
	# Si especifican un archivo de entrada con -o, lo usamos, si no usamos 'salida.txt' por default
	my $nombre_archivo_salida = defined $opciones{o} ? $opciones{o} : 'salida.txt';
	my $num_linea = 0;
	# Intentamos abrir el archivo de entrada
	if(open my $archivo, '<', $nombre_archivo_entrada){
		# Aquí guardarémos los patrones y el conteo de ocurrencias
		# Será un hash de hashes (patron => {ocurrencia => #ocurrencias})
		my %conteo_general = ();
		# Leemos el archivo línea por línea
		while (my $linea = <$archivo>) {
			chomp $linea;
			# Recorremos los nombres (keys) de los patrones definidos 
			foreach my $nombre_patron (sort keys %lista_patrones){
				# Evaluamos cada línea del archivo con la expresión regular 
				# y guardamos las coincidencias en un arreglo
				# 
				# Usamos gi al final para que la búsqueda la haga en toda la línea (g) 
				# y para que ignore mayúsculas y minúsculas (i)
				my @coincidencias = $linea =~ /$lista_patrones{$nombre_patron}/gi;
				# Contamos el número de coincidencias de la expresión en la línea
				my $num_coincidencias = @coincidencias;
				#Si no se encontró un dominio tampoco encontrará correos ni urls válidas así que ya no evaluamos los patrones restantes
				if ($nombre_patron eq '2 DOMAIN\'s' and $num_coincidencias == 0){
					last;
				}

				# Para cada cadena encontrada
				foreach my $cadena_encontrada (@coincidencias){
					# Buscamos la cadena encontrada dentro del hash que corresponde al
					# nombre del patrón que estamos evaluando e incrementamos su valor 
					# 
					# Si no existe la entrada correspondiente, se crea automáticamente y su conteo se inicializa en 1
					$conteo_general{$nombre_patron}{$cadena_encontrada}++;
				}
			}
			$num_linea++;
			if($num_linea % 1000000 ==0){
				print("\n\t\t ", $num_linea*100/15728084);
			}
		}
		# Cerramos el archivo 
		close($archivo);

		# Redirigir la salida del programa al archivo de salida
		# En caso de que no se logre hacer la redirección, se manda mensaje y se utiliza la salida estándar
		# http://www.perlmonks.org/?node_id=857618
		if(not open(STDOUT, '>', $nombre_archivo_salida) or not open(STDERR, '>', "error_$nombre_archivo_salida")){
			print("\nNo se pudo crear el archivo de salida $nombre_archivo_salida. La salida se mostrará en STDOUT.\n");
		}
		
		# Contador de ocurrencias totales (con repeticiones). 
		my $total_coincidencias = 0;
		# Contador de ocurrencias diferentes totales. 
		my $total_diferentes = 0;
		# Recorremos el hash y ordenamos sus llaves alfabéticamnte
		foreach my $nombre_patron (sort keys %conteo_general){
			# Si obtenemos el hash interior nos devuelve la referencia ej. HASH(0x7fb39b82d448)
			# tenemos que de-referenciarlo con %{} 
			my %coincidencias_patron = %{$conteo_general{$nombre_patron}};
			# Contamos el número de ocurrencias diferentes para el patrón $nombre_patron
			my $num_elementos = keys $conteo_general{$nombre_patron};
			# Imprimimos el encabezado de cada patrón
			print("\n----------------------------------------------------");
			printf("\n%-5s\t|\t%s", "TOTAL", "$nombre_patron ($num_elementos diferentes)");		
			print("\n----------------------------------------------------");	
			# Contador de ocurrencias para un patrón
			my $acumulado = 0;		
			foreach my $cadena_encontrada (sort { $coincidencias_patron{$a} <=> $coincidencias_patron{$b}  or $a cmp $b } keys %coincidencias_patron) {
				printf("\n%-5s\t|\t%s", $coincidencias_patron{$cadena_encontrada}, $cadena_encontrada);
				$acumulado += $coincidencias_patron{$cadena_encontrada};
			}
			# Acumulamos en el total de coincidencias (con repetición)
			$total_coincidencias += $acumulado;
			print("\n----------------------------------------------------");	
			# Imprimimos el total de ocurrencias para este patrón
			print("\n$acumulado coincidencias \n");
			# Acumulamos el número de ocurrencias diferentes para el patrón en curso
			$total_diferentes += $num_elementos;
		}
		# Imprimimos el total de ocurrencias
		print("\n----------------------------------------------------");
		print("\nTOTAL DIREFENTES: $total_diferentes");	
		print("\nTOTAL COINCIDENCIAS: $total_coincidencias");
		print("\n----------------------------------------------------\n");	

	# Error en caso de no poder abrir el archivo de entrada
	}else{
		print "\nError al abrir el archivo '$nombre_archivo_entrada' $!\n";
	}
		
	
}