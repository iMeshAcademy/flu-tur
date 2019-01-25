// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttur/inventory/storage/filestorage.dart';
import 'package:fluttur/inventory/storefactory.dart';
import 'package:fluttur/pages/home_page.dart';
import 'package:fluttur/pages/inventory_stat.dart';

void main() {
  Map<String, Object> config = {
    "modelName": "InventoryModel",
    "storage":
        const FileStorage("inventory.json", getApplicationDocumentsDirectory)
  };

  StoreFactory().configure(config);
  runApp(MyApp()); 
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      routes: {
        "/": (context) => HomePage(),
        "/stats": (context) => InventoryStat()
      },
    );
  }
}
