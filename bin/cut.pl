#!usr/bin/env perl
use strict;
use warnings;

my $usage = "\n
	usage: perl cut.pl seq.fa [-s 0/1 | -S |-l int]
\n";

my $length=5000000; #length of a sequence
my $separate=1; #1 for 1 sequence per file, 0 for all sequence in 1 files.
my $size=0; #no size control; if set to 10000; program will output sequence files every $length base (roundup to single sequence)
my $i=0;
foreach (@ARGV){
	$separate=$ARGV[$i+1] if /^(-s|Separate)$/ and $ARGV[$i+1] !~ /^-/;
	$length=$ARGV[$i+1] if /^(-l|Length)$/i and $ARGV[$i+1] !~ /^-/;
	$size=1 if /^(-S|size)$/;
	$i++;
	}
open Seq, "<$ARGV[0]" or die $usage;
open List, ">$ARGV[0].list" if $separate==1;
open Out, ">$ARGV[0].cut" if $separate==0;

$/="\n>";
my $accu_len=0;
my $k=1;
	open File, ">$ARGV[0]_sub$k" if $size==1;
while (<Seq>){
	s/>//g;
	chomp;
	next if /^\s+$/;
	my ($id, $seq)=(split /\n/, $_, 2);
	$seq=~s/\s+//g;
	my $j=1;
	if ($size==0){
	my $len=$length;
	for (my $i=0; ; $i+=$len){
		$len=length($seq)-$i if length($seq)<$i+$len;
		my $seq_sub=substr($seq, $i, $len);
		last if length($seq_sub)<1;
		if ($separate==0){
			print Out ">${id}_sub$j\n$seq_sub\n";
			}
		elsif ($separate==1){
			print List "${id}_sub$j\n";
			open File, ">${id}_sub$j" or die $!;
			print File ">${id}_sub$j\n$seq_sub\n";
			close File;
			}
		$j++;
		}
		} else {
		print File ">$id\n$seq\n";
		$accu_len+=length $seq;
		if ($accu_len>$length){
			print "$accu_len\n";
			$k++;
			$accu_len=0;
			close File;
			open File, ">$ARGV[0]_sub$k" or die $!;
			}
		}
	}
close Seq;
close Out if $separate == 0;
