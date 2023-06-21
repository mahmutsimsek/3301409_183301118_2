import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'giris_sayfasi.dart';

class KayitSayfasi extends StatefulWidget {
  const KayitSayfasi({super.key});

  @override
  State<KayitSayfasi> createState() => _KayitSayfasiState();
}

class _KayitSayfasiState extends State<KayitSayfasi> {
  TextEditingController _adSoyadConroller = TextEditingController();
  TextEditingController _epostaConroller = TextEditingController();
  TextEditingController _sifreConroller = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kayıt Sayfası"),
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _buildyBody(context),
    );
  }

  Widget _buildyBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 32, left: 16, right: 16),
      child: Column(children: [
        TextField(
          controller: _adSoyadConroller,
          //keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: "Ad-Soyad"),
        ),
        SizedBox(
          height: 16,
        ),
        TextField(
          controller: _epostaConroller,
          keyboardType: TextInputType.emailAddress,
          // obscureText: true,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: "E-posta"),
        ),
        SizedBox(
          height: 16,
        ),
        TextField(
          controller: _sifreConroller,
          keyboardType: TextInputType.text,
          obscureText: true,
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: "Şifre"),
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          width: double.infinity,
          child: ElevatedButton(child: Text("Kayıt Ol"), onPressed: () {
            _epostaVeSifreIleKayit(context);
          }),
        ),
        SizedBox(
          height: 16,
        ),
        Container(
          width: double.infinity,
          child: ElevatedButton(
              child: Text("Zaten Hesabınız Var Mı? Giriş Yapın."),
              onPressed: () {
                _girisSayfasiniAc(context);
              }),
        ),
      ]),
    );
  }

  void _girisSayfasiniAc(BuildContext context) {
    MaterialPageRoute sayfaYolu =
        MaterialPageRoute(builder: (BuildContext context) {
      return GirisSayfasi();
    });
    Navigator.pushReplacement(context, sayfaYolu);
  }

  void _epostaVeSifreIleKayit(BuildContext context) async {
    String adSoyad = _adSoyadConroller.text.trim();
    String eposta = _epostaConroller.text.trim();
    String sifre = _sifreConroller.text.trim();
    try {
      UserCredential kullaniciKimligi = await _auth
          .createUserWithEmailAndPassword(email: eposta, password: sifre);
      User? kullanici = kullaniciKimligi.user;
      await kullanici?.updateDisplayName(adSoyad);
    } on FirebaseException catch (e) {
      if (e.code == "weak-password") {
       // print("Parola çok zayıf.");
        _snackBarGoster(context, "Parola çok zayıf.");
      } else if (e.code == "email-already-in-use") {
       // print("Bu e-posta ile daha önce hesap oluşturulmuş.");
         _snackBarGoster(context, "Bu e-posta ile daha önce hesap oluşturulmuş.");
      }
    } catch (e) {
      print(e);
    }
  }

  void _snackBarGoster(BuildContext context,String mesaj)
  {
    SnackBar snackBar=SnackBar(content: Text(mesaj));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
