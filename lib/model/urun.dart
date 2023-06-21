class Urun {
  int? id;
  String isim;
  int adet;

  Urun(this.isim, this.adet);

  Map<String, dynamic> mapeDonustur() {
    return {
      "id": this.id,
      "isim": this.isim,
      "adet": this.adet,
    };
  }

  Urun.maptenOlustur(Map<String, dynamic> map)
      : this.id = map["id"],
        this.isim = map["isim"],
        this.adet = map["adet"];
}
