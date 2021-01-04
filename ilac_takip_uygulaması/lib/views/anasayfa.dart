import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:local_notifications/models/kullanimModel.dart';
import 'package:local_notifications/witgets/myDrawer.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:local_notifications/models/dbhelper.dart';
import 'package:local_notifications/models/ilacModel.dart';


// günlük ilaç eklenmesi
import 'package:schedule_controller/schedule_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
//günlük bildirim için
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';


class Anasayfa extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>_AnasayfaState();
}


class _AnasayfaState extends State<Anasayfa>{
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;

  ScheduleController controller;

  Future get(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(12);
    return prefs.get(key);
  }

  Future save(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
    print(13);
  }

  void _yenigunkullanimiekle() async {
    await yenigunkullanimiekle();
  }

  void yenigunkullanimiekle() async {
    await DBHelper().kullanimEkle();
  }


  @override
  void initState() {
    super.initState();
    initializing();
    controller = ScheduleController([
      Schedule(
        timeOutRunOnce: true,
        timing: [1],//gece saat 01 de yeni kullanımlar oluşturacak
        readFn: () async => await get('schedule'),
        writeFn: (String data) async {
          debugPrint(data);
          _yenigunkullanimiekle();
          await save('schedule', data);
        },
        callback: () async{
          _yenigunkullanimiekle();
          debugPrint('schedule');
        },
      ),
    ]);
    controller.run();
    _showNotificationsEveryDay();
  }

