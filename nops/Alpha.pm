
##
# This file is part of the Metasploit Framework and may be redistributed
# according to the licenses defined in the Authors field below. In the
# case of an unknown or missing license, this file defaults to the same
# license as the core Framework (dual GPLv2 and Artistic). The latest
# version of the Framework can always be obtained from metasploit.com.
##

package Msf::Nop::Alpha;
use strict;
use base 'Msf::Nop';
use Pex::Utils;

my $advanced = { };
my $info = {
	'Name'    => 'Alpha Nop Generator',
	'Version' => '$Revision$',
	'Authors' => [ 'vlad902 <vlad902 [at] gmail.com>', ],
	'Arch'    => [ 'alpha' ],
	'Desc'    =>  'Alpha nop generator',
	'Refs'    => [ ],
};


sub new {
	my $class = shift; 
	return($class->SUPER::new({'Info' => $info, 'Advanced' => $advanced}, @_));
}

# XXX: Operate: CMOVxx, cmp[u]l[te], (*/v?)
# XXX: InsBranch: [F]Bxx
# XXX: InsMemory (for lda and the like) 
# XXX: InsFPU??
my $table = [
	[ \&InsOperate, [ 0, [ 0x10, 0x00 ] ], ],		# addl
	[ \&InsOperate, [ 0, [ 0x10, 0x09 ] ], ],		# subl
	[ \&InsOperate, [ 0, [ 0x10, 0x20 ] ], ],		# addq
	[ \&InsOperate, [ 0, [ 0x10, 0x29 ] ], ],		# subq
	[ \&InsOperate, [ 0, [ 0x11, 0x00 ] ], ],		# and
	[ \&InsOperate, [ 0, [ 0x11, 0x08 ] ], ],		# bic (andnot)
	[ \&InsOperate, [ 0, [ 0x11, 0x20 ] ], ],		# bis (or)
	[ \&InsOperate, [ 0, [ 0x11, 0x28 ] ], ],		# ornot
	[ \&InsOperate, [ 0, [ 0x11, 0x40 ] ], ],		# xor
	[ \&InsOperate, [ 0, [ 0x11, 0x48 ] ], ],		# eqv (xornot)
	[ \&InsOperate, [ 0, [ 0x12, 0x30 ] ], ],		# zap 
	[ \&InsOperate, [ 0, [ 0x12, 0x31 ] ], ],		# zapnot
	[ \&InsOperate, [ 0, [ 0x12, 0x34 ] ], ],		# srl
	[ \&InsOperate, [ 0, [ 0x12, 0x39 ] ], ],		# sll
	[ \&InsOperate, [ 0, [ 0x12, 0x3c ] ], ],		# sra
	[ \&InsOperate, [ 0, [ 0x13, 0x00 ] ], ],		# mull
	[ \&InsOperate, [ 0, [ 0x13, 0x20 ] ], ],		# mulq
	[ \&InsOperate, [ 0, [ 0x13, 0x30 ] ], ],		# umulh
];

# Returns valid destination register number between 0 and 31 excluding $sp.
# XXX: $gp/$ra/$fp???
sub get_dst_reg {
	my $reg = int(rand(31));
	$reg += ($reg >= 30);

	return $reg;
}

# Any register.
sub get_src_reg {
	return int(rand(32));
}

sub InsOperate {
	my $ref = shift;
	my $dst = get_dst_reg();
	my $ver = $ref->[0];

# 0, ~1, !2, ~3, !4
# Use one src reg with an unsigned 8-bit immediate (non-0)
	if(($ver == 0 && int(rand(2))) || $ver == 1)
	{
		return pack("V", (($ref->[1][0] << 26) | (get_src_reg() << 21) | ((int(rand((1 << 8) - 1)) + 1) << 13) | (1 << 12) | ($ref->[1][1] << 5) | $dst));
	}
# Use two src regs
	else
	{
		return pack("V", (($ref->[1][0] << 26) | (get_src_reg() << 21) | (get_src_reg() << 16) | ($ref->[1][1] << 5) | $dst));
	}
}

sub Nops {
	my $self = shift;
	my $length = shift;
	my $backup_length = $length;

	my $exploit = $self->GetVar('_Exploit');
	my $random  = $self->GetVar('RandomNops');
	my $badChars = $exploit->PayloadBadChars;
	my ($nop, $tempnop, $count, $rand);

	if(! $random)
	{
		$length = 4;
	}

	for($count = 0; length($nop) < $length; $count++)
	{
		$rand = int(rand(scalar(@{$table})));

		$tempnop = $table->[$rand]->[0]($table->[$rand]->[1], $length - length($nop));

		if(!Pex::Utils::ArrayContains([split('', $tempnop)], [split('', $badChars)]))
		{
			$nop .= $tempnop;
			$count = 0;
		}

		if($count > $length + 1000)
		{
			if(length($nop) == 0)
			{
				$self->PrintDebugLine(3, "Iterated $count times with no nop match.");
				return;
			}

			$self->PrintDebugLine(4, "Iterated $count times with no nop match (length(\$nop) = " . sprintf("%i", length($nop)) . ")");
		}
	}

	if(! $random)
	{
		$nop = $nop x ($backup_length / 4);
	}

	return $nop;
}

1;
