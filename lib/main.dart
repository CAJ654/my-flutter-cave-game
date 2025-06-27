import 'package:flutter/material.dart'; // Flutter UI toolkit import
import 'Player.dart'; // Player class import
import 'Dungeon.dart'; // Dungeon class import

void main() { // Entry point of the app
  runApp(const MyApp());
}

// Main app widget
class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Constructor

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Grid Demo', // App title
      home: const GridScreen(), // Home screen widget
      debugShowCheckedModeBanner: false, // Hide debug banner
    );
  }
}

// Main game screen as a stateful widget
class GridScreen extends StatefulWidget {
  const GridScreen({super.key});

  @override
  State<GridScreen> createState() => _GridScreenState();
}

// State for the main game screen
class _GridScreenState extends State<GridScreen> {
  static const int rows = 8; // Number of grid rows
  static const int cols = 8; // Number of grid columns

  late Player player; // Player instance
  late Dungeon dungeon; // Dungeon instance

  final TextEditingController _textController = TextEditingController(); // Controller for text input
  bool _inventoryExpanded = false; // Controls inventory expansion

  // Handles player movement and updates key proximity
  void movePlayer(int dRow, int dCol) {
    setState(() {
      player.move(dRow, dCol, rows, cols); // Move player
      player.setKeyNear(); // Update keyNear status
    });
  }

  // Initialize dungeon and player
  @override
  void initState() {
    super.initState();
    dungeon = Dungeon();
    player = Player(dungeon);
  }

  void _handleTextInput(String value) {
    player.setInput(value);
    switch (value.trim().toLowerCase()) {
      case 'u':
      case 'up':
        movePlayer(-1, 0); // Up
        break;
      case 'l':
      case 'left':
        movePlayer(0, -1); // Left
        break;
      case 'r':
      case 'right':
        movePlayer(0, 1); // Right
        break;
      case 'd':
      case 'down':
        movePlayer(1, 0); // Down
        break;
      case 'od':
      case 'open door':
      //work in progress
        if (player.getCurrentTile(player.row + 1, player.col) == 'D') { 
          dungeon.addLog('Door opened');
          dungeon.setTile(player.row + 1, player.col, ' '); // Open the door
        } else if(){

        }
        
        else {
          dungeon.addLog('No door here to open.');
        }
        break;

      default:
        dungeon.addLog(player.getInput()); // Log unrecognized input
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cthulhu Cave Game')), // App bar
      body: Stack(
        children: [
          // Main content: grid and controls
          Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
            children: [
              Center(
                child: SizedBox(
                  width: 320,
                  height: 320,
                  child: GridView.builder(
                    itemCount: rows * cols, // Total grid cells
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols, // Number of columns
                    ),
                    itemBuilder: (context, index) {
                      int row = index ~/ cols; // Row index
                      int col = index % cols; // Column index
                      bool isPlayer = row == player.row && col == player.col; // Is player here?
                      return Container(
                        margin: const EdgeInsets.all(2), // Cell margin
                        decoration: BoxDecoration(
                          color: isPlayer ? Colors.blue : Colors.grey[800], // Player or tile color
                          border: Border.all(color: Colors.black), // Cell border
                        ),
                        child: Center(
                          child: isPlayer
                              ? const Icon(Icons.person, color: Colors.white) // Player icon
                              : Text(
                                  dungeon.map[row][col], // Tile symbol
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24), // Space below grid
              // Movement controls and text input
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Arrow controls in a column
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_upward),
                        onPressed: () => movePlayer(-1, 0), // Move up
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => movePlayer(0, -1), // Move left
                          ),
                          const SizedBox(width: 24),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: () => movePlayer(0, 1), // Move right
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_downward),
                        onPressed: () => movePlayer(1, 0), // Move down
                      ),
                    ],
                  ),
                  const SizedBox(width: 32), // Space between arrows and input
                  // Text input and Go button
                  Row(
                    children: [
                      SizedBox(
                        width: 180,
                        child: TextField(
                          controller: _textController, // Input controller
                          decoration: const InputDecoration(
                            labelText: 'Enter command',
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (value) {
                            _handleTextInput(value);
                            _textController.clear(); 
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _handleTextInput(_textController.text); // Use the same helper
                            _textController.clear(); // Clear input
                          });
                        },
                        child: const Text('Go'), // Button label
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // Player info and inventory cards at bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Player info card
                  Card(
                    child: SizedBox(
                      width: 220, // Set width as needed
                      child: ListTile(
                        title: Text('Player: ${player.name}'), // Player name
                        subtitle: Text('Health: ${player.health}'), // Player health
                        leading: const Icon(Icons.person), // Person icon
                      ),
                    ),
                  ),
                  const SizedBox(width: 24), // Space between cards
                  // Inventory card
                  Container(
                    color: Colors.transparent,
                    child: SizedBox(
                      height: _inventoryExpanded ? 1000 : 80,
                      width: 300,
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end, // Align children to the bottom
                          mainAxisSize: MainAxisSize.max,           // Take all available vertical space
                          children: [
                            if (_inventoryExpanded)
                              ...player.takeInventory().map((item) => ListTile(
                                    leading: Text(item.getIcon()), // <-- Show the icon here
                                    title: Text(item.getName()),
                                    subtitle: Text(item.getDescription()),
                                  )),
                            ListTile(
                              title: const Text('Inventory'),
                              subtitle: Text(
                                player.takeInventory().isEmpty
                                    ? 'Empty'
                                    : player.takeInventory().map((item) => item.getName()).join(', '),
                              ),
                              leading: const Icon(Icons.inventory),
                              trailing: Icon(_inventoryExpanded ? Icons.expand_less : Icons.expand_more),
                              onTap: () {
                                setState(() {
                                  _inventoryExpanded = !_inventoryExpanded;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Log box at center left
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 16.0),
              child: Container(
                width: 200, // Log box width
                height: 300, // Log box height
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 129, 129, 129), // Background color
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                  border: Border.all(color: const Color.fromARGB(255, 0, 0, 0), width: 2), // Border
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      dungeon.getLog().join('\n'), // Show log entries
                      textAlign: TextAlign.left,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Image box at top left
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 24.0, left: 16.0),
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  color: Colors.black12, // Placeholder background color
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: const Center(
                  child: Text(
                    'Image Box',
                    style: TextStyle(color: Colors.black54, fontSize: 18),
                  ),
                ),
                // To use an image, replace the child with:
                // child: Image.asset('assets/your_image.png', fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
