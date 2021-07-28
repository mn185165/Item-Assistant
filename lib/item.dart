class Item {
  String plu = "";
  String name = "";
  String description = "";
  String aisle = "";
  String price = "";
  String imageUrl = "";
  int stock = 0;

  Item(this.plu, this.name, this.description, this.aisle, this.price,
      this.imageUrl, this.stock);

  Map<String, dynamic> toJson() {
    return {
      'plu': this.plu,
      'name': this.name,
      'description': this.description,
      'aisle': this.aisle,
      'price': this.price,
      'imageUrl': this.imageUrl,
      'stock': this.stock
    };
  }
}

Item createItem(record) {
  Map<String, dynamic> attributes = {
    'plu': '',
    'name': '',
    'description': '',
    'aisle': '',
    'price': '',
    'imageUrl': '',
    'stock': 0
  };

  record.forEach((key, value) => {attributes[key] = value});

  return new Item(
      attributes['plu'],
      attributes['name'],
      attributes['description'],
      attributes['aisle'],
      attributes['price'],
      attributes['imageUrl'],
      attributes['stock']);
}
