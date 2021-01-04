import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyDrawerState();
}

class _MyDrawerState extends State {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Align(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.add_to_home_screen,
                    color: Colors.white,
                    size: 100.0,
                  ),
                  Text(
                    "İlaç Takip Uygulaması",
                    style: TextStyle(color: Colors.white, fontSize: 25.0),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),

          ListTile(
            leading: Icon(Icons.home),
            title: Text('Anasayfa'),
            trailing: Icon(Icons.arrow_right),
            onTap: () {
              Navigator.pushNamed(context, "/");
            },
          ),

          ExpansionTile(
            leading: Icon(Icons.perm_device_information),
            title: Text('İlaç İşlemleri'),
            trailing: Icon(Icons.arrow_drop_down),
            children: <Widget>[
              ListTile(
                title: Text('İlaç Listem'),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  Navigator.pushNamed(context, "/ilaclistesi");
                },
              ),
              ListTile(
                title: Text('İlaç Ekle'),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  Navigator.pushNamed(context, "/ilacekle");
                },
              ),
            ],
          ),

          ListTile(
            leading: Icon(Icons.local_laundry_service),
            title: Text('İlaç Kullanım Raporlarım'),
            trailing: Icon(Icons.arrow_right),
            onTap: () {
              Navigator.pushNamed(context, "/raporlar");
            },
          ),



        ],
      ),
    );
  }
}