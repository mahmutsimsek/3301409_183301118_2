import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/cari.dart';

class UzakVeriTabani {
  UzakVeriTabani._privateConsructor();

  static final UzakVeriTabani _nesne = UzakVeriTabani._privateConsructor();

  factory UzakVeriTabani() {
    return _nesne;
  }

  FirebaseFirestore _veriTabani = FirebaseFirestore.instance;

  String _carilerKoleksiyonAdi = "Cariler";

  Future<String> createCari(Cari cari) async {
    await _veriTabani
        .collection(_carilerKoleksiyonAdi)
        .doc()
        .set(cari.mapeDonustur());
    return "";
  }


  Future<List<Cari>> readTumCariler() async {
    List<Cari> cariler = [];

    Query<Map<String, dynamic>> sorgu =
        _veriTabani.collection(_carilerKoleksiyonAdi);

    QuerySnapshot<Map<String, dynamic>> snapshot = await sorgu.get();

    if (snapshot.docs.isNotEmpty) {
      int i = 0;
      for (DocumentSnapshot<Map<String, dynamic>> dokuman in snapshot.docs) {
        i++;
        Map<String, dynamic>? cariMap = dokuman.data();
        cariMap?["id"] = dokuman.id;


        if (cariMap != null) {

          //Cari cari1 = Cari.id(dokuman.id, cariMap["Cari_Adi"].toString(), "kod", "yetkili");
           Cari cari = Cari.maptenOlustur(cariMap);

          cariler.add(cari);
        }
      }
    }
    return cariler;
  }

  Future<List<Cari>> _readTumCariler(
    // int kategoriId,
    // int sonKitapId,
    // int CekilecekVeriSayisi,
    String adi,
    String kod,
    String yetkili,
  ) async {
    List<Cari> cariler = [];
    return cariler;
  }

  Future<int> updateCari(Cari cari) async {
    Map<String, dynamic> guncellenecekAlanlar = {
      "Cari_Adi": cari.adi,
    };

    await _veriTabani
        .collection(_carilerKoleksiyonAdi)
        .doc(cari.id)
        .update(guncellenecekAlanlar);

    return 1;
    return 0;
  }
  Future<String> guncelCari(Cari cari) async {
    print(cari.id);
    await _veriTabani
        .collection(_carilerKoleksiyonAdi)
        .doc(cari.id.toString())
        .update(cari.mapeDonustur());
    return "";
  }
  Future<int> deleteCari(Cari cari) async {
    await _veriTabani.collection(_carilerKoleksiyonAdi).doc(cari.id).delete();
    return 1;
  }

  Future<int> deleteCariler(Cari cari) async {
    return 0;
  }
}
