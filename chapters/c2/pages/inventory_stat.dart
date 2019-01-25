import 'package:flutter/material.dart';
import 'package:fluttur/inventory/model.dart';
import 'package:fluttur/inventory/storefactory.dart';
import 'package:fluttur/inventory/inventorymodel.dart';

class InventoryStat extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _InventoryStatState();
  }
}

class _InventoryStatState extends State<InventoryStat> {
  VoidCallback oldCallbackFn;
  List<Model> _models = List<Model>();

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

    // At times, it takes a while to load data, let's make sure that data is loaded.
    if (this._models.length == 0 &&
        StoreFactory().get("InventoryModel").count > 0) {
      // Some heavy operation is happening in store, so it won't send event's immediately. Let's fetch cached records insted.
      StoreFactory().get("InventoryModel").load().then((records) {
        setState(() {
          this._models = records;
        });
      });
    }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: Key("inventory_stat"),
        appBar: AppBar(
          title: Text("Inventory Stats"),
        ),
        body: Center(
          child: Builder(builder: (context) {
            var totalInventoryItems = this._models.length;
            var totalSum = 0.0;
            this._models.forEach((m) => totalSum +=
                ((m as InventoryModel).costPerUnit *
                    (m as InventoryModel).currentQuantity));

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
                    '$totalInventoryItems',
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
                    "$totalSum",
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
