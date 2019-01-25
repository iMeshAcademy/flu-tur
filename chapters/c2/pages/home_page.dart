// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:fluttur/inventory/storefactory.dart';
import 'package:fluttur/inventory/model.dart';
import "package:fluttur/components/inventory_list.dart";
import 'package:fluttur/pages/add_edit_inventory.dart';
import 'package:fluttur/inventory/inventorymodel.dart';
import 'package:fluttur/inventory/units.dart';
import 'package:random_words/random_words.dart';

// This is the home page of the application.
// At present, this will have only one

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _HomePageState(); // Just return the new state.
  }
}

class _HomePageState extends State<HomePage> {
  List<Model> _models = List<Model>();
  VoidCallback oldCallbackFn;

  void onStoreChanged() {
    StoreFactory().get("InventoryModel").load().then((models) {
      setState(() {
        // Perform any operations needed, if any!
        // We might need to update the notification bar or icons etc
        // based on the items available.
        // Or, we might need to consolidate the total inventory here
        // and use that when we display drawer or other widgets.
        this._models = models;
      });
    });
  }

  void _updateCallbackAndListen() {
    if (null != oldCallbackFn) {
      StoreFactory().get("InventoryModel").removeListener(oldCallbackFn);
      oldCallbackFn = null;
    }

    oldCallbackFn = this.onStoreChanged;
    StoreFactory().get("InventoryModel").addListener(oldCallbackFn);
  }

  @override
  void initState() {
    // Subscribe to events.
    _updateCallbackAndListen();
    super.initState();
  }

  didUpdateWidget(Widget oldWidget) {
    _updateCallbackAndListen();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    StoreFactory().get("InventoryModel").removeListener(oldCallbackFn);
    oldCallbackFn = null;
    super.dispose();
  }

  void _addBulkData() async {
    var store = StoreFactory().get("InventoryModel");

    store.suspendEvents();
    store.beginTransaction();

    int count = 1000;
    List<WordNoun> nouns = generateNoun().take(count).toList();

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

  // Build could be called immediately after deactivation or activation.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Inventory Application"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.library_add),
            onPressed: _addBulkData,
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
      body: StoreFactory().get("InventoryModel").count == 0
          ? Center(
              child: Text(
                "Your inventory is empty. Please add some items to inventory.",
                textAlign: TextAlign.center,
              ),
            )
          : InventoryList(StoreFactory().get("InventoryModel"), this._models,
              "HomeInventoryList"),
      floatingActionButton: FloatingActionButton(
        key: Key("AddToInventory"),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return AddEditInventory(null);
          }));
        },
        child: Icon(Icons.add),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text("Stats"),
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
