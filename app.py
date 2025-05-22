import os

from flask import (Flask, redirect, render_template, request,
                   send_from_directory, url_for)

from opentelemetry.instrumentation.flask import FlaskInstrumentor
from opentelemetry import trace

# Create Flask app
app = Flask(__name__)

# Instrument Flask app
FlaskInstrumentor().instrument_app(app)


@app.route('/')
def index():
   print('Request for index page received')
   return render_template('index.html')

@app.route('/favicon.ico')
def favicon():
    return send_from_directory(os.path.join(app.root_path, 'static'),
                               'favicon.ico', mimetype='image/vnd.microsoft.icon')

@app.route('/hello', methods=['POST'])
def hello():
   name = request.form.get('name')

   if name:
       print('Request for hello page received with name=%s' % name)
       return render_template('hello.html', name = name)
   else:
       print('Request for hello page received with no name or blank name -- redirecting')
       return redirect(url_for('index'))

@app.route('/appsmenu', methods=['GET','POST'])
def appsmenu():
   if request.method == 'POST':
       username = request.form.get('username')
       password = request.form.get('password')

       if username:
           print('Request for Appsmenu page received with username=%s' % username)
           return render_template('appsmenu.html', username = username, password = password)
       else:
           print('Request for Appsmenu page received with no username or blank username -- redirecting')
           return redirect(url_for('index'))
   else:
       # Handle GET request
       return render_template('appsmenu.html')
   

@app.route('/apps1', methods=['GET','POST'])
def apps1():
    print('Request for apps1 page received')
    return render_template('apps1.html')
  

if __name__ == '__main__':
   app.run()