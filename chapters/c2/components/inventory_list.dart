// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:fluttur/inventory/model.dart';
import 'package:fluttur/inventory/store.dart';
import 'package:fluttur/components/inventory_item.dart';

class InventoryList extends StatelessWidget {
  final List<Model> models;
  final String listName;
  final Store itemStore;
  InventoryList(this.itemStore, this.models, this.listName);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        key: Key(listName),
        itemCount: models.length,
        itemBuilder: (BuildContext context, int index) {
          Model model = models[index];
          return InventoryItem(itemStore, model);
        });
  }
}
