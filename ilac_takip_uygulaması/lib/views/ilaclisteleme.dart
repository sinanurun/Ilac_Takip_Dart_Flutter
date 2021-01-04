import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:local_notifications/witgets/myDrawer.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:local_notifications/models/dbhelper.dart';
import 'package:local_notifications/models/ilacModel.dart';


class Ilaclisteleme extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>_IlaclistelemeState();
}
//class _IlaclistelemeState extends State{
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    return Scaffold(
//      appBar: AppBar(
//        centerTitle: true,
//        title: Text("İlaç Listeleme Sayfası"),
//      ),
//      body: Container(
//        child: Center(
//          child: Text("ilaç Listeleme Alanı"),
//        ),
//      ),
//    );
//  }
//
//}

class _IlaclistelemeState extends State{

//  // test için data
//  List<Client> testClients = [Client(englishWord: "a", turkceKelime: "bir", blocked: true),
//    Client(englishWord: "ability", turkceKelime: "kabiliyet, yetenek, beceri, güç, iktidar", blocked: true),
//    Client(englishWord: "able", turkceKelime: "yapabilmek, yapabilen", blocked: true),
//    Client(englishWord: "yourself", turkceKelime: "kendin", blocked: true),  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text("İlaç Listesi")),
      drawer: MyDrawer(),
      // FutureBuilder ile listemize bağlandık
      body: FutureBuilder<List<Ilac>>(
        // future olarak database sınıfımızdaki bütün kelimeleri getir
        // adlı methodunu verdik
        future: DBHelper().getAllIlaclar(),
        builder: (BuildContext context, AsyncSnapshot<List<Ilac>> snapshot) {
          // eğer verdiğimiz future içerisinde veri var ise bunları
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Ilac item = snapshot.data[index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    DBHelper().deleteIlac(item.ilac_id);
                  },
                  child: ListTile(
                    title: Text(item.ilac_adi,style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: RichText(
                      text: TextSpan(
                        text: item.ilac_aciklama,
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(text: ' / ', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: item.ilac_kullanim_tipi),
                        ],
                      ),
                    ),

                    leading: Text(item.ilac_id.toString()),
                    trailing: Checkbox(
                      onChanged: (bool value) {
                        DBHelper().blockOrUnblock(item);
                        setState(() {});
                      },
                      value: item.blocked,
                    ),
                  ),
                );
              },
            );
            // veri yok ise ekran ortasında dönen progressindicator göster
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      // Floatingaction buton'a basınca listemizden rasgele müşteri oluşturacak
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.settings_backup_restore),
        tooltip: "Tüm İlaçları Sil",
        onPressed: () async {
          await DBHelper().deleteAll();
          print("işlem oldu");

          // listemizin uzunluğu sayısı kadar rasgele sayı üretip
          // o sayıya denk gelen müşteriyi database'e ekleyecek
//          for(var i=0;i<test.length;i++) {
//            Client rnd = testClients[i];
//            await DBHelper().newClient(rnd);
//          }

          setState(() {});
        },
      ),
    );
  }
}

