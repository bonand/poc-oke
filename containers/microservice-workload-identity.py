from flask import Flask, request, jsonify
import oci
import os

app = Flask(__name__)

# Configura OCI Object Storage client utilizzando la Workload Identity
def get_oci_client():
    signer = oci.auth.signers.get_oke_workload_identity_resource_principal_signer()
    return oci.object_storage.ObjectStorageClient(config={}, signer=signer)

# Funzione per caricare il contenuto in un bucket di Object Storage
def upload_to_bucket(bucket_name, namespace, object_name, content):
    client = get_oci_client()
    client.put_object(namespace, bucket_name, object_name, content)

# Endpoint REST per ricevere il testo e salvarlo su OCI Object Storage
@app.route('/upload', methods=['POST'])
def upload_text():
    data = request.json
    text = data.get('text', '')

    if not text:
        return jsonify({"error": "No text provided"}), 400

    bucket_name = os.environ.get("OCI_BUCKET_NAME")
    namespace = os.environ.get("OCI_NAMESPACE")
    object_name = os.environ.get("OBJECT_NAME")

    # Carica il testo nel bucket
    upload_to_bucket(bucket_name, namespace, object_name, text)

    return jsonify({"message": "Text uploaded successfully"}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
