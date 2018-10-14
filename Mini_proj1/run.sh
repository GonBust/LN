#!/bin/bash

rm -f *.fst

######## MMM para MM #########
echo "Criado transdutor de MMM para MM"
fstcompile --isymbols=palavras.syms --osymbols=palavras.syms mmm2mm.txt | fstarcsort > mmm2mm.fst
fstdraw    --isymbols=palavras.syms --osymbols=palavras.syms --portrait mmm2mm.fst | dot -Tpdf  > mmm2mm.pdf

######## DD/MMM/AAAA para DD/MM/AAAA #########
echo "Criado transdutor de DD/MMM/AAAA para DD/MM/AAAA"
fstcompile --isymbols=palavras.syms --osymbols=palavras.syms misto2numerico.txt | fstarcsort > misto2numerico.fst
fstdraw    --isymbols=palavras.syms --osymbols=palavras.syms --portrait misto2numerico.fst | dot -Tpdf  > misto2numerico.pdf

########## Tradutor Ingles para Portugues ##########
echo "Criado transdutor de en para pt"
fstcompile --isymbols=palavras.syms --osymbols=palavras.syms en2pt.txt | fstarcsort > en2pt.fst
fstdraw    --isymbols=palavras.syms --osymbols=palavras.syms --portrait en2pt.fst | dot -Tpdf  > en2pt.pdf

########## Tradutor Portuges para Ingles ##########
echo "Criado transdutor de pt para en"
fstcompile --isymbols=palavras.syms --osymbols=palavras.syms pt2en.txt | fstarcsort > pt2en.fst
fstdraw    --isymbols=palavras.syms --osymbols=palavras.syms --portrait pt2en.fst | dot -Tpdf  > pt2en.pdf

########## dia numeral para texto ##########
echo "Criado transdutor de dia numeral para texto"
fstcompile --isymbols=palavras.syms --osymbols=palavras.syms dia.txt | fstarcsort > dia.fst
fstdraw    --isymbols=palavras.syms --osymbols=palavras.syms --portrait dia.fst | dot -Tpdf  > dia.pdf

########## mes numeral para texto ##########
echo "Criado transdutor de mes numeral para texto"
fstcompile --isymbols=palavras.syms --osymbols=palavras.syms mes.txt | fstarcsort > mes.fst
fstdraw    --isymbols=palavras.syms --osymbols=palavras.syms --portrait mes.fst | dot -Tpdf  > mes.pdf

########## ano numeral para texto ##########
echo "Criado transdutor de ano numeral para texto"
fstcompile --isymbols=palavras.syms --osymbols=palavras.syms ano.txt | fstarcsort > ano.fst
fstdraw    --isymbols=palavras.syms --osymbols=palavras.syms --portrait ano.fst | dot -Tpdf  > ano.pdf