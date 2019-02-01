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
import '../framework/core/profiler.dart';
import '../framework/core/profiler_data.dart';
import 'package:eventify/eventify.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  List<Model> _models = List<Model>();
  List<WordNoun> nouns = generateNoun().take(1000000).toList();

  void onStoreChanged(Event ev, Object context) {
    if (ev.eventName == "onsave" || ev.eventName == "onload") {
      Profiler.instance
          .add(new ProfilerData("HomePage", "onStoreChanged", DateTime.now()));

      Profiler.instance.print();
      Profiler.instance.stop();
      if (this.mounted) {
        _loadRecords();
      }
    }
    debugPrint("Event ${ev.eventName} received");
  }

  void _loadRecords() {
    StoreFactory().get("InventoryModel").load().then((records) {
      debugPrint("_loadRecords - records count - ${records.length}");
      setState(() {
        this._models = records;
      });
    });
  }

  @override
  didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    // Load records , then attach listeners, to avoid duplicate load events.

    StoreFactory().get("InventoryModel").on("onsave", this, onStoreChanged);
    StoreFactory().get("InventoryModel").on("onload", this, onStoreChanged);

    super.initState();
  }

  @override
  void dispose() {
    StoreFactory().get("InventoryModel").removeAllByCallback(onStoreChanged);
    super.dispose();
  }

  Future _addBulkData() async {
    var store = StoreFactory().get("InventoryModel");

    store.suspendEvents();
    store.beginTransaction();

    int count = 100000;

    Profiler.instance.start();
    Profiler.instance
        .add(new ProfilerData("HomePage", "Start Bulk Import", DateTime.now()));

    for (var i = 0; i < count; i++) {
      InventoryModel m = new InventoryModel();
      m.recurrence = Recurrence.values[i % 4];
      m.unit = Unit.values[i % 5];
      m.itemName = nouns[i].word;
      m.costPerUnit = (i % 100).toDouble();
      m.currentQuantity = i.toDouble();
      m.requiredQuantity = i * 2.toDouble();

      store.add(m);
      // m.save();
    }

    Profiler.instance
        .add(new ProfilerData("HomePage", "Stop Bulk Import", DateTime.now()));

    store.endTransaction();

    // Commit all pending at once.
    store.commit(); // Async task, you can use sync one if wanted.
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
