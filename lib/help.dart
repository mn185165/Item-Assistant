class Help {
  String id = "";
  String itemName = "";
  String aisle = "";
  String assistantName = "";
  String plu = "";
  bool isHelping = false;

  Help(this.itemName, this.aisle, this.plu,
      [this.assistantName = "", this.isHelping = false, this.id = ""]);

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'itemName': this.itemName,
      'aisle': this.aisle,
      'plu': this.plu,
      'assistantName': this.assistantName,
      'isHelping': this.isHelping
    };
  }

  void update(Map<String, dynamic> record) {
    this.itemName = record['itemName'];
    this.aisle = record['aisle'];
    this.plu = record['plu'];
    this.assistantName = record['assistantName'];
    this.isHelping = record['isHelping'];
    this.id = record['id'];
  }
}

Help createHelp(record) {
  Map<String, dynamic> attributes = {
    'id': '',
    'itemName': '',
    'aisle': '',
    'plu': '',
    'assistantName': '',
    'isHelping': false
  };

  record.forEach((key, value) => {attributes[key] = value});

  return new Help(
      attributes['itemName'],
      attributes['aisle'],
      attributes['plu'],
      attributes['assistantName'],
      attributes['isHelping'],
      attributes['id']);
}
