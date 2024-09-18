import os
from flask import Flask, jsonify
from cfenv import AppEnv
from hdbcli import dbapi
import requests

app = Flask(__name__)
env = AppEnv()

hana_service = 'hana'
hana = env.get_service(label=hana_service)

port = int(os.environ.get('PORT', 3000))
@app.route('/')
def hello():
    if hana is None:
        return "Can't connect to HANA service '{}' – check service name?".format(hana_service)
    else:
        conn = dbapi.connect(address=hana.credentials['host'],
                             port=int(hana.credentials['port']),
                             user=hana.credentials['user'],
                             password=hana.credentials['password'],
                             encrypt='true',
                             sslTrustStore=hana.credentials['certificate'])

        cursor = conn.cursor()
        cursor.execute("select CURRENT_UTCTIMESTAMP from DUMMY")
        ro = cursor.fetchone()
        cursor.close()
        conn.close()

        return "Current time is: " + str(ro["CURRENT_UTCTIMESTAMP"])
@app.route('/hello', methods=['GET'])
def hello_world():
    url = 'https://060a0275trial-dev-quotation-capm-srv.cfapps.us10-001.hana.ondemand.com/quotation/QUOT_HEADER_DATA'
    
    # Send a GET request to the external service
    response = requests.get(url)
    
    # Check the status code of the response
    if response.status_code == 200:
        # Return the data as JSON
        data = response.json()
        return jsonify(data)
    else:
        # Return an error message
        return jsonify({'error': f"Failed to retrieve data. Status code: {response.status_code}"}), response.status_code


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=port)
