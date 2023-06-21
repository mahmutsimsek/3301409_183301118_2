import 'dart:async';

import 'package:muhasebeyeni/model/urun.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class YerelVeriTabani {
  YerelVeriTabani._privateConsructor();

  static final YerelVeriTabani _nesne = YerelVeriTabani._privateConsructor();

  factory YerelVeriTabani() {
    return _nesne;
  }
  Database? _veriTabani;

  String _urunlerTabloAdi = "urunler";
  String _idUrunler = "id";
  String _isimUrunler = "isim";
  String _adetUrunler = "adet";

  Future<Database?> _veriTabaniniGetir() async {
    if (_veriTabani == null) {
      String dosyaYolu = await getDatabasesPath();
      String veriTabaniYolu = join(dosyaYolu, "urun.db");
      _veriTabani = await openDatabase(
        veriTabaniYolu,
        version: 1,
        onCreate: _tabloOlustur,
        //onUpgrade: _tabloGuncelle,
      );
    }
    return _veriTabani;
  }

  FutureOr<void> _tabloOlustur(Database db, int version) async {
    await db.execute('''CREATE TABLE $_urunlerTabloAdi (
	$_idUrunler	INTEGER NOT NULL UNIQUE,
	$_isimUrunler	TEXT NOT NULL,
	$_adetUrunler	INTEGER,
	PRIMARY KEY("id" AUTOINCREMENT)
);''');
  }

  Future<int> createKitap(Urun urun) async {
    Database? db = await _veriTabaniniGetir();
    if (db != null) {
      return await db.insert(_urunlerTabloAdi, urun.mapeDonustur());
    } else {
      return -1;
    }
  }

Future<int> updateUrun(Urun urun) async {
    Database? db = await _veriTabaniniGetir();
    if (db != null) {
      return await db.update(
        _urunlerTabloAdi,
        urun.mapeDonustur(),
        where: "$_idUrunler = ?",
        whereArgs: [urun.id],
      );
    } else {
      return 0;
    }
  }

  Future<int> deleteUrun(Urun urun) async {
    Database? db = await _veriTabaniniGetir();
    if (db != null) {
      return await db.delete(
        _urunlerTabloAdi,
        where: "$_idUrunler = ?",
        whereArgs: [urun.id],
      );
    } else {
      return 0;
    }
  }

  Future<List<Urun>> readTumUrunler() async {
    Database? db = await _veriTabaniniGetir();
    List<Urun> urunler=[];
    if (db != null) {
      List<Map<String,dynamic>> urunlerMap=await db.query(_urunlerTabloAdi);
      for(Map<String,dynamic> m in urunlerMap){
        Urun u=Urun.maptenOlustur(m);
        urunler.add(u);
      }
    }
    return urunler;
  }
}
