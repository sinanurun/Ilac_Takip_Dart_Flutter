import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import '../models/ilacModel.dart';
import '../models/kullanimModel.dart';
import 'package:schedule_controller/schedule_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';


class DBHelper {
  /// Dabase'imizi ilgili konuma oluşturup, oluşturduğu database'i istediğimizde dönen method
  static Future<Database> database() async {
    // işletim sistemine göre varsayılan database oluşturabileceğimiz konumu alacak
    final dbPath = await getDatabasesPath();
    // mobil_ilac_uygulamasi isminde database tablelar oluşturacak ilacSql komutumuzu tutan değişken
    // karışık görünmesin diye buraya yazdım, execute ederken kullanıcaz
    const ilacSQL = "CREATE TABLE Ilac ("
        "ilac_id INTEGER PRIMARY KEY,"
        "ilac_adi TEXT,"
        "ilac_aciklama TEXT,"
        "ilac_kullanim_tipi TEXT,"
//        "ilac_kullanim_02 TEXT,"
//        "ilac_kullanim_03 TEXT,"
//        "ilac_kullanim_04 TEXT,"
//        "ilac_kullanim_05 TEXT,"
//        "ilac_kullanim_06 TEXT,"
        "blocked BIT"
        ")";
    const kullanimSQL = "CREATE TABLE Kullanim ("
        "kullanim_id INTEGER PRIMARY KEY,"
        "ilac_id INTEGER,"
        "ilac_adi TEXT,"
        "ilac_kullanim_tarihi TEXT,"
        "ilac_bildirim_zamani TEXT," // sabah - öğlen - akşam
        "ilac_kullanim_zamani TEXT," // ilaçı aldığı saat
        "blocked BIT,"
    "UNIQUE(ilac_id,ilac_kullanim_tarihi,ilac_bildirim_zamani),FOREIGN KEY(ilac_id) REFERENCES Ilac(ilac_id)"//aynı kullanımın tekrar etmemesi için
        ")";

    // ve SqlFlite ile gelen openDatabase methodu ile database'i oluşturup onu dönüyoruz.
    return openDatabase(
      // database'in oluşturulacağı konum; yukarıda aldığımız varsayalın database konumu ve
      // oluşturmak istediğimiz isimde dosyamızın adını verip, o konuma o isimde oluşturmasını istedik
      join(dbPath, "mobil_ilac_uygulamasi.db"),// -> 'varsayılanKonum/TestDb.db'
      // verdiğimiz SQL komutu ve version numarası ile database'imizi oluşturmasını istedik
      onCreate: (db, version) async { await db.execute(ilacSQL); db.execute(kullanimSQL);

      },
      version: 1,
    );
  }

  //Temel İlaç İşlemler Ekleme Silme Listeleme ve güncelleme

        /// Yeni ilaç kaydı oluşturuması
        newIlac(Ilac newIlac) async {
          final db = await database();
          // Ilac isimli tabloya parametre olarak verdiğimiz yeni ilacı
          // map'e çevir ve database()'imize ekle
          var sonuc = await db.insert("Ilac", newIlac.toMap());
          // geri dönüş değerini dönder, ekleme olumlu olursa, eklendi "id"'yi dönecek
          // ilaç oluşturulunca kullanım durumuna göre her gün kullanım tablosuna otomatik olarak kullanım ekleyecek
          await kullanimEkle();
          return sonuc;
        }

        /// Verilen "ilac_id" değerine göre ilaci getir
        getIlac(int ilac_id) async {
          final db = await database();
          var sonuc = await db.query("Ilac", where: "ilac_id = ?", whereArgs: [ilac_id]);
          return sonuc.isNotEmpty ? Ilac.fromMap(sonuc.first) : Null;
        }

        /// bütün ilaçları getir
        Future<List<Ilac>> getAllIlaclar() async {
          final db = await database();
          var sonuc = await db.query("Ilac");
          List<Ilac> list =
          sonuc.isNotEmpty ? sonuc.map((c) => Ilac.fromMap(c)).toList() : [];
          return list;
        }

