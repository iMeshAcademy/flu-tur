// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:path_provider/path_provider.dart';
import 'package:fluttur/inventory/storage/filestorage.dart';

import 'package:fluttur/inventory/jsonstore.dart';
import 'package:fluttur/inventory/storefactory.dart';

class Config {
  final Map<String, String> _modelStoreConfig = {"InventoryModel": "JsonStore"};
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
                  storage: const FileStorage(
                      "inventory.json", getApplicationDocumentsDirectory)));
          break;
      }
    });
  }
}
