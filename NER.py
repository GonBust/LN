# -*- coding: utf-8 -*-
import os, re, codecs
import nltk
from nltk.metrics.scores import precision, recall

#--------------
# Fazer:
# python3 NER.py
# ....
# quit()
#--------------

#-----------------------------------------
# Formato do ficheiro de entrada
# T - Queres ir dar uma volta por Lisboa?
# 	A - O que é que estás a fazer? : n

# Compara com ref
# Precision e recall
#-----------------------------------------

#--------------
# Procura Entidades Mencionadas, neste caso nomes de pessoas, bem como a linha onde se encontram.
# Devolve set na forma
# ('numLinha', 'nomePessoa)
#--------------

def NER(file):
	numLinha = 0
	myset = []
	for line in file:
		numLinha = numLinha + 1
		# Encontras as strings que começam por uma maiúscula
		results = re.findall(r"([A-Z]\w*)", line)
		i = 0
		while i < len(results):
			# Escolhe o que acha que são nomes de pessoas (neste momento, tudo)
			nomePessoa = re.search(r"([A-Z]\w{3,})", results[i])
			# o num de alinha é importante por causa do formato da referência
			if nomePessoa:
				m = str(numLinha), nomePessoa.group(1)
				myset.append(m)
			i = i + 1
	print_list(myset)
	return set(myset)

#---------------
# Faz o print de uma lista
#---------------
def print_list(list):
	j = 0
	while j < len(list):
		print (list[j])
		j = j + 1

#---------------
# Lê a ref
#----------------
def read_ref(file):
	ref = []
	for line in file:
		numLinha = re.search(r"(\d+)", line)
		nomePessoa = re.search(r"([A-Z]\w+)", line)
		m = numLinha.group(1), nomePessoa.group(1)
		ref.append(m)
	print_list(ref)
	return set(ref)

#--------------
# Extrai NE
#--------------
fileIn = open('Corpora/dev.txt', 'r')
myset = NER(fileIn)
fileIn.close()

#--------------
# Extrai REF
#--------------

fileRef = open('Corpora/dev-ref.txt', 'r')
ref = read_ref(fileRef)
fileRef.close()

#--------------
# Calcula precision e recall (atenção à ordem precision(ref, myset) e diferente de precision(myset, ref). Pensa porquê...)
#--------------

print ("RESULTADOS DO GRUPO FORMADO PELOS ALUNOS 82050, 89378"),
print ("Precision:", precision(ref, myset))
print ("Recall:", recall(ref, myset))

