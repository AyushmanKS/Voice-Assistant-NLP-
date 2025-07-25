from flask import Flask, request, jsonify
import pickle

model = pickle.load(open('model.pkl', 'rb'))
vectorizer = pickle.load(open('vectorizer.pkl', 'rb'))

app = Flask(__name__)


@app.route('/predict', methods=['POST'])
def predict():
    data = request.get_json()
    user_input = data['text']
    X = vectorizer.transform([user_input])
    prediction = model.predict(X)[0]
    return jsonify({"intent": prediction})


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
