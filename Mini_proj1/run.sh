#!/bin/bash

rm -f *.fst

######## MMM para MM #########
#echo "Criado transdutor de MMM para MM"
fstcompile --isymbols=palavras.syms --osymbols=palavras.syms mmm2mm.txt | fstarcsort > mmm2mm.fst
fstdraw    --isymbols=palavras.syms --osymbols=palavras.syms --portrait mmm2mm.fst | dot -Tpdf  > mmm2mm.pdf

######## Data mista para data numerica #########
#echo "Criado transdutor de DD/MMM/AAAA para DD/MM/AAAA"
fstcompile --isymbols=palavras.syms --osymbols=palavras.syms misto2numerico.txt | fstarcsort > misto2numerico.fst
fstdraw    --isymbols=palavras.syms --osymbols=palavras.syms --portrait misto2numerico.fst | dot -Tpdf  > misto2numerico.pdf

########## Tradutor Ingles para Portugues ##########
#echo "Criado transdutor de en para pt"
fstcompile --isymbols=palavras.syms --osymbols=palavras.syms en2pt.txt | fstarcsort > en2pt.fst
fstdraw    --isymbols=palavras.syms --osymbols=palavras.syms --portrait en2pt.fst | dot -Tpdf  > en2pt.pdf

########## Tradutor Portuges para Ingles ##########
#echo "Criado transdutor de pt para en"
fstcompile --isymbols=palavras.syms --osymbols=palavras.syms pt2en.txt | fstarcsort > pt2en.fst
fstdraw    --isymbols=palavras.syms --osymbols=palavras.syms --portrait pt2en.fst | dot -Tpdf  > pt2en.pdf

########## Dia numeral para texto ##########
#echo "Criado transdutor de dia numeral para texto"
fstcompile --isymbols=palavras.syms --osymbols=palavras.syms dia.txt | fstarcsort > dia.fst
fstdraw    --isymbols=palavras.syms --osymbols=palavras.syms --portrait dia.fst | dot -Tpdf  > dia.pdf

########## Mes numeral para texto ##########
#echo "Criado transdutor de mes numeral para texto"
fstcompile --isymbols=palavras.syms --osymbols=palavras.syms mes.txt | fstarcsort > mes.fst
fstdraw    --isymbols=palavras.syms --osymbols=palavras.syms --portrait mes.fst | dot -Tpdf  > mes.pdf

########## Ano numeral para texto ##########
#echo "Criado transdutor de ano numeral para texto"
fstcompile --isymbols=palavras.syms --osymbols=palavras.syms ano.txt | fstarcsort > ano.fst
fstdraw    --isymbols=palavras.syms --osymbols=palavras.syms --portrait ano.fst | dot -Tpdf  > ano.pdf

########## Data numeral para texto ##########
#echo "Criado transdutor de data numeral para texto"
fstarcsort -sort_type=olabel dia.fst > dia2.fst
fstarcsort -sort_type=ilabel mes.fst > mes2.fst
fstarcsort -sort_type=ilabel ano.fst > ano2.fst
fstconcat dia2.fst mes2.fst > diames.fst
fstconcat diames.fst ano2.fst > numerico2texto.fst
fstdraw    --isymbols=palavras.syms --osymbols=palavras.syms --portrait numerico2texto.fst | dot -Tpdf  > numerico2texto.pdf

########## Mista para texto ##########
#echo "Criado transdutor de data mista para texto"
fstarcsort -sort_type=olabel misto2numerico.fst > misto2numerico2.fst
fstarcsort -sort_type=ilabel numerico2texto.fst > numerico2texto2.fst
fstcompose misto2numerico2.fst numerico2texto2.fst > misto2texto.fst
fstdraw    --isymbols=palavras.syms --osymbols=palavras.syms --portrait misto2texto.fst | dot -Tpdf  > misto2texto.pdf

