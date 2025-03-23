#!/usr/bin/env perl
use strict;
use warnings;

# updates
# add the -o parameter. Facilitated by DeepSeek R1. 03/23/2025

my $usage = "\n
        usage: perl cut.pl seq.fa [-s 0/1 | -S |-l int | -o int]
        -o int      Overlap size between consecutive chunks (default: 0)
\n";

my $length = 5000000; # length of a sequence
my $overlap = 0;      # overlap between chunks
my $separate = 1;     # 1 for 1 sequence per file, 0 for all in one file
my $size = 0;         # size control flag
my $i = 0;

# Parse command line arguments
foreach (@ARGV) {
    $separate = $ARGV[$i+1] if /^(-s|Separate)$/ && $ARGV[$i+1] !~ /^-/;
    $length = $ARGV[$i+1] if /^(-l|Length)$/i && $ARGV[$i+1] !~ /^-/;
    $overlap = $ARGV[$i+1] if /^-o$/ && $ARGV[$i+1] !~ /^-/;
    $size = 1 if /^(-S|size)$/;
    $i++;
}

die "Overlap cannot be larger than chunk size!\n" if $overlap >= $length;

open Seq, "<$ARGV[0]" or die $usage;
open List, ">$ARGV[0].list" if $separate == 1;
open Out, ">$ARGV[0].cut" if $separate == 0;

$/ = "\n>";
my $accu_len = 0;
my $k = 1;
open File, ">$ARGV[0]_sub$k" if $size == 1;

while (<Seq>) {
    s/>//g;
    chomp;
    next if /^\s+$/;
    s/\r\n/\n/g; # replace all DOS-newlines with Unix-newlines
    my ($id, $seq) = (split /\n/, $_, 2);
    $seq =~ s/\s+//g;
    my $j = 1;
    
    if ($size == 0) {
        my $seq_len = length($seq);
        for (my $i = 0; $i < $seq_len; $i += ($length - $overlap)) {
            my $chunk_end = $i + $length;
            my $len = ($chunk_end > $seq_len) ? $seq_len - $i : $length;
            my $seq_sub = substr($seq, $i, $len);
            
            if ($separate == 0) {
                print Out ">${id}_sub$j\n$seq_sub\n";
            } else {
                print List "${id}_sub$j\n";
                open File, ">${id}_sub$j" or die $!;
                print File ">${id}_sub$j\n$seq_sub\n";
                close File;
            }
            $j++;
        }
    } else {
        print File ">$id\n$seq\n";
        $accu_len += length $seq;
        if ($accu_len > $length) {
            $k++;
            $accu_len = length $seq;
            close File;
            open File, ">$ARGV[0]_sub$k" or die $!;
            print File ">$id\n$seq\n";
        }
    }
}

close Seq;
close Out if $separate == 0;
close File if $size == 1;
