# -*- coding: utf-8 -*-
import os, re, codecs
import nltk

#---------------
# Faz o print de uma lista
#---------------
def print_list(list):
	j = 0
	while j < len(list):
		print (list[j])
		j = j + 1

def InOut(file):
	numLinha = 0
	myset = []
	for line in file:
		myset.append('actor_name')
	print_list(myset)
	return set(myset)

#--------------
# Extrai as Novas Questoes
#--------------
fileIn = open('../Corpora/NovasQuestoes.txt', 'r')
myset = InOut(fileIn)
fileIn.close()