// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:fluttur/inventory/store.dart';
import 'package:fluttur/inventory/inventorymodel.dart';
import 'package:fluttur/inventory/storefactory.dart';
import 'package:fluttur/inventory/units.dart';
import 'package:fluttur/pages/add_edit_inventory.dart';

class InventoryItem extends StatelessWidget {
  final Store itemStore;
  final InventoryModel inventoryModel;
  InventoryItem(this.itemStore, this.inventoryModel);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(inventoryModel.key),
      onDismissed: (DismissDirection direction) async {
        // Just remove the item from the list.
        await itemStore.remove(inventoryModel);
      },
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return AddEditInventory(inventoryModel);
          }));
        },
        title: Text(
          inventoryModel.itemName,
          key: Key(inventoryModel.key),
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Text(
          getDescription(),
          key: Key(inventoryModel.key),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.subhead,
        ),
        trailing: Row(
          key: Key(inventoryModel.key),
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                inventoryModel.updateQuantity(1);
                await inventoryModel.save();
                // Increase of decrease quantity.
              },
            ),
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () async {
                inventoryModel.updateQuantity(-1);
                await inventoryModel.save();
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await StoreFactory()
                    .get("InventoryModel")
                    .remove(inventoryModel);
              },
            )
          ],
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
        ),
        enabled: true,
      ),
    );
  }

  String getDescription() {
    String unitString = '';
    String rec = '';

    switch (inventoryModel.unit) {
      case Unit.Grams:
        unitString = "grams";
        break;

      case Unit.KiloGram:
        unitString = "kilo grams";
        break;

      case Unit.Liter:
        unitString = "liters";
        break;

      case Unit.Units:
        unitString = "units";
        break;
      case Unit.Pounds:
        unitString = "pound";
        break;
      case Unit.Invalid:
        break;
    }

    switch (inventoryModel.recurrence) {
      case Recurrence.BiWeekly:
        rec = "bi-weekly";
        break;

      case Recurrence.Daily:
        rec = "daily";
        break;

      case Recurrence.Monthly:
        rec = "monthly";
        break;

      case Recurrence.Weekly:
        rec = "weekly";
        break;

      case Recurrence.Invalid:
        break;
    }

    return "$rec purchase. ${inventoryModel.currentQuantity} / ${inventoryModel.requiredQuantity} $unitString left.";
  }
}
