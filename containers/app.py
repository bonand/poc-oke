# app.py
from flask import Flask, request, jsonify
import os

app = Flask(__name__)

# Ottiene i percorsi dei file dalle variabili d'ambiente
PERSISTENT_FILE_PATH = os.getenv('PERSISTENT_FILE_PATH', '/mnt/oci-fs-storage/persistent_file.txt')
LOCAL_FILE_PATH = os.getenv('LOCAL_FILE_PATH', '/mnt/local-storage/local_file.txt')

@app.route('/write', methods=['POST'])
def write_string():
    data = request.json
    string_to_write = data.get('string', '')

    try:
        # Scrittura nel volume persistente
        with open(PERSISTENT_FILE_PATH, 'w') as persistent_file:
            persistent_file.write(string_to_write)

        # Scrittura nel volume locale
        with open(LOCAL_FILE_PATH, 'w') as local_file:
            local_file.write(string_to_write)

        return jsonify({"message": "String written to both files"}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