        /// sadece bloklanmış ilaçlari liste şeklinde dönecek
        Future<List<Ilac>> getBlockedIlac() async {
          final db = await database();
          var sonuc = await db.query("Ilac", where: "blocked = ? ", whereArgs: [1]);
          List<Ilac> list =
          sonuc.isNotEmpty ? sonuc.map((c) => Ilac.fromMap(c)).toList() : [];
          return list;
        }

        /// Karışık ilaçlari Getirecek
        /*Future<List<Ilac>> getRandomIlaclar() async {
          final db = await database();
          Random random = Random();
          var sonuc = await db.query("Ilac",orderBy: "random()", limit: 5);

          List<Ilac> list =
          sonuc.isNotEmpty ? sonuc.map((c) => Ilac.fromMap(c)).toList() : [];
          return list;
        }*/

        /// var olan ilaci günceller
        updateIlac(Ilac newIlac) async {
          final db = await database();
          var sonuc = await db.update("Ilac", newIlac.toMap(),
              where: "ilac_id = ?", whereArgs: [newIlac.ilac_id]);
          return sonuc;
        }

        /// Verilen ilaci bloklar veya açar
        blockOrUnblock(Ilac ilac) async {
          final db = await database();
          Ilac blocked = Ilac(
              ilac_id: ilac.ilac_id,
              ilac_adi: ilac.ilac_adi,
              ilac_aciklama: ilac.ilac_aciklama,
              ilac_kullanim_tipi: ilac.ilac_kullanim_tipi,
//              ilac_kullanim_02: ilac.ilac_kullanim_02,
//              ilac_kullanim_03: ilac.ilac_kullanim_03,
//              ilac_kullanim_04: ilac.ilac_kullanim_04,
//              ilac_kullanim_05: ilac.ilac_kullanim_05,
//              ilac_kullanim_06: ilac.ilac_kullanim_06,
              blocked:!ilac.blocked);
          var sonuc = await db.update("Ilac", blocked.toMap(),
              where: "ilac_id = ?", whereArgs: [ilac.ilac_id]);
          return sonuc;
        }

        /// verilen ilac_id değerine göre ilaci siler
        /// silnen ilaca bağlı olarak ayrıca kullanım tablosunda o ilaçla iligli tutulan bilgilerde silinecektir
        deleteIlac(int ilac_id) async {
          final db = await database();
          db.delete("Ilac", where: "ilac_id = ?", whereArgs: [ilac_id]);
          db.delete("Kullanim", where: "ilac_id = ?", whereArgs: [ilac_id]);
        }

        /// bütün ilaçları ve kullanım bilgilerini siler
        deleteAll() async {
          final db = await database();
          db.rawDelete("Delete from Ilac");
          db.rawDelete("Delete from Kullanim");
        }


// Temel ilaç kullanım işlemleri

        kullanimEkle() async{
          final db = await database();
          var ilaclistesi = await getAllIlaclar();
          List _kullanimtipleri = ["Sabah - Öğlen - Akşam", "Sabah - Akşam", "Sabah", "Akşam", "Öğlen"];
          var now = new DateTime.now();
          var formatter = new DateFormat('dd-MM-yyyy');
          String formatted = formatter.format(now);

          for ( var ilac in ilaclistesi){
            int id = ilac.ilac_id;
            if ((ilac.ilac_kullanim_tipi == _kullanimtipleri[0]) || (ilac.ilac_kullanim_tipi ==_kullanimtipleri[1]) || (ilac.ilac_kullanim_tipi == _kullanimtipleri[2])){
              Kullanim sabah = Kullanim(ilac_id: id, ilac_adi: ilac.ilac_adi, ilac_kullanim_tarihi: formatted,ilac_bildirim_zamani: "Sabah", blocked: false);

              try {
                await newKullanim(sabah);
              }
          catch(e) {
          print('Hatalı işlem');
          }

            }
            if ((ilac.ilac_kullanim_tipi == _kullanimtipleri[0]) || (ilac.ilac_kullanim_tipi == _kullanimtipleri[4])){
              Kullanim oglen = Kullanim(ilac_id: id, ilac_adi: ilac.ilac_adi, ilac_kullanim_tarihi: formatted,ilac_bildirim_zamani: "Öğlen", blocked: false);
              try {
                await newKullanim(oglen);
              }
              catch(e) {
                print('Hatalı işlem');
              }
            }
            if ((ilac.ilac_kullanim_tipi == _kullanimtipleri[0]) || (ilac.ilac_kullanim_tipi == _kullanimtipleri[1] )|| (ilac.ilac_kullanim_tipi == _kullanimtipleri[3])){
              Kullanim aksam = Kullanim(ilac_id: id, ilac_adi: ilac.ilac_adi, ilac_kullanim_tarihi: formatted,ilac_bildirim_zamani: "Akşam", blocked: false);
              try {
                await newKullanim(aksam);
              }
              catch(e) {
                print('Hatalı işlem');
              }
            }
              
          }


        }

