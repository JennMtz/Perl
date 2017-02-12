use Data::Dumper qw(Dumper);

=pod
=head1
Este es un programa con siete subrutinas, dos de ellas anonimas
=cut
my $cmd; 
my $cmd1;
my $cmd2;
my @resultados; #Este arreglo debe guardar los resultados
print ("Calculadora\n");
my %HoF = ( 
    suma    => sub {
      push @resultados,$_[0]+$_[1];
      return $_[0]+$_[1];
    },
    resta   =>  \&resta,
    multiplicacion   =>  \&multiplicacion,
    division    =>  \&division,
    modulo  =>  sub {
      push @resultados,$_[0]%$_[1];
      return $_[0]%$_[1];
    },
);
while(1){
  print("Que operación necesitas realizar\n");
  print ("Si necesita ayuda escriba help o salir para terminar el programa\n\n");
  $cmd=lc <STDIN>;
  chomp($cmd);
  #print("{$cmd}");
   if($HoF{$cmd}){
    print("Ingresa el primer numero:\n");
    $val1 = <STDIN>;
    print("Ingresa el segundo numero:\n");
    $val2 = <STDIN>;
    print 'El resultado es: ' . $HoF{$cmd}->($val1,$val2) . "\n";
  }else{
    if($cmd eq 'salir'){
      print "Resultados:\n\n";
      foreach (@resultados){
        print "$_\n";
      }
      exit;
    }else{
      &help;
    }
  }
}

sub help{
  print ("\nEscribe el nombre de la operacion que deseas realizar como: suma, resta, multiplicacion, division y modulo.\n\n");
}

sub resta{
  push @resultados,$_[0]-[1];
  return $_[0]-$_[1];
}
sub multiplicacion{
   push @resultados,$_[0]*[1];
   return $_[0]*$_[1];
}
sub division{
  if ($_[1] == 0){
    return "NaN";
  }else{
    push @resultados,$_[0]/[1];
    return $_[0]/$_[1];
  }
}
