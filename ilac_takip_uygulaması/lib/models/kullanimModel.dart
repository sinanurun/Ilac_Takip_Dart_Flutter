import 'dart:convert';
/// kullanimModel.dart
Kullanim kullanimFromJson(String str) {
  final jsonData = json.decode(str);
  return Kullanim.fromMap(jsonData);
}

String kullanimToJson(Kullanim data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Kullanim {
  int kullanim_id;
  int ilac_id;
  String ilac_adi;
  String ilac_kullanim_tarihi;
  String ilac_bildirim_zamani;
  String ilac_kullanim_zamani;
  bool blocked;



  Kullanim({
    // ignore: non_constant_identifier_names
    this.kullanim_id,
    this.ilac_id,
    this.ilac_adi,
    this.ilac_kullanim_tarihi, // 07-05-2020
    this.ilac_bildirim_zamani, // Sabah ya Öğlen ya da Akşam
    this.ilac_kullanim_zamani, // 07-05-2020 15:20
    this.blocked,

  });

  // gelen map verisini json'a dönüştürür
  factory Kullanim.fromMap(Map<String, dynamic> json) => new Kullanim(
    kullanim_id: json["kullanim_id"],
    ilac_id: json["ilac_id"],
    ilac_adi: json["ilac_adi"],
    ilac_kullanim_tarihi: json["ilac_kullanim_tarihi"],
    ilac_bildirim_zamani: json["ilac_bildirim_zamani"],
    ilac_kullanim_zamani: json["ilac_kullanim_zamani"],
    blocked: json["blocked"]==1,
  );

  // gelen json' verisini Map'e dönüştürür
  Map<String, dynamic> toMap() => {
    "kullanim_id":kullanim_id,
    "ilac_id": ilac_id,
    "ilac_adi":ilac_adi,
    "ilac_kullanim_tarihi":ilac_kullanim_tarihi,
    "ilac_bildirim_zamani": ilac_bildirim_zamani,
    "ilac_kullanim_zamani": ilac_kullanim_zamani,
    "blocked": blocked,
  };
}