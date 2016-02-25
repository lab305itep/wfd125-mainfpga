#!/bin/bash

# wrap   overwrite fmt csum_fill out NOSWAP prom_siz beg_adr
xilinx promgen -w -p bin -c FF -o $1 -b -s 16384 -u 0 $2 $3 $3 $3 $3 >/dev/null

rm -f ${1/.bin/.prm}
rm -f ${1/.bin/.cfi}
