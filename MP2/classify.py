import sys, nltk, re, numpy, string
from nltk.tokenize import sent_tokenize, word_tokenize
from nltk.corpus import stopwords
from nltk.classify.scikitlearn import SklearnClassifier
from nltk.classify  import ClassifierI
from sklearn.linear_model import LogisticRegression, SGDClassifier
from sklearn.svm import LinearSVC
from pathlib import Path
from statistics import mode

##### OUR CLASSIFIER #####

class VoteClassifier(ClassifierI):
    def __init__(self, *classifiers):
        self._classifiers = classifiers

    def classify(self, features):
        votes = []
        for c in self._classifiers:
            v = c.classify(features)
            votes.append(v)
        if len(votes) > len(set(votes)):
            return mode(votes)
        else:
            return votes[0]
    
    def confidence(self, features):
        votes = []
        for c in self._classifiers:
            v = c.classify(features)
            votes.append(v)
        choice_votes = votes.count(mode(votes))
        conf = choice_votes / len(votes)
        return conf

### PATHS ###
data_folder = Path('corpora')
rec_folder = Path('recursos')
known_q = data_folder / 'QuestoesConhecidas.txt'
new_q = data_folder / 'NovasQuestoes.txt'
new_q_res = data_folder / 'NovasQuestoesResultados.txt'
#known_q = str(sys.argv[1])
#new_q = str(sys.argv[2])
rec_list_movies = rec_folder / 'list_movies.txt'
rec_list_people = rec_folder / 'list_people.txt'
rec_list_companies = rec_folder / 'list_companies.txt'

######### FUNCOES DE SUPORTE #########
#Remove todas as stopwords de um dado argumento
def remove_stop_words(sentence):
    stop_words = set(stopwords.words("english"))
    word_tokens = word_tokenize(sentence) 
    filtered = [w for w in word_tokens if not w in stop_words]
    new_sentence = "".join([" "+i if not i.startswith("'") and i not in string.punctuation else i for i in filtered]).strip()
    return new_sentence

#Substitui um elemento da frase por uma palavra, caso encontre o elemento na lista
def replace_with_word(sentence, words_list, word):
    for words in words_list:
        if words in sentence:
            newsentence = sentence.replace(words, word)
            return newsentence
    return sentence

######### FILE READERS #########
#Guarda todos os recursos em listas
with open(rec_list_movies) as f:
    _movieslist = f.readlines()
_movieslist = [x.strip() for x in _movieslist]

with open(rec_list_people) as f:
    _peoplelist = f.readlines()
_peoplelist = [x.strip() for x in _peoplelist]

with open(rec_list_companies) as f:
    _companieslist = f.readlines()
_companieslist = [x.strip() for x in _companieslist]

#Lê todas as linhas do ficheiro "QuestoesConhecidas" e guarda-as numas lista. Em seguida separa os elementos por \n (linha)
with open(known_q) as f:
    _knqslist = f.readlines()
_knqslist2 = [x.strip() for x in _knqslist]

#Guarda todas as questões com as stopwords removidas e palavras substituidas. Tokeniza as frases resultantes.
fNewQs = open(new_q).read()
newQstk = nltk.sent_tokenize(fNewQs)
newQstk = [replace_with_word(sentence, _movieslist, 'movie_title') for sentence in newQstk]
newQstk = [replace_with_word(sentence, _peoplelist, 'person_name') for sentence in newQstk]
newQstk = [replace_with_word(sentence, _companieslist, 'prod_company') for sentence in newQstk]
newQstk = [remove_stop_words(sentence) for sentence in newQstk]

##Guarda e tokeniza os resultados
fNewQsResult = open(new_q_res).read()
newQstkRes = nltk.word_tokenize(fNewQsResult)

#Imprime apenas os resultados um por linha
#for i in range(0, len(newQstk)):
#    print(f'{i + 1} {newQstk[i]}')

######### TRAIN AND TEST SET #########
#Cria tuplos com os 2 elementos de cada linha, separados por " \t". Em seguida esses elementos são adicionados a uma lista
#com a estrutura adequada para treino ('pergunta','tag'). Às perguntas são removidas as stop words. 
train_data = []
for x in _knqslist:
    tag, q = x.split(' \t')
    q = remove_stop_words(replace_with_word(re.sub(' \n','',q), _movieslist, 'movie_title'))
    q = replace_with_word(q, _peoplelist, 'person_name')
    q = replace_with_word(q, _companieslist, 'prod_company')
    train_data.append((q,tag))

#Cada palavra em todas as questões é transformada em minúscula e cada questão tokenizada.
#Verifica a existência das palavras de cada pergunta com as presentencees nas "all_words"
all_words = set(word.lower() for passage in train_data for word in word_tokenize(passage[0]))
t = [({word : (word in word_tokenize(x[0])) for word in all_words}, x[1]) for x in train_data]

#### CLASSIFICADOR ####
LRclassif = SklearnClassifier(LogisticRegression(solver='lbfgs' ,multi_class='ovr')).train(t)
SGDCclassif = SklearnClassifier(SGDClassifier(max_iter=100, tol=None)).train(t)
LSVCclassif = SklearnClassifier(LinearSVC()).train(t)
voted_classifer = VoteClassifier(LRclassif, SGDCclassif, LSVCclassif)

#Usando o classificador, classifica as novas questões
results = []
for x in newQstk:
    x_features = {word.lower(): (word in word_tokenize(x.lower())) for word in all_words}
    results.append(voted_classifer.classify(x_features))
    #print(voted_classifer.confidence(x_features))

#Imprime apenas os resultados um por linha
#for i in range(0, len(results)):
#    print(f'{results[i]}')

#Imprime as respostas esperadas e os resultados obtidos em 2 colunas separadas
print('\nnewQstkRes:\t\tresults:\n')
for i in range(0, len(results)):
    print(f'{i + 1}\t{newQstkRes[i]}\t\t{results[i]}')

#Imprime a accuracy em percentagem
diff = numpy.sum(numpy.array(newQstkRes) == numpy.array(results))
print(f'\nClassifier accuracy percent: {"{0:.2f}".format((diff * 100) / len(newQstkRes))}')
