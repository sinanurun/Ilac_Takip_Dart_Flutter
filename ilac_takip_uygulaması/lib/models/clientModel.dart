import 'dart:convert';
/// IlacModel.dart
Ilac ilacFromJson(String str) {
  final jsonData = json.decode(str);
  return Ilac.fromMap(jsonData);
}

String ilacToJson(Ilac data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Ilac {
  int ilac_id;
  String ilac_adi;
  String ilac_aciklama;
  String ilac_kullanim_01;
  String ilac_kullanim_02;
  String ilac_kullanim_03;
  String ilac_kullanim_04;
  String ilac_kullanim_05;
  String ilac_kullanim_06;
  bool blocked;


  Ilac({
    // ignore: non_constant_identifier_names
    this.ilac_id,
    this.ilac_adi,
    this.ilac_aciklama,
    this.ilac_kullanim_01,
    this.ilac_kullanim_02,
    this.ilac_kullanim_03,
    this.ilac_kullanim_04,
    this.ilac_kullanim_05,
    this.ilac_kullanim_06,
    this.blocked,
  });

  // gelen map verisini json'a dönüştürür
  factory Ilac.fromMap(Map<String, dynamic> json) => new Ilac(
    ilac_id: json["ilac_id"],
    ilac_adi: json["ilac_adi"],
    ilac_aciklama: json["ilac_aciklama"],
    ilac_kullanim_01: json["ilac_kullanim_01"],
    ilac_kullanim_02: json["ilac_kullanim_02"],
    ilac_kullanim_03: json["ilac_kullanim_03"],
    ilac_kullanim_04: json["ilac_kullanim_04"],
    ilac_kullanim_05: json["ilac_kullanim_05"],
    ilac_kullanim_06: json["ilac_kullanim_06"],
    blocked: json["blocked"] == 1,
  );

  // gelen json' verisini Map'e dönüştürür
  Map<String, dynamic> toMap() => {
    "ilac_id": ilac_id,
    "ilac_adi": ilac_adi,
    "ilac_aciklama": ilac_aciklama,
    "ilac_kullanim_01": ilac_kullanim_01,
    "ilac_kullanim_02": ilac_kullanim_02,
    "ilac_kullanim_03": ilac_kullanim_03,
    "ilac_kullanim_04": ilac_kullanim_04,
    "ilac_kullanim_05": ilac_kullanim_05,
    "ilac_kullanim_06": ilac_kullanim_06,
    "blocked": blocked,
  };
}