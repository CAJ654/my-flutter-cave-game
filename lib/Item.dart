
class Item{
  late String name;
  late String description;

  Item(){
    name = "unknown";
    description = "No description available.";
  }

  Item.withDetails(this.name, this.description);

  String getName(){
    return name;
  }

  String getDescription(){
    return description;
  }
}