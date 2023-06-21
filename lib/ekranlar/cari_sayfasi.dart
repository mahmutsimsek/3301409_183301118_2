import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muhasebeyeni/model/cari.dart';

import 'package:muhasebeyeni/veritabani/uzak_veri_tabani.dart';


import 'giris_sayfasi.dart';

// ignore: must_be_immutable
class CariSayfasi extends StatefulWidget {
  @override
  State<CariSayfasi> createState() => _CariSayfasiState();
}

class _CariSayfasiState extends State<CariSayfasi> {
  //const anaSayfa({super.key});

  UzakVeriTabani _uzakVeriTabani = UzakVeriTabani();

  FirebaseAuth _auth = FirebaseAuth.instance;

  List<Cari> _cariler = [];


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text("Cariler"),
          //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            IconButton(onPressed:(){print(_cariler.last.adi+"burdaaa");}, icon: Icon(Icons.delete)),
            IconButton(
                onPressed: () {
                  _cikisYap(context);
                },
                icon: Icon(Icons.logout))
          ],
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              _urunEkle(context);
            }),
        body: _buildyBody());
  }

  Widget _buildyBody() {
    // return Center(child: Text("Anasayfa"));
    return FutureBuilder<void>(
      future: _tumUrunleriGetir(),
      builder: _builListView,
    );
  }

  Widget _builListView(BuildContext context, AsyncSnapshot<void> snapshot) {
    return ListView.builder(
      itemCount: _cariler.length,
      itemBuilder: _buildListTile,
    );
  }

  Widget? _buildListTile(BuildContext context, int index) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(_cariler[index].id.toString()),
      ),
      title: Text(_cariler[index].adi),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(
            onPressed: () {
              _urunGuncelle(context, index);
            },
            icon: Icon(Icons.edit)),
        IconButton(
            onPressed: () {
              _urunSil(index);
            },
            icon: Icon(Icons.delete))
      ]),
    );
  }

  void _urunSil(int index) async {
    Cari cari = _cariler[index];
    int silinenSatirSayisi = await
    _uzakVeriTabani.deleteCari(cari);
    if (silinenSatirSayisi > 0) {
      _cariler = [];
      setState(() {});
    }

  }

  void _urunGuncelle(BuildContext context, int index) async {
    Cari cari = _cariler[index];
     String sonuc=await _pencereAc(context, "Cari Güncelle")??"";
     _uzakVeriTabani.guncelCari(cari);
    //
    // List<dynamic> sonuc = await _pencereAc(context, "Kitap Güncelle",
    //     mevcutIsim: cari.isim, mevcutKategori: kitap.kategori) ??
    //     [] ;
    //
     if (sonuc.isNotEmpty) {
      String yeniCariAdi = sonuc;
    //   int yeniKategori = sonuc[1];
    //
    //   if (yeniKitapAdi != kitap.isim || yeniKategori != kitap.kategori) {
    //     if (yeniKitapAdi.isNotEmpty) {
    //       kitap.isim = yeniKitapAdi;
       }
    //     kitap.kategori = yeniKategori;
       int guncellenenSatirSayisi = await _uzakVeriTabani.updateCari(cari);
        if (guncellenenSatirSayisi > 0) {
          print("güncellendi");
          setState(() {});
        }
    //   }
    // }
  }

  Future<void> _tumUrunleriGetir() async {
    //_cariler = await _yerelVeriTabani.readTumUrunler();
    _cariler = await _uzakVeriTabani.readTumCariler();
  }

  void _cikisYap(BuildContext context) async {
    await _auth.signOut();
    _girisSayfasiniAc(context);

    _snackBarGoster(context, "Çıkış Yapıldı.");
  }

  void _snackBarGoster(BuildContext context, String mesaj) {
    SnackBar snackBar = SnackBar(content: Text(mesaj));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _girisSayfasiniAc(BuildContext context) {
    MaterialPageRoute sayfaYolu =
    MaterialPageRoute(builder: (BuildContext context) {
      return GirisSayfasi();
    });
    Navigator.pushReplacement(context, sayfaYolu);
  }

  void _seciliUrunleriSil() {}

  void _urunEkle(BuildContext context) async {
    String sonuc =
        await _pencereAc(context, "Cari Adını Giriniz:") ?? "";
    if (sonuc.isNotEmpty) {
      //String cariAdi = sonuc[0];
      String cariAdi = sonuc;
      //int kategori = sonuc[1];

      if (cariAdi.isNotEmpty) {
        Cari yeniCari=Cari(sonuc, "kod", "yetkili");
        dynamic cariIdsi = await _uzakVeriTabani.createCari(yeniCari);
        debugPrint("Cari Idsi: $cariIdsi");
        _cariler=[];
        setState(() {});
      }
    }
  }

  Future<void> _ilkCarileriGetir()async{
    if(_cariler.length==0){
      //_cariler=await _uzakVeriTabani.readTumCariler("adi", "kod", "yetkili");
      //_cariListesiniYazdir("İlk Cariler Getirildi");
    }
  }



  Future<String?> _pencereAc(BuildContext context, String baslik) {
    return showDialog<String>(
      context: context,
      builder: (context) {
        String ad = "";
        String yetkili="";
        return AlertDialog(
          title: Text(baslik),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.text,
                onChanged: (String inputText) {
                  ad = inputText;
                },
              ),
              // TextField(
              //   keyboardType: TextInputType.text,
              //   onChanged: (String inputText) {
              //     yetkili = inputText;
              //   },
              // ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("İptal"),
              onPressed: () {
                Navigator.pop(context, "");
              },
            ),
            TextButton(
              child: Text("Onayla"),
              onPressed: () {
                Navigator.pop(context, ad.trim());
              },
            ),
          ],
        );
      },
    );
  }
}
