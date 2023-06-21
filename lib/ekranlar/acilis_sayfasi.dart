import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'giris_sayfasi.dart';
import 'anasayfa.dart';

// ignore: must_be_immutable
class AcilisSayfasi extends StatelessWidget {
   //AcilisSayfasi({super.key});
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    _yonlendir(context);
    return Scaffold(
      body: Center(
          child: Text(
        "Muhasebe",
        style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
      )),
    );
  }

  _yonlendir(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      User? kullanici = _auth.currentUser;
     await Future.delayed(const Duration(milliseconds: 1000));
      if (kullanici != null) {
        _anaSayfayiAc(context);
      } else {
        _girisSayfasiniAc(context);
      }
    });
  }

  void _anaSayfayiAc(BuildContext context) {
     MaterialPageRoute sayfaYolu=MaterialPageRoute(
      builder: (BuildContext context) {
      return  anaSayfa();
    }
    );
    Navigator.pushReplacement(context, sayfaYolu);
  }

  void _girisSayfasiniAc(BuildContext context) {
     MaterialPageRoute sayfaYolu =
        MaterialPageRoute(builder: (BuildContext context) {
      return const GirisSayfasi();
    });
    Navigator.pushReplacement(context, sayfaYolu);
  }
}
