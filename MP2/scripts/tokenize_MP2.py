import nltk, re, numpy
from nltk.tokenize import sent_tokenize, word_tokenize
#from nltk.corpus import stopwords
from nltk.classify.scikitlearn import SklearnClassifier
from sklearn.naive_bayes import MultinomialNB, BernoulliNB
from pathlib import Path

data_folder = Path('corpora')
known_q = data_folder / 'QuestoesConhecidas.txt'
new_q = data_folder / 'NovasQuestoes.txt'
new_q_res = data_folder / 'NovasQuestoesResultados.txt'


#Lê todas as linhas do ficheiro "QuestoesConhecidas" e guarda-as numas lista. Em seguida separa os elementos por \n (linha)
with open(known_q) as f:
    _knqslist = f.readlines()
_knqslist2 = [x.strip() for x in _knqslist]

#Cria tuplos com os 2 elementos de cada linha, separados por " \t". Em seguida esses elementos são adicionados a uma lista
# com a estrutura adequada para treino ('texto','tag').
train_data = []
#only_q = []
for x in _knqslist:
    tag, q = x.split(' \t')
    q = re.sub(' \n','',q)
#    q_tokens = word_tokenize(q)
#    only_q.append(q_tokens)
    train_data.append((q,tag))
#print('\n', only_q)
#print('\n', train_data)

#Remove as stopwords
#stop_words = set(stopwords.words('english'))
#for i in only_q:
#    print(only_q[i])
#    #filtered_q = [w for w in only_q[i] if not w in stop_words]
#    #only_q[i] = filtered_q
#    #print(filtered_q)




#Cada palavra em todas as questões é transformada em minúscula e cada questão tokenizada.
#Verifica a existência das palavras de cada pergunta com as presentes nas "all_words"
all_words = set(word.lower() for passage in train_data for word in word_tokenize(passage[0]))
t = [({word : (word in word_tokenize(x[0])) for word in all_words}, x[1]) for x in train_data]

#o classificador NaiveBayes é treinado com o set
classifier = nltk.NaiveBayesClassifier.train(t)

#Guarda e tokeniza as novas questoes de teste
fNewQs = open(new_q).read()
newQstk = nltk.sent_tokenize(fNewQs)
#print('\n', newQstk)

#Guarda e tokeniza os resultados
fNewQsResult = open(new_q_res).read()
newQstkRes = nltk.word_tokenize(fNewQsResult)
print('\n', newQstkRes)

#Usando o classificador, classifica as novas questões
results = []
for x in newQstk:
    x_features = {word.lower(): (word in word_tokenize(x.lower())) for word in all_words}
    results.append(classifier.classify(x_features))
print('\n', results)

#Imprime a accuracy em eprcentagem
diff = numpy.sum(numpy.array(newQstkRes) == numpy.array(results))
print(f'\nClassifier accuracy percent: {(diff * 100) / len(newQstkRes)}')