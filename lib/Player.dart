import 'Item.dart';
import 'Dungeon.dart';

class Player{
  //fields, instance variables
  late String name;
  late int moveSpeed;
  late int health;
  late int meleePower;
  late int rangedPower;
  late int defense;
  late int level;
  late List<Item> inventory;
  late int row;
  late int col;
  late Dungeon dungeon;

  //Constructor
Player(Dungeon dun){
  name = "unknown";
  moveSpeed = 5;
  health = 10;
  meleePower = 5;
  rangedPower = 5;
  defense = 5;
  level = 1;
  inventory = [];
  row = 2;
  col = 2;
  dungeon = dun; // Initialize the dungeon
}

  //Methods
  List<Item> takeInventory(){
    return inventory;
  }

  String getCurrentTile(int r, int c) {
  if (r < 0 || r >= dungeon.getRows() || c < 0 || c >= dungeon.getCols() || dungeon.map[r][c] != ' ') { //prevents from moving outide map or to non-blank tiles
    print("Invalid coordinates: ($r, $c) out of bounds.");
    return "Invalid tile";
  } else {
    return dungeon.map[r][c];
  }
}

  void move(int dRow, int dCol, int rows, int cols) {
  int newRow = row + dRow;
  int newCol = col + dCol;

  // Check bounds
  if (getCurrentTile(newRow, newCol) == "Invalid tile") {
    print("Move out of bounds!");
    return;
  }else{
    // Update position
    row = newRow;
    col = newCol;
  }
  
  print("Player moved to new position: ($row, $col)");
  }

}