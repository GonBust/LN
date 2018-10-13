#!/bin/bash

rm -f *.fst

########## Tradutor Ingles para Portugues ##########
#Compila e gera versao grafica do transdutor en-pt
fstcompile --isymbols=palavras.syms --osymbols=palavras.syms en2pt.txt | fstarcsort > en2pt.fst
fstdraw    --isymbols=palavras.syms --osymbols=palavras.syms --portrait en2pt.fst | dot -Tpdf  > en2pt.pdf

######## MMM para MM #########
fstcompile --isymbols=palavras.syms --osymbols=palavras.syms mmm2mm.txt | fstarcsort > mmm2mm.fst
fstdraw    --isymbols=palavras.syms --osymbols=palavras.syms --portrait mmm2mm.fst | dot -Tpdf  > mmm2mm.pdf