########## Mista ou numerica para texto ##########
#echo "Criado transdutor de data mista ou numerica para texto"
fstarcsort -sort_type=olabel misto2texto.fst > misto2texto2.fst
fstarcsort -sort_type=ilabel numerico2texto.fst > numerico2texto2.fst
fstunion misto2texto2.fst numerico2texto2.fst > data2texto.fst
fstdraw    --isymbols=palavras.syms --osymbols=palavras.syms --portrait data2texto.fst | dot -Tpdf  > data2texto.pdf


########## Criacao dos fst de teste ##########
fstcompile --isymbols=palavras.syms --osymbols=palavras.syms 82050_misto.txt | fstarcsort > 82050_misto.fst
fstcompile --isymbols=palavras.syms --osymbols=palavras.syms 82050_pt.txt | fstarcsort > 82050_pt.fst
fstcompile --isymbols=palavras.syms --osymbols=palavras.syms 82050_numerico.txt | fstarcsort > 82050_numerico.fst
fstcompile --isymbols=palavras.syms --osymbols=palavras.syms 89378_misto.txt | fstarcsort > 89378_misto.fst
fstcompile --isymbols=palavras.syms --osymbols=palavras.syms 89378_pt.txt | fstarcsort > 89378_pt.fst
fstcompile --isymbols=palavras.syms --osymbols=palavras.syms 89378_numerico.txt | fstarcsort > 89378_numerico.fst


################### Testa os tradutores ################
fstcompose 82050_misto.fst misto2numerico.fst > 82050_misto2numerico.fst
echo -n "18/FEV/2013 em numerico é: "
echo " "
fstproject --project_output 82050_misto2numerico.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=palavras.syms | awk '{print $3}'

fstcompose 82050_pt.fst pt2en.fst > 82050_pt2en.fst
echo -n "18/FEV/2013 em ingles é: "
echo " "
fstproject --project_output 82050_pt2en.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=palavras.syms | awk '{print $3}'

fstcompose 82050_numerico.fst numerico2texto.fst > 82050_numerico2texto.fst
echo -n "18/02/2013 em texto é: "
echo " "
fstproject --project_output 82050_numerico2texto.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=palavras.syms | awk '{print $3}'

fstcompose 82050_misto.fst misto2texto.fst > 82050_misto2texto.fst
echo -n "18/FEV/2013 em texto é: "
echo " "
fstproject --project_output 82050_misto2texto.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=palavras.syms | awk '{print $3}'

fstcompose 82050_misto.fst data2texto.fst > 82050_data2texto.fst
echo -n "18/FEV/2013 em texto usando o data2texto é: "
echo " "
fstproject --project_output 82050_data2texto.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=palavras.syms | awk '{print $3}'

fstcompose 89378_misto.fst misto2numerico.fst > 89378_misto2numerico.fst
echo -n "12/AGO/2013 em numerico é: "
echo " "
fstproject --project_output 89378_misto2numerico.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=palavras.syms | awk '{print $3}'

fstcompose 89378_pt.fst pt2en.fst > 89378_pt2en.fst
echo -n "12/AGO/2013 em ingles é: "
echo " "
fstproject --project_output 89378_pt2en.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=palavras.syms | awk '{print $3}'

fstcompose 89378_numerico.fst numerico2texto.fst > 89378_numerico2texto.fst
echo -n "12/8/2013 em texto é: "
echo " "
fstproject --project_output 89378_numerico2texto.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=palavras.syms | awk '{print $3}'

fstcompose 89378_misto.fst misto2texto.fst > 89378_misto2texto.fst
echo -n "12/AGO/2013 em texto é: "
echo " "
fstproject --project_output 89378_misto2texto.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=palavras.syms | awk '{print $3}'

fstcompose 89378_misto.fst data2texto.fst > 89378_data2texto.fst
echo -n "12/AGO/2013 em texto usando o data2texto é: "
echo " "
fstproject --project_output 89378_data2texto.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=palavras.syms | awk '{print $3}'