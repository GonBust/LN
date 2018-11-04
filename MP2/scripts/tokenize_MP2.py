import nltk, re, numpy, string
from nltk.tokenize import sent_tokenize, word_tokenize
from nltk.corpus import stopwords
from nltk.stem import PorterStemmer
from nltk.classify.scikitlearn import SklearnClassifier
from sklearn.naive_bayes import MultinomialNB, BernoulliNB
from pathlib import Path

ps = PorterStemmer()
data_folder = Path('corpora')
known_q = data_folder / 'QuestoesConhecidas.txt'
new_q = data_folder / 'NovasQuestoes.txt'
new_q_res = data_folder / 'NovasQuestoesResultados.txt'

#Remove todas as stopwords de um dado argumento
def remove_stop_words(sent):
    stop_words = set(stopwords.words("english"))
    word_tokens = word_tokenize(sent) 
    filtered = [w for w in word_tokens if not w in stop_words]
    new_sent = "".join([" "+i if not i.startswith("'") and i not in string.punctuation else i for i in filtered]).strip()
    return new_sent

#Lê todas as linhas do ficheiro "QuestoesConhecidas" e guarda-as numas lista. Em seguida separa os elementos por \n (linha)
with open(known_q) as f:
    _knqslist = f.readlines()
_knqslist2 = [x.strip() for x in _knqslist]

#Cria tuplos com os 2 elementos de cada linha, separados por " \t". Em seguida esses elementos são adicionados a uma lista
# com a estrutura adequada para treino ('pergunta','tag'). Às perguntas são removidas as stop words. 
train_data = []
for x in _knqslist:
    tag, q = x.split(' \t')
    q = remove_stop_words(re.sub(' \n','',q))
    train_data.append((q,tag))

print('\ntrain data:\n')
for i in range(0, 10):
    print(f'{train_data[i]}')

#Cada palavra em todas as questões é transformada em minúscula e cada questão tokenizada.
#Verifica a existência das palavras de cada pergunta com as presentes nas "all_words"
all_words = set(word.lower() for passage in train_data for word in word_tokenize(passage[0]))
t = [({word : (word in word_tokenize(x[0])) for word in all_words}, x[1]) for x in train_data]

#o classificador NaiveBayes é treinado com o set
classifier = nltk.DecisionTreeClassifier.train(t)

#Guarda todas as questões com as stopwords removidas. Tokeniza as frases resultantes.
fNewQs = open(new_q).read()
newQstk = nltk.sent_tokenize(fNewQs)
newQstk_no_stop_words = [remove_stop_words(sent) for sent in newQstk]

print('\nnewQstk no stop words:\n')
for i in range(0, 10):
    print(f'{newQstk_no_stop_words[i]}')

#Guarda e tokeniza os resultados
fNewQsResult = open(new_q_res).read()
newQstkRes = nltk.word_tokenize(fNewQsResult)

#Usando o classificador, classifica as novas questões
results = []
for x in newQstk_no_stop_words:
    x_features = {word.lower(): (word in word_tokenize(x.lower())) for word in all_words}
    results.append(classifier.classify(x_features))

print('\nnewQstkRes:\t\tresults:\n')
line = 0
for i in range(0, 42):
    line += 1
    print(f'{line}\t{newQstkRes[i]}\t\t{results[i]}')

print('\nWrong results:\nline: Question:\t\t\t\t\t\t\t\tright result:\t\tresult:')
line = 0
for i in range(0, 42):
    line += 1
    if newQstkRes[i] != results[i]:
        print(f'{line} {newQstk[i]}\t\t{newQstkRes[i]}\t\t{results[i]}\n')

#Imprime a accuracy em eprcentagem
diff = numpy.sum(numpy.array(newQstkRes) == numpy.array(results))
print(f'\nClassifier accuracy percent: {"{0:.2f}".format((diff * 100) / len(newQstkRes))}')