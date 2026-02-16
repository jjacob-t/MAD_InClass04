import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name
      title: 'Stateful Widget',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // A widget that will be started on the application startup
      home: CounterWidget(),
    );
  }
}
class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}


class _CounterWidgetState extends State<CounterWidget> {

 late final TextEditingController _controller;

  @override
    void initState() {
      super.initState();
      _controller = TextEditingController(text: "1");
    }

  @override
    void dispose() {
      _controller.dispose();
      super.dispose();
    }
    void _incrementCounter(int amount) {
      if (_counter + amount > 100) {
        _counter = 100;
        _history.insert(0, _counter);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Maximum limit reached!"),
            duration: Duration(seconds: 2)
            ),
        );
      } 
      else {
      setState(() {
        _history.insert(0, _counter);
        _counter += amount;
      });
      }
  }

  // Logic for decrement and reset buttons
  void _decrementCounter() {
    if (_counter > 0) {
      setState(() {
        _history.insert(0, _counter); 
        _counter--;
      });
    }
  }
  void _resetCounter() {
    if (_counter > 0) {
      setState(() => _counter = 0);
    }
  }

  void _undoCounter() {
    setState(() {
      if (_history.length > 1) {
        _history.removeAt(0);
        _counter = _history[0];
      }
    });
  }

  // Function checks counter and returns the correct color when displaying the text
  Color _getCounterColor () {
    if (_counter == 0) {
      return Colors.red;
    }
    if (_counter > 50) {
      return Colors.green;
    }
    else {
      return Colors.black;
    }
  }

//initial couter value
  int _counter = 0;
  int _customIncrement = 0;
  final List<int> _history = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stateful Widget'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.blue,
                  width: 2 
                  ),
                  borderRadius: BorderRadius.circular(12)
                ),
              child: Text(
                //displays the current number
                '$_counter',
                style: TextStyle(
                  fontSize: 50.0,
                  color: _getCounterColor(),
                ),
              ),
            ),
          ),
          Slider(
            min: 0,
            max: 100,
            value: _counter.toDouble(),
            onChanged: (double value) {
              setState(() {
                _history.insert(0, _counter);
                _counter = value.toInt();
              });
            },
            activeColor: Colors.blue,
            inactiveColor: Colors.red,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _incrementCounter(1),
                child: const Text('+1'),
              ),
            ],
          ),
        
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _counter > 0 ? _decrementCounter : null,
                child: const Text('-1'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _counter > 0 ? _resetCounter : null,
                child: const Text('Reset'),
              ),
            ],
          ),
         
          SizedBox(height: 12),

          TextField(
          controller: _controller,
          keyboardType: TextInputType.number,
          onChanged: (value) {
            _customIncrement = int.tryParse(value) ?? 0;
          },
          onEditingComplete: () {
            setState(() {
              _incrementCounter(_customIncrement);
            });
            _controller.clear();
            _customIncrement = 0;
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Enter Custom Increment',
          ),
        ),

        ElevatedButton(
          onPressed: _history.length > 1 ? _undoCounter : null,
          child: const Text("Undo")),

        Expanded(
          child: ListView.builder(
            itemCount: _history.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("Last value: ${_history[index].toString()}",
                style: const TextStyle(fontSize: 18)
              ),
              );
            }
          )
        ),
      ]
      ),
    );
  }
}
