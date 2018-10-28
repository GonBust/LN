# -*- coding: utf-8 -*-
import os, re, codecs
import nltk
from nltk.metrics.scores import precision, recall

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
		ref.append(line.strip())
	print_list(ref)
	print('\n')
	return set(ref)

#---------------
# Lê as Questoes e associa tag
#----------------
def InOut(file):
	myset = []
	for line in file:
		myset.append('actor_name')
	print_list(myset)
	print('\n')
	return set(myset)

#--------------
# Extrai as Novas Questoes
#--------------
fileIn = open('Corpora/NovasQuestoes.txt', 'r')
myset = InOut(fileIn)
fileIn.close()

#--------------
# Extrai REF
#--------------
fileRef = open('Corpora/NovasQuestoesResultados.txt', 'r')
ref = read_ref(fileRef)
fileRef.close()

print ("Precision:", precision(ref, myset))
print ("Recall:", recall(ref, myset))
