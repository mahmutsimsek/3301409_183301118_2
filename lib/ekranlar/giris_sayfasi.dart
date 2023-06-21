import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'anasayfa.dart';
import 'kayit_sayfasi.dart';

class GirisSayfasi extends StatefulWidget {
  const GirisSayfasi({super.key});

  @override
  State<GirisSayfasi> createState() => _GirisSayfasiState();
}

class _GirisSayfasiState extends State<GirisSayfasi> {
  TextEditingController _epostaConroller = TextEditingController(text: "a@a.com");
  TextEditingController _sifreConroller = TextEditingController(text:"123456");
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Giriş Sayfası"),
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
          controller: _epostaConroller,
          keyboardType: TextInputType.emailAddress,
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
          child: ElevatedButton(child: Text("Giriş Yap"), onPressed: () {
            _epostaVeSifreIleGiris(context);
          }),
        ),
                      SizedBox(
          height: 16,
        ),
        Container(
          width: double.infinity,
          child: ElevatedButton(child: Text("Hesabınız Yok Mu? Kayıt Olun."),
           onPressed: () {
            _kayitSayfasiniAc(context);
           }),
        ),
      ]),
    );
  }
  
  void _kayitSayfasiniAc(BuildContext context) {
    MaterialPageRoute sayfaYolu=MaterialPageRoute(
      builder: (BuildContext context) {
      return KayitSayfasi();
    }
    );
    Navigator.pushReplacement(context, sayfaYolu);
  }

void _epostaVeSifreIleGiris(BuildContext context) async {
    
    String eposta = _epostaConroller.text.trim();
    String sifre = _sifreConroller.text.trim();
    try {
      UserCredential kullaniciKimligi = await _auth
          .signInWithEmailAndPassword(email: eposta, password: sifre);
      User? kullanici = kullaniciKimligi.user;
      if (kullanici!=null) {
        _snackBarGoster(context, "Giriş Başarılı.");
        _anaSayfayiAc(context);
      }
      
    } on FirebaseException catch (e) {
      if (e.code == "user-not-found") {
       
        _snackBarGoster(context, "Kullanıcı Bulunamadı.");
      } else if (e.code == "wrong-password") {
       
         _snackBarGoster(context, "Yanlış Şifre Girdiniz!");
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
  
 
  
  void _anaSayfayiAc(BuildContext context) {

    MaterialPageRoute sayfaYolu=MaterialPageRoute(
      builder: (BuildContext context) {
      return anaSayfa();
    }
    );
    Navigator.pushReplacement(context, sayfaYolu);
  }

}
