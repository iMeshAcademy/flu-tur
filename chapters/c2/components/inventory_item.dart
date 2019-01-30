// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import '../framework/store.dart';
import '../framework/storefactory.dart';
import '../inventory/inventorymodel.dart';
import '../inventory/units.dart';
import '../pages/add_edit_inventory.dart';

class InventoryItem extends StatelessWidget {
  final Store store;
  final InventoryModel model;

  InventoryItem(this.model, this.store);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(model.key),
      onDismissed: (DismissDirection direction) async {
        // Just remove the item from the list.
        await store.remove(model);
      },
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return new AddEditInventory(model);
          }));
        },
        title: Text(
          model.itemName,
          key: Key(model.key),
          style: Theme.of(context).textTheme.title,
        ),
        subtitle: Text(
          getDescription(),
          key: Key(model.key),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.subhead,
        ),
        trailing: Row(
          key: Key(model.key),
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                model.updateQuantity(1);
                await model.save();
                // Increase of decrease quantity.
              },
            ),
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () async {
                model.updateQuantity(-1);
                await model.save();
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await StoreFactory().get("InventoryModel").remove(model);
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

    switch (model.unit) {
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

    switch (model.recurrence) {
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

    return "$rec purchase. ${model.currentQuantity} / ${model.requiredQuantity} $unitString left.";
  }
}
