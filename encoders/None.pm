package Msf::Encoder::None;
use strict;
use base 'Msf::Encoder';

my %info = (
  'Name'  => 'Pex Double Word Xor Encoder',
  'Version'  => '1.0',
  'Author'  => 'H D Mooore <hdm[at]metasploit.com> [Artistic License]',
  'Arch'  => [ 'x86' ],
  'OS'    => [ ],
  'Desc'  =>  'Pex Double Word Xor Encoder',
  'Refs'  => [ ],
);

sub new {
  my $class = shift; 
  return($class->SUPER::new({'Info' => \%info}, @_));
}

sub EncodePayload {
  my $self = shift;
  my ($rawshell, $xbadc) = @_;
  return($rawshell);
}

1;
