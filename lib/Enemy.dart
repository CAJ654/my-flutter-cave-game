
class Enemy{
  String name;
  int health;
  int attackPower;

  Enemy(this.name, this.health, this.attackPower);

  void attack() {
    print('$name attacks with $attackPower power!');
  }

  void takeDamage(int damage) {
    health -= damage;
    print('$name takes $damage damage and has $health health left.');
  }

  bool isAlive() {
    return health > 0;
  }
}