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
def tagSet(file):
	myset = []
	for line in file:
		myset.append('actor_name')
	print_list(myset)
	print('\n')
	return set(myset)

#----------------------
# Lê as questões e escreve as tags no ficheiro
#----------------------
def tagWrite(file,tagString):
	with open(file, 'r') as f:
		file_lines = [''.join([tagString, x.strip(), '\n']) for x in f.readlines()]
	
	with open(file, 'w') as f:
		f.writelines(file_lines)

#--------------
# Extrai as Novas Questoes
#--------------

fileIn = open('corpora/NovasQuestoes.txt', 'r')
tagWrite('corpora/NovasQuestoes.txt','actor_name ')
# myset = tagSet(fileIn)
fileIn.close()

# #--------------
# # Extrai REF
# #--------------
# fileRef = open('corpora/NovasQuestoesResultados.txt', 'r')
# ref = read_ref(fileRef)
# fileRef.close()

