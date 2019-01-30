// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'framework/modelfactory.dart';
import 'framework/storefactory.dart';
import 'framework/filestorage.dart';
import 'package:path_provider/path_provider.dart';
import 'framework/jsonstore.dart';
import 'inventory/inventorymodel.dart';

class Config {
  final Map<String, String> _modelStoreConfig = {"InventoryModel": "JsonStore"};

  final Map<String, CreateModelFunction> _generators = {
    "InventoryModel": InventoryModel.fromJson
  };

  static final Config _instance = new Config._();
  Config._();

  factory Config() {
    return _instance;
  }

  String getModelStore(String modelName) {
    return _modelStoreConfig.containsKey(modelName)
        ? _modelStoreConfig[modelName]
        : '';
  }

// Initialize stores as per the configuration in the class.
  void initialize() {
    _modelStoreConfig.forEach((key, val) {
      switch (val) {
        case "JsonStore":
          StoreFactory().attach(
              key,
              new JsonStore(
                  modelName: key,
                  storage: FileStorage(
                      "inventory.json", getApplicationDocumentsDirectory)));
          break;
      }
    });

    this._generators.forEach((modelname, func) {
      ModelFactory.instance.attach(modelname, func);
    });
  }
}
