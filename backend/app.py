from flask import Flask, render_template
from flask_socketio import SocketIO
import yfinance as yf

app = Flask(__name__)
socketio = SocketIO(app, cors_allowed_origins="*")

@app.route('/')
def index():
    return "Stock Simulator Backend"

def fetch_stock_price(symbol):
    stock = yf.Ticker(symbol)
    return stock.history(period="1d")["Close"][0]

@socketio.on('get_stock_price')
def handle_stock_price_request(symbol):
    price = fetch_stock_price(symbol)
    socketio.emit('stock_price', {'symbol': symbol, 'price': price})

if __name__ == '__main__':
    socketio.run(app, debug=True)
