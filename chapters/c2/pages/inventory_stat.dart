// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:eventify/eventify.dart';
import 'package:flutter/material.dart';
import '../framework/model.dart';
import '../framework/storefactory.dart';
import '../inventory/inventorymodel.dart';

class InventoryStat extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _InventoryStatState();
  }
}

class _InventoryStatState extends State<InventoryStat> {
  List<Model> _models = List<Model>();
  int _totalInventoryItems = 0;
  double _totalSum = 0.0;

  void onStoreChanged(Event ev, Object context) {
    StoreFactory().get("InventoryModel").load().then((models) {
      setState(() {
        // Perform any operations needed, if any!
        // We might need to update the notification bar or icons etc
        // based on the items available.
        // Or, we might need to consolidate the total inventory here
        // and use that when we display drawer or other widgets.
        this._updateState(models);
      });
    });
  }

  @override
  void initState() {
    // Subscribe to events.
    StoreFactory().get("InventoryModel").on("onload", this, onStoreChanged);
    StoreFactory().get("InventoryModel").on("onsave", this, onStoreChanged);

    // At times, it takes a while to load data, let's make sure that data is loaded.
    if (this._models.length == 0 &&
        StoreFactory().get("InventoryModel").count > 0) {
      // Some heavy operation is happening in store, so it won't send event's immediately. Let's fetch cached records insted.
      StoreFactory().get("InventoryModel").load().then((records) {
        setState(() {
          this._updateState(records);
        });
      });
    }

    super.initState();
  }

  void _updateState(List<Model> records) {
    this._models = records;
    this._totalInventoryItems = this._models.length;
    this._models.forEach((m) => _totalSum +=
        ((m as InventoryModel).costPerUnit *
            (m as InventoryModel).currentQuantity));
  }

  didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    StoreFactory().get("InventoryModel").removeAllByCallback(onStoreChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: Key("inventory_stat"),
        appBar: AppBar(
          title: Text("Inventory Stats"),
        ),
        body: Center(
          child: Builder(builder: (context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "Total Inventory",
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    '$_totalInventoryItems',
                    key: Key("totalInventoryItems"),
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "Total Sum",
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    "$_totalSum",
                    key: Key("totalSum"),
                    style: Theme.of(context).textTheme.subhead,
                  ),
                )
              ],
            );
          }),
        ));
  }
}
