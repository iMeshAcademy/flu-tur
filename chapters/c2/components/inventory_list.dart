// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'inventory_item.dart';
import '../framework/model.dart';
import '../framework/store.dart';

class InventoryList extends StatelessWidget {
  final Store store;
  final List<Model> models;
  final String listName;

  InventoryList(this.store, this.models, this.listName);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        key: Key(listName),
        itemCount: models.length,
        itemBuilder: (BuildContext context, int index) {
          Model model = models[index];
          return InventoryItem(model, store);
        });
  }
}
