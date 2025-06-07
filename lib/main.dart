import 'package:flutter/material.dart'; //Imports Flutter’s UI toolkit.
import 'Player.dart'; //Imports the Player class from Player
import 'Dungeon.dart'; //Imports the Dungeon class from Dungeon


void main() { //runs the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget { //Defines the main app widget
  const MyApp({Key? key}) : super(key: key); //Constructor

  @override
  Widget build(BuildContext context) { //Builds the UI
    return MaterialApp( //Creates a Material app
      title: 'Flutter Grid Demo',
      home: const GridScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GridScreen extends StatefulWidget {
  const GridScreen({Key? key}) : super(key: key);

  @override
  State<GridScreen> createState() => _GridScreenState();
}

class _GridScreenState extends State<GridScreen> {
  static const int rows = 8;
  static const int cols = 8;
  int playerRow = 0;
  int playerCol = 0;

  void movePlayer(int dRow, int dCol) {
    setState(() {
      playerRow = (playerRow + dRow).clamp(0, rows - 1);
      playerCol = (playerCol + dCol).clamp(0, cols - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Grid GUI')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              width: 320,
              height: 320,
              child: GridView.builder(
                itemCount: rows * cols,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                ),
                itemBuilder: (context, index) {
                  int row = index ~/ cols;
                  int col = index % cols;
                  bool isPlayer = row == playerRow && col == playerCol;
                  return Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isPlayer ? Colors.blue : Colors.grey[800],
                      border: Border.all(color: Colors.black),
                    ),
                    child: isPlayer
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Movement controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_upward),
                onPressed: () => movePlayer(-1, 0),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => movePlayer(0, -1),
              ),
              const SizedBox(width: 24),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () => movePlayer(0, 1),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_downward),
                onPressed: () => movePlayer(1, 0),
              ),
            ],
          ),
        ],
      ),
    );
  }
}