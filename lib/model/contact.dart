class Contact {
  int id;
  String isim;
  String telnumara;
  String avatar;

  Contact({this.isim, this.telnumara, this.avatar});

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["isim"] = isim;
    map["telnumara"] = telnumara;
    map["avatar"] = avatar;
    return map;
  }

  Contact.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    isim = map["isim"];
    telnumara = map["telnumara"];
    avatar = map["avatar"];
  }
}