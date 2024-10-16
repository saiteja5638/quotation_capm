import os
import json
from flask import Flask,jsonify,request
from cfenv import AppEnv
from hdbcli import dbapi
import pickle
import numpy as np
import pandas as pd

app = Flask(__name__)
env = AppEnv()
port = int(os.environ.get('PORT', 3001))

# Define the file paths
base_path = os.path.dirname(os.path.abspath(__file__))
scaler_path = os.path.join(base_path, 'model', 'bal_scaler_encoders.pkl')
encoders_path = os.path.join(base_path, 'model', 'bal_encoders.pkl')
model_path = os.path.join(base_path, 'model', 'random_forest_model.pkl')

# Get the root path of the current script
root_path = os.path.abspath(os.sep)
print("Root Path:", root_path)

# Check if the files exist and load them
def load_pickle(file_path):
    if os.path.exists(file_path):
        with open(file_path, 'rb') as f:
            return pickle.load(f)
    else:
        print(f"File not found: {file_path}")
        return None

# Load the scaler
scaler = load_pickle(scaler_path)
if scaler is not None:
    print("Scaler loaded successfully.")

# Load the encoders
encoders = load_pickle(encoders_path)
if encoders is not None:
    print("Encoders loaded successfully.")

# Load the Random Forest model
random_forest_model = load_pickle(model_path)
if random_forest_model is not None:
    print("Random Forest model loaded successfully.")

def predict_status(item):
    # Scale the input item using the loaded scaler
    item_scaled = scaler.transform(item.reshape(1, -1))
    
    # Perform prediction
    prediction = random_forest_model.predict(item_scaled)
    
    # Get the predicted probabilities for both classes
    probabilities = random_forest_model.predict_proba(item_scaled)[0]
    
    # Map the prediction to the corresponding label
    status_mapping = {0: 'Rejected', 1: 'Success'}
    output = status_mapping[prediction.flatten()[0]]
    
    # Calculate percentages for each class
    success_percentage = probabilities[1] * 100  # Probability of success (class 1)
    failure_percentage = probabilities[0] * 100  # Probability of failure (class 0)
    
    return output, success_percentage, failure_percentage


@app.route('/')
def hello():
   return "Welcome"

@app.route('/predict', methods=['POST'])
def predict():
    try:
        parsed_data = json.loads(request.data)
        MATNR = parsed_data['MATNR']
        KWMENG = float(parsed_data['KWMENG'])
        NETWR = float(parsed_data['NETWR'])
        KUNNR = parsed_data['KUNNR']
        VKORG = parsed_data['VKORG']

        # Prepare input data
        input_data = pd.DataFrame([[MATNR, KWMENG, NETWR, KUNNR, VKORG]], 
                                  columns=['MATNR', 'KWMENG', 'NETWR', 'KUNNR', 'VKORG'])

        # Convert categorical columns to string
        input_data['MATNR'] = input_data['MATNR'].astype(str)
        input_data['KUNNR'] = input_data['KUNNR'].astype(str)

        # Encode categorical columns
        input_data['MATNR'] = encoders['MATNR'].transform(input_data['MATNR'])
        input_data['KUNNR'] = encoders['KUNNR'].transform(input_data['KUNNR'])

        # Convert input_data to numpy array
        input_data_np = input_data.values.astype(np.float64)

        # Predict status and percentages
        status, success_percentage, failure_percentage = predict_status(input_data_np)

        # Return both percentages in the response
        return jsonify({
            'status': status,
            'success_percentage': f"{success_percentage:.2f}%",
            'failure_percentage': f"{failure_percentage:.2f}%"
        })
    
    except Exception as e:
        return jsonify({'error': str(e)})


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=port)