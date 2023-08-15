import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basic Game Board',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Basic Game Board'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text(
                      'You have clicked on the Board this many times:',
                    ),
                    Text(
                      '$_counter',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            ),

            /// With the dim parameter we specify the boards dimensions - cols and rows
            /// In this example it static, you can, of course, make it dynamic,
            /// as well as split it into two parameters - one for cols and one for rows
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GameBoard(dim: 4, tileAction: _incrementCounter),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _counter = 0;
          });
        },
        tooltip: 'Reset Counter',
        child: const Icon(Icons.restore),
      ),
    );
  }
}

class Tile extends StatefulWidget {
  final int id;
  final VoidCallback onClick;

  const Tile({
    Key? key,
    required this.id,
    required this.onClick,
  }) : super(key: key);

  @override
  State<Tile> createState() => _TileState();
}

class _TileState extends State<Tile> {
  bool _isSelected = false;
  final List<String> _tileTypes = ["R", "G", "B"];
  late String _type;

  @override
  void initState() {
    _type = _tileTypes[Random().nextInt(3)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (_type) {
      case 'R':
        color = Colors.red;
        break;
      case 'G':
        color = Colors.green;
        break;
      case 'B':
        color = Colors.blue;
        break;
      default:
        color = Colors.transparent;
    }
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected;
        });
        widget.onClick(); // Increase the counter on the MyHomePage
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: _isSelected ? Colors.orangeAccent : Colors.transparent,
            width: 5,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Text(
              '${widget.id}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GameBoard extends StatefulWidget {
  final int dim;
  final VoidCallback tileAction;

  const GameBoard({
    Key? key,
    required this.dim,
    required this.tileAction,
  }) : super(key: key);

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: widget.dim,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      children: List.generate(widget.dim * widget.dim, (index) {
        return Tile(
          id: index,
          onClick: widget.tileAction,
        );
      }),
    );
  }
}
