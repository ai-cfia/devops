import json
from http.server import BaseHTTPRequestHandler, HTTPServer
import re

AUTH_HEADER = 'trufflehog verif' # can be a secret if needed

pattern = re.compile(r'ailabsecret-.*')

class Verifier(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(405)
        self.end_headers()

    def do_POST(self):
        try:
            if self.headers.get('Authorization') != AUTH_HEADER:
                self.send_response(401)
                self.end_headers()
                return

            length = int(self.headers['Content-Length'])
            raw_data = self.rfile.read(length)
            data = json.loads(raw_data)

            self.log_message("Received payload: %s", data)

            secret_values = data.get('ailab_detector', {}).get('ailab', [])

            if not secret_values:
                self.send_response(400)
                self.end_headers()
                return

            secret = secret_values[0]

            if pattern.fullmatch(secret):
                self.send_response(200)  # Valid
            else:
                self.send_response(403)  # Denied
            self.end_headers()

        except Exception as e:
            self.log_message("Exception: %s", str(e))
            self.send_response(400)
            self.end_headers()

with HTTPServer(('', 8000), Verifier) as server:
    print("Trufflehog verif server running on 8000...")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("Shutting down.")
