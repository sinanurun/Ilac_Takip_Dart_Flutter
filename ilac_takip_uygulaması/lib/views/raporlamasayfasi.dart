import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:local_notifications/models/kullanimModel.dart';
import 'package:local_notifications/witgets/myDrawer.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:local_notifications/models/dbhelper.dart';
import 'package:local_notifications/models/ilacModel.dart';


class RaporlamaSayfasi extends StatefulWidget {
  RaporlamaSayfasi({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() =>_RaporlamaSayfasiState();
}


class _RaporlamaSayfasiState extends State{
  Future<List<Kullanim>> _kullanim = DBHelper().getAllKullanimlar();

  List<DropdownMenuItem<String>> _dropDownMenuItems;


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text("İlaç Kullanımı Raporları")),
      drawer: MyDrawer(),
      // FutureBuilder ile listemize bağlandık
      body: FutureBuilder<List<Kullanim>>(
        // future olarak database sınıfımızdaki bütün kelimeleri getir
        // adlı methodunu verdik
        future: DBHelper().getAllKullanimlar(),
        builder: (BuildContext context, AsyncSnapshot<List<Kullanim>> snapshot) {
          // eğer verdiğimiz future içerisinde veri var ise bunları
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                Kullanim item = snapshot.data[index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Colors.red),
                  onDismissed: (direction) {
                    DBHelper().kullanimblockOrUnblock(item);
                  },
                  child: ListTile(
                    title: Text( item.ilac_adi + " - " +item.ilac_kullanim_tarihi,style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: RichText(
                      text: TextSpan(
                        text: item.ilac_bildirim_zamani,
                        style: DefaultTextStyle.of(context).style,
                        children: <TextSpan>[
                          TextSpan(text: ' / ', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: item.ilac_kullanim_zamani),
                        ],
                      ),
                    ),

                    leading: Text(item.kullanim_id.toString()),
                    trailing: Checkbox(
                      onChanged: (bool value) {
                        DBHelper().kullanimblockOrUnblock(item);
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

