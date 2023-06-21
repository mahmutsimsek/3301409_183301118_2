import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:muhasebeyeni/ekranlar/eczane_sayfasi.dart';
import 'package:muhasebeyeni/model/urun.dart';
import 'package:muhasebeyeni/veritabani/yerel_veri_tabani.dart';

import '../file/file_operations.dart';
import 'cari_sayfasi.dart';
import 'giris_sayfasi.dart';

// ignore: must_be_immutable
class anaSayfa extends StatefulWidget {
  @override
  State<anaSayfa> createState() => _anaSayfaState();
}

class _anaSayfaState extends State<anaSayfa> {
  //const anaSayfa({super.key});
  YerelVeriTabani _yerelVeriTabani = YerelVeriTabani();

  FirebaseAuth _auth = FirebaseAuth.instance;

  List<Urun> _urunler = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Ürünler"),
          //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [

            IconButton(onPressed: (){_cariSayfasiniAc(context);},  icon: Icon(Icons.request_page)),
            IconButton(onPressed: (){_dosyaSayfasiniAc(context);},  icon: Icon(Icons.drive_folder_upload_rounded)),
            IconButton(onPressed:() {_eczaneAc(context);},icon: Icon(Icons.local_pharmacy)),
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
      itemCount: _urunler.length,
      itemBuilder: _buildListTile,
    );
  }

  Widget? _buildListTile(BuildContext context, int index) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(_urunler[index].id.toString()),
      ),
      title: Text(_urunler[index].isim),
      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
        IconButton(
            onPressed: () {
              _urunGuncelle(context, index);
            },
            icon: Icon(Icons.edit)),
        IconButton(onPressed: () {_urunSil(index);}, icon: Icon(Icons.delete))
      ]),
    );
  }

  void _urunSil(int index) async {
    Urun urun=_urunler[index];
    int silinenSatirSayisi=await _yerelVeriTabani.deleteUrun(urun);
    if(silinenSatirSayisi>0){
      setState(() {

      });
    }
  }

  void _urunGuncelle(BuildContext context, int index) async {
    String yeniUrunAdi = await _pencereAc(context, "Ürün Güncelle:") ?? "";
    if (yeniUrunAdi.isNotEmpty) {
      Urun urun = _urunler[index];
      urun.isim = yeniUrunAdi;
      int guncellenenSatirSayisi = await _yerelVeriTabani.updateUrun(urun);
      if (guncellenenSatirSayisi > 0) {
        setState(() {});
      }
    }
  }

  Future<void> _tumUrunleriGetir() async {
    _urunler = await _yerelVeriTabani.readTumUrunler();
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
  void _cariSayfasiniAc(BuildContext context) {
    MaterialPageRoute sayfaYolu =
    MaterialPageRoute(builder: (BuildContext context) {
      return CariSayfasi();
    });
    Navigator.push (context, sayfaYolu);
  }
  void _eczaneAc(BuildContext context) {
    MaterialPageRoute sayfaYolu=MaterialPageRoute(
        builder: (BuildContext context) {
          return  eczane();
        }
    );
    Navigator.push(context, sayfaYolu);
  }
  void _seciliUrunleriSil() {}

  void _urunEkle(BuildContext context) async {
    String urunAdi = await _pencereAc(context, "Ürün Adını Giriniz:") ?? "";
    if (urunAdi.isNotEmpty) {
      Urun yeniUrun = Urun(urunAdi, 10);
      int urunIdsi = await _yerelVeriTabani.createKitap(yeniUrun);
      debugPrint("Urun Idsi: $urunIdsi");
      setState(() {});
    }
  }

  Future<String?> _pencereAc(BuildContext context, String baslik) {
    return showDialog<String>(
      context: context,
      builder: (context) {
        String sonuc = "";
        return AlertDialog(
          title: Text(baslik),
          content: TextField(
            keyboardType: TextInputType.text,
            onChanged: (String inputText) {
              sonuc = inputText;
            },
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
                Navigator.pop(context, sonuc.trim());
              },
            ),
          ],
        );
      },
    );
  }

  void _dosyaSayfasiniAc(BuildContext context) {
    MaterialPageRoute sayfaYolu =
    MaterialPageRoute(builder: (BuildContext context) {
      return FileOperationsScreen();
    });
    Navigator.push (context, sayfaYolu);
  }
}
