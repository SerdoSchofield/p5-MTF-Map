#!usr/bin/perl

package MTF::Map;
use 5.014;
use strict;
use warnings;
use Encode;
use XML::Twig;
use open ':encoding(utf8)', ':std';

_run() unless caller();

sub new #accepts filehandle or XML string
{
	my ($fh) = @_;
	$fh = _handle($fh);
	_scan($fh);
}

sub _run
{
	my $fh = $ARGV[0];
	$fh = _handle($fh);
	_scan($fh);
}

sub _handle
{
	## no critic (RequireBriefOpen)
    my ($fh) = @_;
    my $handle;
    if ($fh) {
        if ( ref($fh) eq 'GLOB' ) {
            $handle = $fh;
        }
		#emulate diamond operator
		elsif ($fh eq q{-}){
			$handle = \*STDIN;
		}
        else {
            open $handle, '<', $fh or die "Couldn't open $fh";
        }
    }
	my $utf8 = encode('UTF-8', $handle);
	return $handle;
}

sub _scan  #returns a barebone MAPPING as scalar Ref for furthing editing
{
	my ($fh) = @_;
	
	my $twig = XML::Twig->new(
		twig_handlers => {
			descrip => \&_parse
		},
	);
	
	$twig->safe_parse($fh);
}

sub _parse
{
	my ($twig, $elt) = @_;
	
	print $elt;
	
}