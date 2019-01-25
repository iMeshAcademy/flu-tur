// Copyright (c) 2019, iMeshAcademy authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:fluttur/inventory/store.dart';
import 'package:fluttur/inventory/jsonstore.dart';
import 'package:fluttur/inventory/config.dart';

/// Dart doesn't support reflection. A better way to create stores dynamically was to use reflection.
/// Instead, we will use the old school method - This is proven and should work any day.
///
/// Use this class to get an instance of a store from anywher in your class.
/// Store manager might require a configuration to configure store for the very first time.
/// Later on, the stores can be accessed using the store name.
/// Stores are created only once for a particular modeltype.
///
///

// TODO - Support multiple model for a same store type.

class StoreFactory {
  static final StoreFactory _instance = new StoreFactory._internal();

  // Stores are created for individual models.
  // These store names are pulled from config.
  // First item in the store entry is the model name,
  // for which store needed to be created.
  Map<String, Store> _stores = Map<String, Store>();

  factory StoreFactory() {
    return _instance;
  }

  StoreFactory._internal();

  Store configure(Map<String, Object> jsonData) {
    if (null == jsonData || false == jsonData.containsKey("modelName")) {
      throw new Exception("Failed to configure store. "
          " Make sure modelName is supplied in the config param.");
    }

    String modelName = jsonData['modelName'];
    String storeName = Config().getModelStore(modelName);

    if (this._stores.containsKey(modelName)) {
      return this._stores[modelName];
    }

    Store st;

    switch (storeName) {
      case "JsonStore":
        st = new JsonStore(modelName: modelName, storage: jsonData["storage"]);
        break;
    }

    if (null != st) {
      this._stores[modelName] = st;
    }

    return st;
  }

  // Get the store using the model name.
  // This is very easy to support multiple models.
  Store get(String modelName) =>
      this._stores.containsKey(modelName) ? this._stores[modelName] : null;
}
