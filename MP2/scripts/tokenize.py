import nltk, re, pprint
from nltk.tokenize import sent_tokenize, word_tokenize
from nltk.classify.scikitlearn import SklearnClassifier
from sklearn.naive_bayes import MultinomialNB

tagSet = {'actor_name','budget','character_name','genre','keyword','original_language',
'original_title','overview','person_name', 'production_company', 'production_country',
'release_date', 'revenue', 'runtime','spoken_language', 'vote_avg'}

fNewQs = open('corpora\\NovasQuestoes.txt').read()
newQstk = nltk.sent_tokenize(fNewQs)

with open('corpora\\QuestoesConhecidas.txt') as f:
    _knqslist = f.readlines()
_knqslist = [x.strip() for x in _knqslist]
knTags = []
knQs = []

for x in _knqslist:
    tag, q = x.split(" \t")
    knTags.append(tag)
    knQs.append(q)

#to do - each Q' bag of words. each Q as document? (movie reviews)
#      - training set
#      - remember this needs to be multiclass
#Refs : https://pythonprogramming.net/naive-bayes-classifier-nltk-tutorial/ ; 
# https://stackoverflow.com/questions/20827741/nltk-naivebayesclassifier-training-for-sentiment-analysis
# http://www.nltk.org/book/ch06.html