  void initializing() async {
    androidInitializationSettings = AndroidInitializationSettings('app_icon');
    iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  void _showNotifications() async {
    await notification();
  }

  void _showNotificationsAfterSecond() async {
    await notificationAfterSec();
  }
  //hergün bildirim yapacak
  void _showNotificationsEveryDay() async {
    await showNotificationsEveryDay();
  }

  void _printHello() async {
    final DateTime now = DateTime.now();
    final int isolateId = Isolate.current.hashCode;
    print("[$now] Hello, world! isolate=${isolateId} function='$_printHello'");
  }

  Future<void> _alarmcaslitir() async {
    final DateTime now = DateTime.now();
    print(now);
    final int helloAlarmID = 0;
    await AndroidAlarmManager.initialize();
    await AndroidAlarmManager.periodic(const Duration(minutes: 1), helloAlarmID, _printHello);
//    await AndroidAlarmManager.periodic(const Duration(days: 1), id, callback)
  }


  Future<void> notification() async {
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'Channel ID', 'Channel title', 'channel body',
        priority: Priority.High,
        importance: Importance.Max,
        ticker: 'test');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
    NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0, 'Hello there', 'please subscribe my channel', notificationDetails);
  }

  Future<void> notificationAfterSec() async {
    var timeDelayed = DateTime.now().add(Duration(seconds: 5));
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'second channel ID', 'second Channel title', 'second channel body',
        priority: Priority.High,
        importance: Importance.Max,
        ticker: 'test');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
    NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.schedule(0, 'Hello there',
        'please subscribe my channel', timeDelayed, notificationDetails);
  }

  Future onSelectNotification(String payLoad) {
    if (payLoad != null) {
      print(payLoad);
    }

    // we can set navigator to navigate another screen
  }

  Future<void> showNotificationsEveryDay() async {

    AndroidNotificationDetails androidNotificationDetails =AndroidNotificationDetails('repeating channel id',
        'repeating channel name', 'repeating description');
    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(androidNotificationDetails, iosNotificationDetails);
//    await flutterLocalNotificationsPlugin.periodicallyShow(0, 'repeating title',
//        'repeating body', RepeatInterval.EveryMinute, notificationDetails);
    var time1 = Time(8,0,0); //ilk bildirim saati
    var time2 = Time(12,0,0); // ikinci bildirim saati
    var time3 = Time(18,0,0); //üçüncü bildirim saati
    flutterLocalNotificationsPlugin.showDailyAtTime(
        0,
        'Sabah İlaçları',
        'Sabah İlaçlarınızı Almayıunutmayınız',
        time1,
        notificationDetails);
    flutterLocalNotificationsPlugin.showDailyAtTime(
        1,
        'Öğlen İlaçları',
        'Öğlen İlaçlarınızı Almayı Unutmayınız',
        time2,
        notificationDetails);
    flutterLocalNotificationsPlugin.showDailyAtTime(
        2,
        'Akşam İlaçları',
        'Akşam İlaçlarınızı Almayı Unutmayınız',
        time3,
        notificationDetails);

  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              print("Gerçekleştirildi");
            },
            child: Text("Tamamlandı")),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bugün Almanız Gereken İlaçlar")),
      drawer: MyDrawer(),
      // FutureBuilder ile listemize bağlandık
      body: new Builder(
          builder: (BuildContext context) {
            return Column(

              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: FutureBuilder<List<Kullanim>>(

                    // future olarak database sınıfımızdaki bütün kelimeleri getir
                    // adlı methodunu verdik
                    future: DBHelper().gunlukKullanilanilaclar("Sabah"),
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
                              child: Container(
                                decoration: BoxDecoration(color: Colors.amberAccent, border: Border.all()),
                                margin: const EdgeInsets.all(5.0),
                                padding: const EdgeInsets.all(5.0),
                                  child:ListTile(

                                    title: Text(item.ilac_adi,style: TextStyle(fontWeight: FontWeight.bold)),
                                    subtitle: RichText(
                                      text: TextSpan(
                                        text: item.ilac_kullanim_tarihi,
                                        style: DefaultTextStyle.of(context).style,
                                        children: <TextSpan>[
                                          TextSpan(text: ' / ', style: TextStyle(fontSize:20, fontWeight: FontWeight.bold)),
                                          TextSpan(text: item.ilac_bildirim_zamani),
                                        ],
                                      ),
                                    ),

                                    leading: Text("Sabah", textAlign: TextAlign.center,

                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.redAccent,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold), ),
//                                trailing: Checkbox(
//                                  onChanged: (bool value) {
//                                    DBHelper().kullanimblockOrUnblock(item);
//                                    setState(() {});
//                                  },
//                                  value: item.blocked,
//                                ),
                              ),),
                            );
                          },
                        );
                        // veri yok ise ekran ortasında dönen progressindicator göster
                      } else {
                        return Center(child:
                        Text(" Sabah Almanız Gereken Bir İlaç Bulunmamaktadır"),);
                      }
                    },
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: FutureBuilder<List<Kullanim>>(
                    // future olarak database sınıfımızdaki bütün kelimeleri getir
                    // adlı methodunu verdik
                    future: DBHelper().gunlukKullanilanilaclar("Öğlen"),
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
                            child:Container(
                              margin: const EdgeInsets.all(5.0),
                              padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(color: Colors.greenAccent, border: Border.all()),
                            child:ListTile(
                                title: Text(item.ilac_adi,style: TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: RichText(
                                  text: TextSpan(
                                    text: item.ilac_kullanim_tarihi,
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      TextSpan(text: ' / ', style: TextStyle(fontSize:20, fontWeight: FontWeight.bold)),
                                      TextSpan(text: item.ilac_bildirim_zamani),
                                    ],
                                  ),
                                ),

                                leading: Text("Öğlen", textAlign: TextAlign.center,

                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.redAccent,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold), ),
//                                trailing: Checkbox(
//                                  onChanged: (bool value) {
//                                    DBHelper().kullanimblockOrUnblock(item);
//                                    setState(() {});
//                                  },
//                                  value: item.blocked,
//                                ),
                              ),
                            )
                            );
                          },
                        );
                        // veri yok ise ekran ortasında dönen progressindicator göster
                      } else {
                        return Center(child:
                        Text("Öğlen Almanız Gereken Bir İlaç Bulunmamaktadır"),);
                      }
                    },
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: FutureBuilder<List<Kullanim>>(
                    // future olarak database sınıfımızdaki bütün kelimeleri getir
                    // adlı methodunu verdik
                    future: DBHelper().gunlukKullanilanilaclar("Akşam"),
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

                              child: Container(
                                margin: const EdgeInsets.all(5.0),
                                padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(color: Colors.cyanAccent, border: Border.all()),
                            child:ListTile(
                                title: Text(item.ilac_adi,style: TextStyle(fontSize:20, fontWeight: FontWeight.bold)),
                                subtitle: RichText(
                                  text: TextSpan(
                                    text: item.ilac_kullanim_tarihi,
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      TextSpan(text: ' / ', style: TextStyle(fontWeight: FontWeight.bold)),
                                      TextSpan(text: item.ilac_bildirim_zamani),
                                    ],
                                  ),
                                ),

                                leading: Text("Akşam", textAlign: TextAlign.center,

                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.redAccent,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold), ),
//                                trailing: Checkbox(
//                                  onChanged: (bool value) {
//                                    DBHelper().kullanimblockOrUnblock(item);
//                                    setState(() {});
//                                  },
//                                  value: item.blocked,
//                                ),
                              ),),
                            );
                          },
                        );
                        // veri yok ise ekran ortasında dönen progressindicator göster
                      } else {
                        return Center(child:
                        Text("Akşam Almanız Gereken Bir İlaç Bulunmamaktadır"),);
                      }
                    },
                  ),
                ),

              ],
            );
          }
      )
    );
  }
}

