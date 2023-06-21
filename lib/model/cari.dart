class Cari {
  dynamic id;
  String adi;
  String kod;
  String yetkili;

  Cari(this.adi, this.kod, this.yetkili);
  Cari.id(this.id,this.adi, this.kod, this.yetkili);

  Map<String, dynamic> mapeDonustur() {
    return {
      //"id": this.id,
      "Cari_Adi": this.adi,
      "Cari_Kodu": this.kod,
      "Cari_Yetkili": this.yetkili,
    };
  }

  Cari.maptenOlustur(Map<String, dynamic> map)
      : this.id = map["id"],
        this.adi = map["Cari_Adi"],
        this.kod = map["Cari_Kodu"],
        this.yetkili = map["Cari_Yetkili"];

}
