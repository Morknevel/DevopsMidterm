from flask import Blueprint, render_template, request, redirect, url_for

main = Blueprint('main', __name__)

@main.route('/', methods=['GET'])
def home():
    return render_template('home.html')

@main.route('/submit', methods=['POST'])
def submit():
    message = request.form.get('message', 'No message provided')
    return render_template('result.html', message=message)

@main.route('/health', methods=['GET'])
def health():
    return {'status': 'healthy'}, 200