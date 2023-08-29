import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';

class StockPage extends StatefulWidget {
  @override
  _StockPageState createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  SocketIO? socketIO;
  double? stockPrice;

  @override
  void initState() {
    super.initState();

    socketIO = SocketIOManager().createSocketIO(
      'http://localhost:5000', // Replace with your server IP
      '/',
    );

    socketIO!.init();

    socketIO!.subscribe('stock_price', (data) {
      setState(() {
        stockPrice = data['price'];
      });
    });

    socketIO!.connect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Simulator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                socketIO!.sendMessage('get_stock_price', 'AAPL');
              },
              child: Text('Get AAPL Stock Price'),
            ),
            Text('AAPL Stock Price: ${stockPrice ?? 'Fetching...'}'),
          ],
        ),
      ),
    );
  }
}
