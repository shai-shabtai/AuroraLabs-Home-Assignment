from flask import Flask

app = Flask(__name__)

@app.route('/')
@app.route("/get")
def get_response():
    return("Devops is great")

@app.route("/healthcheck")
def check_health():
    return {"status": "ok"}

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
