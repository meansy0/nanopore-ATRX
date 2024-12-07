#!/bin/bash	
meth_file="$1"
out_file="$2"
perl -lane '
    if ($F[2] eq "c" or $F[2] eq "C") {
        $count = () = $F[4] =~ m/\.\[\+m/g;
        $meth = $count / $F[3];
        print "$F[0] $F[1] $F[2] $F[3] $meth $F[6]";
    } elsif ($F[2] eq "g" or $F[2] eq "G") {
        $count = () = $F[4] =~ m/,\[\+m/g;
        $meth = $count / $F[3];
        print "$F[0] $F[1] $F[2] $F[3] $meth $F[6]";
    }
' "$meth_file" | tr ' ' '\t' > "$out_file"
