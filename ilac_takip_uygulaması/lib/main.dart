import 'package:flutter/material.dart';
import 'package:local_notifications/views/anasayfa.dart';
import 'package:local_notifications/views/ilaclisteleme.dart';
import 'package:local_notifications/views/ilaceklemesayfasi.dart';
import 'package:local_notifications/views/raporlamasayfasi.dart';





void main() => runApp(Giris());

class Giris extends StatelessWidget {


  final appTitle = 'İlaç Kullanım Takip Uygulaması';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {"/": (context) => Anasayfa(),
        "/ilaclistesi":(context)=>Ilaclisteleme(),
        "/ilacekle":(context)=>Ilaceklemesayfasi(),
        "/raporlar":(context)=>RaporlamaSayfasi(),
      },
    );
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return null;
  }
}
