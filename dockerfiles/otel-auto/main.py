from flask import Flask, jsonify
import logging
import random

app = Flask(__name__)

logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)

@app.route('/')
def hello_world():
    logger.info("Processing request for hello world")
    return jsonify(message="Hello, OpenTelemetry!")

@app.route('/random')
def random_number():
    number = random.randint(1, 100)
    logger.info(f"Generated random number: {number}")
    return jsonify(number=number)

@app.route('/error')
def error():
    try:
        1 / 0
    except ZeroDivisionError:
        logger.error("An error occurred: Division by zero")
    return jsonify(error="An error occurred"), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
