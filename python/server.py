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
port = int(os.environ.get('PORT', 3084))

# Define the file paths
base_path = os.path.dirname(os.path.abspath(__file__))
scaler_path = os.path.join(base_path, 'model', 'bal_scaler_encoders.pkl')
encoders_path = os.path.join(base_path, 'model', 'bal_encoders.pkl')
model_path = os.path.join(base_path, 'model', 'random_forest_model.pkl')

import os

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
    
    # Determine success/failure and calculate percentage
    prediction_class = (prediction > 0.5).astype(int)
    status_mapping = {0: 'Rejected', 1: 'Success'}
    output = status_mapping[prediction_class[0]]
    
    # Calculate success or rejection percentage
    if output == 'Success':
        percentage = (prediction - 0.5) * 200
    else:
        percentage = (0.5 - prediction) * 200

    return output, percentage[0]

@app.route('/')
def hello():
   return "Welcome"

@app.route('/predict', methods=['POST'])
def predict():
    try:

        parsed_data = json.loads(request.data)
        # print(parsed_data)
        MATNR = parsed_data['MATNR']
        KWMENG = float(parsed_data['KWMENG'])
        NETWR = float(parsed_data['NETWR'])
        KUNNR = parsed_data['KUNNR']
        VKORG = parsed_data['VKORG']

        # Prepare input data (ensure proper dtype)
        input_data = pd.DataFrame([[MATNR, KWMENG, NETWR, KUNNR, VKORG]], 
                                  columns=['MATNR', 'KWMENG', 'NETWR', 'KUNNR', 'VKORG'])
        print(input_data)

        # Convert categorical columns to string if not already
        input_data['MATNR'] = input_data['MATNR'].astype(str)
        input_data['KUNNR'] = input_data['KUNNR'].astype(str)
        # Encode categorical columns using the loaded encoders
        input_data['MATNR'] = encoders['MATNR'].transform(input_data['MATNR'])
        input_data['KUNNR'] = encoders['KUNNR'].transform(input_data['KUNNR'])
        # Convert input_data to numpy array of float64 type for prediction
        input_data_np = input_data.values.astype(np.float64)
        print('1',input_data_np)
        # Predict status and percentage
        status, percentage = predict_status(input_data_np)
        print('2',status)
        # Format the response
        return jsonify({
            'status': status,
            'percentage': f"{percentage:.2f}%"
        })
    
    except Exception as e:
        return jsonify({'error': str(e)})
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=port)