=pod
=head1
Practica 04
Sacar el template, y agregar la funcion de menú que llama al template para que pueda mostrarse en web
=cut
#!/usr/bin/perl
use strict;
package interfaces;
#Modulos utilizado 
use Net::Ifconfig::Wrapper ;
use HTML::Template;
use parent 'CGI::Application'; #Modos de ejecucion en la web
use CGI::Application::Plugin::Forward;

#Subrutina 
sub setup { 
  my $self = shift;
  $self->run_modes(
    'view' => 'showForm',
    'controler' => 'changeIP',
    'menu'  =>  'menu',
    'suma'  => 'suma',
  ); 
  $self->start_mode('menu');
  $self->mode_param('selector');
}
#subrutina que recibe el template para web, llamado ./calc.tmpl y lo muestra en forma de tabla
sub showForm{
    my $output;
    my $template = HTML::Template->new(filename => './calc.tmpl');
    my $info=&inet_info;
    my @loop_data=();
    while(@{$info->[0]}){
        my %row_data;
        $row_data{iface}=shift @{$info->[0]};
        $row_data{inet}=shift @{$info->[1]};
        $row_data{netmask}=shift @{$info->[2]};
        push(@loop_data,\%row_data);
  
    }
    $template->param(interfaces => \@loop_data);
    $output.=$template->output();
    #print $output;
    return $output;
}

sub changeIP{
  my $var="Cambiar IP";
  return $var;
}
#Subrutina que recibe los numeros para hacer la suma 
sub suma{
  #return "Hola";
  my $self = shift;
  my $q=$self->query();
  my $a=$q->param('numero1');
  my $b=$q->param('numero2');
  return $a+$b;
}
sub menu{
my $output;  my $template = HTML::Template->new(filename => './calc.tmpl');
  $output.=$template->output();
    #print $output;
    return $output;
}
sub inet_info{
  my $list=&listIface();
  my @ip_address;
  my @netmask;
  my @interface_name = keys %$list;
  foreach my $iface(keys %$list){
    my @tmp=keys %{$list->{$iface}->{inet}},"\n"||" ";
    push(@ip_address,shift @tmp);
    @tmp=values %{$list->{$iface}->{inet}},"\n"||" ";
    push(@netmask,shift @tmp);
  }
  #while(@interface_name){
  #        print "\n",shift @interface_name;
  #        print "\n",shift @ip_address;
  #        print "\n",shift @netmask;
  #}
  my @info=(\@interface_name,\@ip_address,\@netmask);
  return \@info;
}
sub listIface{
  my $interfaces=Net::Ifconfig::Wrapper::Ifconfig('list','','','');
  return $interfaces;
}
1
