// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import '../framework/storefactory.dart';
import '../components/inventory_list.dart';
import '../framework/model.dart';
import 'add_edit_inventory.dart';
import '../inventory/inventorymodel.dart';
import '../inventory/units.dart';
import 'package:random_words/random_words.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  List<Model> _models = List<Model>();
  VoidCallback oldCallbackFn;
  List<WordNoun> nouns = generateNoun().take(1000000).toList();

  void onStoreChanged() {
    StoreFactory().get("InventoryModel").load().then((records) {
      setState(() {
        this._models = records;
      });
    });
  }

  void _updateCallbackAndListen() {
    // if (null != oldCallbackFn) {
    //   StoreFactory().get("InventoryModel").removeListener(oldCallbackFn);
    //   oldCallbackFn = null;
    // }

    oldCallbackFn = this.onStoreChanged;
    StoreFactory().get("InventoryModel").addListener(oldCallbackFn);
  }

  @override
  didUpdateWidget(Widget oldWidget) {
    _updateCallbackAndListen();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    _updateCallbackAndListen();
    super.initState();
  }

  @override
  void dispose() {
    StoreFactory().get("InventoryModel").removeListener(onStoreChanged);
    super.dispose();
  }

  void _addBulkData() async {
    var store = StoreFactory().get("InventoryModel");

    store.suspendEvents();
    store.beginTransaction();

    int count = 100000;

    for (var i = 0; i < count; i++) {
      InventoryModel m = new InventoryModel();
      m.recurrence = Recurrence.values[i % 4];
      m.unit = Unit.values[i % 5];
      m.itemName = nouns[i].word;
      m.costPerUnit = (i % 100).toDouble();
      m.currentQuantity = i.toDouble();
      m.requiredQuantity = i * 2.toDouble();

      await m.save();
    }
    store.endTransaction();

    // Commit all pending at once.
    await store.commit(); // Async task, you can use sync one if wanted.
    store.resumeEvents();
  }

  Widget _getBodyWidget() {
    if (StoreFactory().get("InventoryModel").isLoaded == false) {
      return Center(
        child: CircularProgressIndicator(
          key: Key("loading_home_page"),
        ),
      );
    } else {
      return StoreFactory().get("InventoryModel").count == 0
          ? Center(
              child: Text(
                "Your inventory is empty. Please add some items to inventory.",
                textAlign: TextAlign.center,
              ),
            )
          : InventoryList(StoreFactory().get("InventoryModel"), this._models,
              "HomeInventoryList");
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Home Inventory", textScaleFactor: 1),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.library_add),
            onPressed: () {
              _addBulkData();
            },
          ),
          PopupMenuButton(
            itemBuilder: (BuildContext context) => [
                  PopupMenuItem(
                    child: Text("Remove All"),
                    value: 0,
                  )
                ],
            onSelected: (val) {
              if (val == 0) {
                StoreFactory().get("InventoryModel").removeAll();
              }
            },
          )
        ],
      ),
      body: _getBodyWidget(),
      floatingActionButton: FloatingActionButton(
        key: Key("AddToInventory"),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return new AddEditInventory(null);
          }));
        },
        child: Icon(Icons.add),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                "Stats",
                textScaleFactor: 1.25,
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/stats");
              },
            )
          ],
        ),
      ),
    );
  }
}
