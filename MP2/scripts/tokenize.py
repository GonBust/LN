import nltk, re, pprint, random
from nltk.tokenize import sent_tokenize, word_tokenize
from nltk.classify.scikitlearn import SklearnClassifier
from sklearn.naive_bayes import MultinomialNB, BernoulliNB

#Lê todas as linhas do ficheiro "QuestoesConhecidas" e guarda-as numas lista. Em seguida separa os elementos por \n (linha)
with open('corpora\\QuestoesConhecidas.txt') as f:
    _knqslist = f.readlines()
_knqslist2 = [x.strip() for x in _knqslist]

#Cria tuplos com os 2 elementos de cada linha, separados por " \t". Em seguida esses elementos são adicionados a uma lista
# com a estrutura adequada para treino ('texto','tag').
train_data = []
for x in _knqslist:
    tag, q = x.split(" \t")
    q = re.sub(" \n","",q)
    train_data.append((q,tag))
print(train_data)

#Cada palavra em todas as questões é transformada em minúscula e cada questão tokenizada.
#Verifica a existência das palavras de cada pergunta com as presentes nas "all_words"
#all_words = set(word.lower() for passage in train_data for word in word_tokenize(passage[0]))
#t = [({word : (word in word_tokenize(x[0])) for word in all_words}, x[1]) for x in train_data]

#o classificador NaiveBayes é treinado com o set
#classifier = nltk.NaiveBayesClassifier.train(t)

#Guarda e tokeniza as novas questoes de teste
fNewQs = open('corpora\\NovasQuestoes.txt').read()
newQstk = nltk.sent_tokenize(fNewQs)
print(newQstk)

#Guarda e tokeniza os resultados
fNewQsResult = open('corpora\\NovasQuestoesResultados.txt').read()
newQstkRes = nltk.word_tokenize(fNewQsResult)
print(newQstkRes)

#Usando o classificador, classifica as novas questões
#results = []
#for x in newQstk:
#    x_features = {word.lower(): (word in word_tokenize(x.lower())) for word in all_words}
#    results.append(classifier.classify(x_features))

#Imprime a accuracy em eprcentagem
#print("Classifier accuracy percent:",(nltk.classify.accuracy(classifier,new))*100)