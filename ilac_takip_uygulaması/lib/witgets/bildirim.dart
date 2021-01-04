import 'dart:isolate';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LocalNotifications(),
    );
  }
}

class LocalNotifications extends StatefulWidget {
  @override
  _LocalNotificationsState createState() => _LocalNotificationsState();
}

class _LocalNotificationsState extends State<LocalNotifications> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;

  @override
  void initState() {
    super.initState();
    initializing();

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
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              color: Colors.blue,
              onPressed: _showNotifications,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Show Notification",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
            ),
            FlatButton(
              color: Colors.blue,
              onPressed: _showNotificationsAfterSecond,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Show Notification after few sec",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
            ),
            FlatButton(
              color: Colors.blue,
              onPressed: _alarmcaslitir,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "alarm çalıştır",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
            ),
            FlatButton(
              color: Colors.blue,
              onPressed: _showNotificationsEveryDay,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Tekrarla",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
