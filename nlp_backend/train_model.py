import json
import random
import pickle
import numpy as np
import nltk
from sklearn.naive_bayes import MultinomialNB
from sklearn.feature_extraction.text import CountVectorizer

nltk.download('punkt')

# Load training data
with open('intents.json') as f:
    data = json.load(f)

corpus = []
labels = []
for intent in data['intents']:
    for pattern in intent['patterns']:
        corpus.append(pattern)
        labels.append(intent['tag'])

# Convert to features
vectorizer = CountVectorizer()
X = vectorizer.fit_transform(corpus)
y = labels

# Train model
model = MultinomialNB()
model.fit(X, y)

# Save model and vectorizer
pickle.dump(model, open('model.pkl', 'wb'))
pickle.dump(vectorizer, open('vectorizer.pkl', 'wb'))
