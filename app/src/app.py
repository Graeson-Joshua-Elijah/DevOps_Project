from flask import Flask, render_template, request, redirect, url_for

app = Flask(__name__)

@app.route('/')
def home():
    return render_template('index.html', title="Home")

@app.route('/book', methods=['GET', 'POST'])
def book():
    if request.method == 'POST':
        name = request.form['name']
        email = request.form['email']
        date = request.form['date']
        time = request.form['time']
        return render_template('success.html', name=name, date=date, time=time)
    return render_template('booking.html', title="Book Now")

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
