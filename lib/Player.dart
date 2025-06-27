import 'Item.dart';
import 'Dungeon.dart';

class Player{
  //fields, instance variables
  late String name, input;
  late int moveSpeed, health, meleePower, rangedPower, defense, level, row, col;
  late List<item> inventory;
  late Dungeon dungeon;
  late bool keyNear;
  bool isAlive = true;

  //Constructor
  Player(Dungeon dun){
    name = "unknown";
    health = 10;
    moveSpeed = meleePower = rangedPower = defense = 5;
    level = 1;
    inventory = [
      item.withDetails("Sword", "A sharp, pointy stick", "-|-"),
      item.withDetails("Shield", "A big piece of wood", "[]"),
      item.withDetails("Potion", "Has a tag that says 'The good stuff'", "O<]")
      ];
    row = col = 2;
    keyNear = true;
    dungeon = dun; // Initialize the dungeon
    input = "";
  }

  //Methods
  void setKeyNear(){
    if(dungeon.map[row-1][col] == "~" || dungeon.map[row+1][col] == "~" || dungeon.map[row][col-1] == "~" || dungeon.map[row][col+1] == "~"){
      keyNear = true;
    }else{
      keyNear = false;
    }
  }

  List<item> takeInventory() => inventory;

  //work in progress
  String getCurrentTile(int r, int c) {
    // Check bounds first
    if (r < 0 || r >= dungeon.getRows() || c < 0 || c >= dungeon.getCols()) {
      print("Invalid coordinates: ($r, $c) out of bounds.");
      return "Invalid tile";
    }
    // Only allow ' ', 'T', or '#' as valid tiles
    String tile = dungeon.map[r][c];
    if (tile == ' ' || tile == 'T' || tile == '#') {
      return tile;
    } else {
      print("Invalid tile: $tile at ($r, $c)");
      return "Invalid tile";
    }
  }

  void setInput(String input) => this.input = input;

  String getInput() => input;

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
  }

  void die(){
    if(!isAlive){
      row = col = 2; // Reset position
      health--; // Reset health
      isAlive = true; // Reset alive status
    }
  }
}