        /// Yeni kullanim Kayıt
        newKullanim(Kullanim newKullanim) async {
          final db = await database();
          // Kullanım isimli tabloya parametre olarak verdiğimiz yeni kullanımı
          // map'e çevir ve database()'imize ekle
          var sonuc = await db.insert("Kullanim", newKullanim.toMap());
          // geri dönüş değerini dönder, ekleme olumlu olursa, eklendi "kullanim_id"'yi dönecek
          return sonuc;
        }

        /// bütün kullanımları getirir
        Future<List<Kullanim>> getAllKullanimlar() async {
          final db = await database();
          var sonuc = await db.query("Kullanim");
          List<Kullanim> list =
          sonuc.isNotEmpty ? sonuc.map((c) => Kullanim.fromMap(c)).toList() : [];
          return list;
        }

        /// Verilen "ilac_id" değerine göre kullanımları getir
        getKullanilanilac(int ilac_id) async {
          final db = await database();
          var sonuc = await db.query("Kullanim", where: "ilac_id = ?", whereArgs: [ilac_id]);
          List<Kullanim> list =
          sonuc.isNotEmpty ? sonuc.map((c) => Kullanim.fromMap(c)).toList() : [];
          return list;
        }

        /// günlük kullanılacak olan ilaçları listeler
        Future<List<Kullanim>> gunlukKullanilanilaclar(String ogun) async {

          final db = await database();
          var now = new DateTime.now();
          var formatter = new DateFormat('dd-MM-yyyy');
          String formatted = formatter.format(now);

          var sonuc = await db.query("Kullanim", where: "ilac_kullanim_tarihi = ? and blocked = ? and ilac_bildirim_zamani = ?",
              whereArgs: [formatted,0,ogun]);
          List<Kullanim> list =
          sonuc.isNotEmpty ? sonuc.map((c) => Kullanim.fromMap(c)).toList() : [];
          return list;
        }

        /// var olan ilac kullanını günceller
        updateKullanim(Kullanim newKullanim) async {
          final db = await database();
          var sonuc = await db.update("Kullanim", newKullanim.toMap(),
              where: "kullanim_id = ?", whereArgs: [newKullanim.kullanim_id]);
          return sonuc;
        }

        /// Verilen kullanımı güncelle bloklar veya açar
        kullanimblockOrUnblock(Kullanim kullanim) async {

          var now = new DateTime.now();
          var formatter = new DateFormat('dd-MM-yyyy').add_Hm();
          String formatted = formatter.format(now);

          final db = await database();
          Kullanim blocked = Kullanim(
            kullanim_id: kullanim.kullanim_id,
              ilac_id: kullanim.ilac_id,
              ilac_adi: kullanim.ilac_adi,
              ilac_kullanim_tarihi: kullanim.ilac_kullanim_tarihi,
              ilac_bildirim_zamani: kullanim.ilac_bildirim_zamani,
              ilac_kullanim_zamani: formatted,
              blocked:!kullanim.blocked);
          var sonuc = await db.update("Kullanim", blocked.toMap(),
              where: "kullanim_id = ?", whereArgs: [kullanim.kullanim_id]);
          return sonuc;
        }



}