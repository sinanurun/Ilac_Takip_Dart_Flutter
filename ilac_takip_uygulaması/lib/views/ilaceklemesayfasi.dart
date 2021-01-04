import 'package:flutter/material.dart';
import 'package:local_notifications/models/ilacModel.dart';
import 'package:local_notifications/witgets/myDrawer.dart';
import 'package:local_notifications/models/dbhelper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Ilaceklemesayfasi extends StatefulWidget {
  Ilaceklemesayfasi({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() =>_IlaceklemeState();

}

class _IlaceklemeState extends State<Ilaceklemesayfasi>{
  List _kullanimtipleri = ["Sabah - Öğlen - Akşam", "Sabah - Akşam", "Sabah", "Akşam", "Öğlen"];

  List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _currentKullanim;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentKullanim = _dropDownMenuItems[0].value;
    ilac_kullanim_tipi = _currentKullanim;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String kullanimtipi in _kullanimtipleri) {
      items.add(new DropdownMenuItem(
          value: kullanimtipi,
          child: new Text(kullanimtipi)
      ));
    }
    return items;
  }

  String ilac_adi = "";
  String ilac_aciklama = "";
  String ilac_kullanim_tipi = "";
//  String ilac_kullanim_02 = "";
//  String ilac_kullanim_03 = "";
//  String ilac_kullanim_04 = "";
//  String ilac_kullanim_05 = "";
//  String ilac_kullanim_06 = "";
  bool blocked = true;

  void changedDropDownItem(String selectedKullanim) {
    setState(() {
      _currentKullanim = selectedKullanim;
      ilac_kullanim_tipi = _currentKullanim;

    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Yeni İlaç Ekleme Sayfası")),
      drawer: MyDrawer(),
//      resizeToAvoidBottomPadding: false,
      body: ListView(
        //mainAxisAlignment: MainAxisAlignment.center,

        children: <Widget>[
          Text("Aşağıdaki Forma Yeni İlaç Bilgilerini Yazınız", style: TextStyle(fontSize: 20),textAlign: TextAlign.center),
          SizedBox(height: 10),
          //ilaç adı
          TextField(decoration:InputDecoration(labelText: "İlaç Adı",
              border: OutlineInputBorder()
          ),textAlign: TextAlign.center,
            // Her yeni veri girildiğinde çalışır
            onChanged: (veri) {
              ilac_adi = veri;
            },
            // Klavyedeki Gönder(Bitti) tuşuna basınca çalışır
            onSubmitted: (veri) {
              ilac_adi = veri;
            },
          ),
          SizedBox(height: 10),
          //ilaç açıklama
          TextField(decoration:InputDecoration(labelText: "İlaç Açıklaması",
              border: OutlineInputBorder()
          ),textAlign: TextAlign.center,
            // Her yeni veri girildiğinde çalışır
            onChanged: (veri) {
              ilac_aciklama = veri;
            },
            // Klavyedeki Gönder(Bitti) tuşuna basınca çalışır
            onSubmitted: (veri) {
              ilac_aciklama = veri;
            },
          ),
          SizedBox(height: 10),
          Center(
            child:DropdownButton(
            value: _currentKullanim,
            items: _dropDownMenuItems,
            onChanged: changedDropDownItem,
          ),
          ),
          SizedBox(height: 10),
//          //ilac_kullanim_02
//          TextField(decoration:InputDecoration(labelText: "İkinci Kullanım Saati",
//              border: OutlineInputBorder()
//          ),textAlign: TextAlign.center,
//            // Her yeni veri girildiğinde çalışır
//            onChanged: (veri) {
//              ilac_kullanim_02 = veri;
//            },
//            // Klavyedeki Gönder(Bitti) tuşuna basınca çalışır
//            onSubmitted: (veri) {
//              ilac_kullanim_02 = veri;
//            },
//          ),
//          SizedBox(height: 10),
//          //ilac kullanımı_03
//          TextField(decoration:InputDecoration(labelText: "Üçüncü Kullanım Saati",
//              border: OutlineInputBorder()
//          ),textAlign: TextAlign.center,
//            // Her yeni veri girildiğinde çalışır
//            onChanged: (veri) {
//              ilac_kullanim_03 = veri;
//            },
//            // Klavyedeki Gönder(Bitti) tuşuna basınca çalışır
//            onSubmitted: (veri) {
//              ilac_kullanim_03 = veri;
//            },
//          ),
//          SizedBox(height: 10),
//          //ilac_kullanim_04
//          TextField(decoration:InputDecoration(labelText: "Dördüncü Kullanım Saati",
//              border: OutlineInputBorder()
//          ),textAlign: TextAlign.center,
//            // Her yeni veri girildiğinde çalışır
//            onChanged: (veri) {
//              ilac_kullanim_04 = veri;
//            },
//            // Klavyedeki Gönder(Bitti) tuşuna basınca çalışır
//            onSubmitted: (veri) {
//              ilac_kullanim_04 = veri;
//            },
//          ),
//          SizedBox(height: 10),
//          //ilac_kullanim_05
//          TextField(decoration:InputDecoration(labelText: "Beşinci Kullanım Saati",
//              border: OutlineInputBorder()
//          ),textAlign: TextAlign.center,
//            // Her yeni veri girildiğinde çalışır
//            onChanged: (veri) {
//              ilac_kullanim_05 = veri;
//            },
//            // Klavyedeki Gönder(Bitti) tuşuna basınca çalışır
//            onSubmitted: (veri) {
//              ilac_kullanim_05 = veri;
//            },
//          ),
//          SizedBox(height: 10),
//          //ilac_kullanim_06
//          TextField(decoration:InputDecoration(labelText: "Altıncı Kullanım Saati",
//              border: OutlineInputBorder()
//          ),textAlign: TextAlign.center,
//            // Her yeni veri girildiğinde çalışır
//            onChanged: (veri) {
//              ilac_kullanim_06 = veri;
//            },
//            // Klavyedeki Gönder(Bitti) tuşuna basınca çalışır
//            onSubmitted: (veri) {
//              ilac_kullanim_06 = veri;
//            },
//          ),

          Center(
              child: RaisedButton(
                  child: Text("Yeni İlaç Ekle"),
                  // Navigator.pop ile bir önceki sayfaya dönücek
                  onPressed: ()   async {
                    print(ilac_kullanim_tipi);
                    Ilac yeni = Ilac(ilac_adi: ilac_adi, ilac_aciklama: ilac_aciklama,
                    ilac_kullanim_tipi: ilac_kullanim_tipi,blocked: true);
                    await DBHelper().newIlac(yeni);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: Text("İlaç Ekleme İşlemi"),
                              content: Text("Başarılı"),
                              actions :<Widget>[ FlatButton(
                                child: Text("Kapat"),
                                onPressed: (){
                                  Navigator.of(context).pop();
                                },
                              )
                              ]
                          );
                        }
                    );

                  }
                //onPressed: () => Navigator.pop(context),
              )),
        ],
      ),
    );
  }


}
