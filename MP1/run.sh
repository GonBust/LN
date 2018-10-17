#!/bin/bash

rm -f *.fst
rm -f *.pdf

######## MMM para MM #########
fstcompile --isymbols=palavras.syms --osymbols=palavras.syms mmm2mm.txt | fstarcsort > mmm2mm.fst
fstdraw    --isymbols=palavras.syms --osymbols=palavras.syms --portrait mmm2mm.fst | dot -Tpdf  > mmm2mm.pdf

######## Barra para barra #########
fstcompile --isymbols=palavras.syms --osymbols=palavras.syms barra2barra.txt | fstarcsort > barra2barra.fst
fstdraw    --isymbols=palavras.syms --osymbols=palavras.syms --portrait barra2barra.fst | dot -Tpdf  > barra2barra.pdf

######## Numero para Numero #########
fstcompile --isymbols=palavras.syms --osymbols=palavras.syms num2num.txt | fstarcsort > num2num.fst
fstdraw    --isymbols=palavras.syms --osymbols=palavras.syms --portrait num2num.fst | dot -Tpdf  > num2num.pdf

######## Data mista para numerica #########
fstconcat num2num.fst barra2barra.fst > numbarra.fst
fstconcat numbarra.fst mmm2mm.fst > numbarramm.fst
fstconcat numbarramm.fst barra2barra.fst > numbarrammbarra.fst
fstconcat numbarrammbarra.fst num2num.fst > misto2numerico.fst
fstdraw    --isymbols=palavras.syms --osymbols=palavras.syms --portrait misto2numerico.fst | dot -Tpdf  > misto2numerico.pdf

######## Ingles para portugues aux #########
fstcompile --isymbols=palavras.syms --osymbols=palavras.syms en2ptaux.txt | fstarcsort > en2ptaux.fst
fstdraw    --isymbols=palavras.syms --osymbols=palavras.syms --portrait en2ptaux.fst | dot -Tpdf  > en2ptaux.pdf

######## Portugues para Ingles aux#########
fstinvert en2ptaux.fst > pt2enaux.fst

####### Ingles para portugues #########
fstconcat num2num.fst barra2barra.fst > numbarra.fst
fstconcat numbarra.fst en2ptaux.fst > numbarraen2ptaux.fst
fstconcat numbarraen2ptaux.fst barra2barra.fst > numbarraen2ptauxbarra.fst
fstconcat numbarraen2ptauxbarra.fst num2num.fst > en2pt.fst
fstdraw    --isymbols=palavras.syms --osymbols=palavras.syms --portrait en2pt.fst | dot -Tpdf  > en2pt.pdf

####### Portugues para ingles #########
fstconcat num2num.fst barra2barra.fst > numbarra.fst
fstconcat numbarra.fst pt2enaux.fst > numbarrapt2enaux.fst
fstconcat numbarrapt2enaux.fst barra2barra.fst > numbarrapt2enauxbarra.fst
fstconcat numbarrapt2enauxbarra.fst num2num.fst > pt2en.fst
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

######## Barra para de #########
fstcompile --isymbols=palavras.syms --osymbols=palavras.syms barra2de.txt | fstarcsort > barra2de.fst
fstdraw    --isymbols=palavras.syms --osymbols=palavras.syms --portrait barra2de.fst | dot -Tpdf  > barra2de.pdf

########## Data numeral para texto ##########
#echo "Criado transdutor de data numeral para texto"
fstconcat dia.fst barra2de.fst > diade.fst
fstconcat diade.fst mes.fst > diademes.fst
fstconcat diademes.fst barra2de.fst > diademesde.fst
fstconcat diademesde.fst ano.fst > numerico2texto.fst
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
echo -n "18/02/2013 em texto usando o data2texto é: "
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
echo -n "12/08/2013 em texto usando o data2texto é: "
echo " "
fstproject --project_output 89378_data2texto.fst | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=palavras.syms | awk '{print $3}'